import UIKit
import UserNotifications
@_implementationOnly import FirebaseCore
@_implementationOnly import FirebaseMessaging

public class FirebaseMessagingApplicationDelegate: NSObject,
                                                   UIApplicationDelegate {
    
    public lazy var coreDataManager = CoreDataManager()
    public lazy var notificationManager = NotificationManager(coreDataManager: coreDataManager)
    
    @objc public static let shared = FirebaseMessagingApplicationDelegate()
    private let firebaseMessagingDelegate = FirebaseMessagingDelegate()
    private let firebaseConfiguration: FirebaseConfiguration
    
    public var eventDelegate: FirebaseMessagingEventProtocol?
    
    private init(firebaseConfiguration: FirebaseConfiguration = FirebaseConfiguration()) {
        self.firebaseConfiguration = firebaseConfiguration
    }
    
    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        if FirebaseApp.app() == nil && self.firebaseConfiguration.getGoogleServicesPath() != nil {
            // Initialize Firebase SDK
            FirebaseApp.configure()
            Messaging.messaging().delegate = firebaseMessagingDelegate
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }
    
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var result = UIBackgroundFetchResult.noData
        
        if let userInfo = userInfo as? NotificationDictionary {
            result = .newData
            if let aps = userInfo[JSONKeys.aps] as? NotificationDictionary, !aps.keys.contains(JSONKeys.alert) {    // check if it's silent
                self.handle(remoteNotification: userInfo, eventType: .trigger(notification: .silentNotification), forApplication: application)
            }
        }
        
        completionHandler(result)
    }
    
    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
}

// MARK: - UNUserNotificationCenterDelegate Methods
extension FirebaseMessagingApplicationDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        var presentationOptions: UNNotificationPresentationOptions = [.alert, .sound, .badge]
        
        if let userInfo = notification.request.content.userInfo as? NotificationDictionary,
           self.handleAsDialog(defaultNotification: userInfo) {
            presentationOptions = []
        }
        
        completionHandler(presentationOptions)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? NotificationDictionary {
            self.handleClick(onNotification: userInfo)
        }

        completionHandler()
    }
}

// MARK: - MessagingDelegate Methods
private class FirebaseMessagingDelegate: NSObject, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token retrieved: \(String(describing: fcmToken))")
    }
}

// MARK: - FirebaseMessagingApplicationDelegate's Structs and Methods
extension FirebaseMessagingApplicationDelegate {
    typealias NotificationDictionary = [String: Any]
    
    struct JSONKeys {
        static let googleCSenderId = "google.c.sender.id"
        static let gcmMessageId = "gcm.message_id"
        static let googleCFid = "google.c.fid"
        static let googleCAE = "google.c.a.e"
        static let aps = "aps"
        static let alert = "alert"
        static let contentAvailable = "content-available"
        static let timeToLive = "timeToLive"
        static let showDialog = "showDialog"
        static let title = "title"
        static let body = "body"
        static let deepLink = "deepLink"
        
        static let messageID = "messageID"
        static let extraDataList = "extraDataList"
        static let key = "key"
        static let value = "value"
    }
    
    func handle(remoteNotification notification: NotificationDictionary, eventType type: FirebaseEventType, forApplication application: UIApplicationProtocol = UIApplication.shared) {
        guard let data = self.getDataFor(userInfo: notification) else { return }
        if case let .trigger(notificationType) = type, notificationType == .silentNotification, application.getApplicationState() != .active {
            self.saveNotification(userInfo: data)
        } else {
            self.trigger(event: type, forNotification: data)
        }
    }
    
    func handleClick(onNotification notification: NotificationDictionary) {
        if notification.keys.contains(JSONKeys.deepLink) {
            self.handle(remoteNotification: notification, eventType: .click)
        }
    }
    
    func handleAsDialog(defaultNotification notification: NotificationDictionary) -> Bool {
        var result = false
        
        if let showDialogString = notification[JSONKeys.showDialog] as? String,
           let showDialogBool = Bool(showDialogString),
           showDialogBool {
            self.handle(remoteNotification: notification, eventType: .trigger(notification: .defaultNotification))
            result = true
        }
        
        return result
    }
    
    private func getDataFor(userInfo: NotificationDictionary) -> NotificationDictionary? {
        guard let messageID = userInfo[JSONKeys.gcmMessageId] else { return nil }
        var result: NotificationDictionary = [JSONKeys.messageID: messageID]
        
        let fieldsToExclude = [
            JSONKeys.googleCSenderId, JSONKeys.gcmMessageId, JSONKeys.googleCFid, JSONKeys.googleCAE, JSONKeys.aps, JSONKeys.timeToLive,
            JSONKeys.showDialog, JSONKeys.deepLink
        ]
        let extraData = userInfo.filter { !fieldsToExclude.contains($0.key) }.map { [JSONKeys.key: $0.key, JSONKeys.value: $0.value] }
        if !extraData.isEmpty {
            result[JSONKeys.extraDataList] = extraData
        }
        
        if let timeToLive = userInfo[JSONKeys.timeToLive] {
            result[JSONKeys.timeToLive] = timeToLive
        }
        
        if let aps = userInfo[JSONKeys.aps] as? NotificationDictionary, let alert = aps[JSONKeys.alert] as? NotificationDictionary {
            if let title = alert[JSONKeys.title] {
                result[JSONKeys.title] = title
            }
            
            if let body = alert[JSONKeys.body] {
                result[JSONKeys.body] = body
            }
        }
        
        if let deepLink = userInfo[JSONKeys.deepLink] {
            result[JSONKeys.deepLink] = deepLink
        }
        
        return result
    }
    
    private func trigger(event: FirebaseEventType, forNotification notification: NotificationDictionary) {
        // notification has to be filled with at least two elements
        if notification.count > 1,
           let jsonData = try? JSONSerialization.data(withJSONObject: notification),
           let data = String(data: jsonData, encoding: .utf8) {
            self.eventDelegate?.event(event, data: data)
        }
    }
    
    private func saveNotification(userInfo: NotificationDictionary) {
        if let messageID = userInfo[JSONKeys.messageID] as? String,
           let timeToLive = userInfo[JSONKeys.timeToLive] as? String,
           let extraData = userInfo[JSONKeys.extraDataList] as? [NotificationDictionary] {
            
            let notificationDict: [String: Any] = [
                OSNotification.CodingKeys.messageID.rawValue: messageID,
                OSNotification.CodingKeys.timeToLive.rawValue: timeToLive,
                OSNotification.CodingKeys.extraDataList.rawValue: extraData,
                OSNotification.CodingKeys.timeStamp.rawValue: Date().timeIntervalSince1970
            ]
            _ = notificationManager.insertNotification(notificationDict: notificationDict)
        }
    }
    
}

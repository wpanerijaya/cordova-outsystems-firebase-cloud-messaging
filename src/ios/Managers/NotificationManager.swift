import CoreData
import UserNotifications

public protocol NotificationManagerProtocol {
    func insertNotification(notificationDict: [String: Any]) -> Result<Bool, FirebaseMessagingErrors>
    func fetchNotifications() -> Result<[OSNotification], Error>
    func sendLocalNotification(title: String, body: String, badge: Int) async -> Result<Bool, Error>
}

public final class NotificationManager: NSObject {
    
    private let notificationCenter: UNUserNotificationCenterProtocol
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager, notificationCenter: UNUserNotificationCenterProtocol) {
        self.coreDataManager = coreDataManager
        self.notificationCenter = notificationCenter
        super.init()
    }
    
    public convenience init(coreDataManager: CoreDataManager = CoreDataManager()) {
        let currentNotificationCenter = UNUserNotificationCenter.current()
        self.init(coreDataManager: coreDataManager,
                  notificationCenter: currentNotificationCenter)
    }
    
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        do {
            return try await self.notificationCenter.requestAuthorization(options: options)
        } catch {
            throw FirebaseMessagingErrors.requestPermissionsError
        }
    }
    
    func removeAllDeliveredNotifications() {
        self.notificationCenter.removeAllDeliveredNotifications()
    }
    
    public func sendLocalNotification(title: String, body: String, badge: Int) async -> Result<Bool, Error> {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = badge as NSNumber
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "\(Int.random(in: 0 ... 1000))"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        do {
            _ = try await self.notificationCenter.addRequest(request: request)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
}

extension NotificationManager: NotificationManagerProtocol {
    
    public func deletePendingNotifications(_ notifications: [OSNotification]) -> Result<Bool, Error> {
        let fetchRequest: NSFetchRequest<OSNotification> = OSNotification.fetchRequest()
        do {
            let fetchRequestResults = try self.coreDataManager.fetch(fetchRequest)
            let filtered = fetchRequestResults.filter({ notifications.contains($0) })
            if !filtered.isEmpty {
                for item in filtered {
                    self.coreDataManager.context().delete(item)
                }
            }
            try self.coreDataManager.saveContext()
        } catch {
            return .failure(error)
        }
        return .success(true)
    }
    
    public func insertNotification(notificationDict: [String: Any]) -> Result<Bool, FirebaseMessagingErrors> {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = self.coreDataManager.context()
        do {
            let notificationData = try JSONSerialization.data(withJSONObject: notificationDict)
            _ = try decoder.decode(OSNotification.self, from: notificationData)
            
            try self.coreDataManager.saveContext()
        } catch {
            return .failure(.errorInsertingNotifications)
        }
        
        return .success(true)
    }
    
    public func fetchNotifications() -> Result<[OSNotification], Error> {
        let fetchRequest: NSFetchRequest<OSNotification> = OSNotification.fetchRequest()
        do {
            let notifications = try self.coreDataManager.fetch(fetchRequest)
            if !notifications.isEmpty {
                return .success(notifications)
            } else {
                return .success([])
            }
        } catch {
            return .failure(error)
        }
        
    }
    
}

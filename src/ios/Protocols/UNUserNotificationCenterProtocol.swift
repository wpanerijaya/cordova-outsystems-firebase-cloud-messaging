import UserNotifications
import UIKit

protocol UNUserNotificationCenterProtocol {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func removeAllDeliveredNotifications()
    func addRequest(request: UNNotificationRequest) async throws
}

extension UNUserNotificationCenter: UNUserNotificationCenterProtocol {
    
    func addRequest(request: UNNotificationRequest) async throws {
        _ = try await self.add(request)
    }
    
}

public protocol UIApplicationProtocol {
    func getBadge() -> Int 
    func setBadge(badge: Int)
    func getApplicationState() -> UIApplication.State
}

extension UIApplication: UIApplicationProtocol {
        
    public func getBadge() -> Int {
        return UIApplication.shared.applicationIconBadgeNumber
    }
    
    public func setBadge(badge: Int) {
        UIApplication.shared.applicationIconBadgeNumber = badge
    }
    
    public func getApplicationState() -> State {
        return UIApplication.shared.applicationState
    }
    
}

@_implementationOnly import FirebaseCore
@_implementationOnly import FirebaseMessaging
import UserNotifications
import UIKit

public class MessagingManager: MessagingProtocol {

    static let generalTopic = "-general-topic-ios"
    
    public init() {
        // needed init to expose the class
    }
    
    public func getGeneralTopic() -> String {
        return "\(FirebaseApp.app()?.options.gcmSenderID ?? "")\(Self.generalTopic)"
    }
    
    public func getToken() async throws -> String {
        return try await Messaging.messaging().token()
    }
    
    public func deleteToken() async throws {
        try await Messaging.messaging().deleteToken()
    }
    
    public func subscribe(toTopic topic: String) async throws {
        try await Messaging.messaging().subscribe(toTopic: topic)
    }
    
    public func unsubscribe(fromTopic topic: String) async throws {
        try await Messaging.messaging().unsubscribe(fromTopic: topic)
    }

}

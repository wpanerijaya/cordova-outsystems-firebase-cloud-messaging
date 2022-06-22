public protocol MessagingProtocol {
    func getGeneralTopic() -> String
    func getToken() async throws -> String
    func deleteToken() async throws
    func subscribe(toTopic topic: String) async throws
    func unsubscribe(fromTopic topic: String) async throws
}

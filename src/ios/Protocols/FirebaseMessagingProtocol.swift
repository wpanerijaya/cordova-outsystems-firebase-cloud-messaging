public protocol FirebaseMessagingCallbackProtocol {
    func callback(result: String?, error: FirebaseMessagingErrors?)
}

public protocol FirebaseMessagingEventProtocol {
    func event(_ event: FirebaseEventType, data: String)
}

// MARK: - FirebaseMessagingCallbackProtocol Default Implementation
extension FirebaseMessagingCallbackProtocol {
    
    func callbackError(error: FirebaseMessagingErrors) {
        self.callback(result: nil, error: error)
    }
    
    func callback(result: String) {
        self.callback(result: result, error: nil)
    }
    
    func callbackSuccess() {
        self.callback(result: "", error: nil)
    }
    
}


import Foundation
import OSFirebaseMessagingLib

@objc(OSFirebaseCloudMessaging)
class OSFirebaseCloudMessaging: CordovaImplementation {

    var plugin: FirebaseMessagingController?
    var messaging: MessagingManager?
    var callbackId:String=""
    
    override func pluginInitialize() {
        plugin = FirebaseMessagingController(delegate:self, messaging: messaging)
        plugin?.register()
    }
    
    @objc(getToken:)
    func getToken(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        self.plugin?.getToken()
    }
    
    @objc(subscribe:)
    func subscribe(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        
        guard
            let topic = command.arguments[0] as? String
        else {
            self.sendResult(result: "", error:FirebaseMessagingErrors.subscriptionError as NSError, callBackID: self.callbackId)
            return
        }
        
        self.plugin?.subscribe(topic: topic)
    }
    
    @objc(unsubscribe:)
    func unsubscribe(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        
        guard
            let topic = command.arguments[0] as? String
        else {
            self.sendResult(result: "", error:FirebaseMessagingErrors.unsubscriptionError as NSError, callBackID: self.callbackId)
            return
        }
        
        self.plugin?.unsubscribe(fromTopic: topic)
    }

}


extension OSFirebaseCloudMessaging: FirebaseMessagingProtocol {
    func callcack(result: String?, error: FirebaseMessagingErrors?) {
        if let error = error {
            self.sendResult(result: nil, error:error as NSError, callBackID: self.callbackId)
        } else {
            if let result = result {
                self.sendResult(result: result, error:nil , callBackID: self.callbackId)
            }
        }
    }
}

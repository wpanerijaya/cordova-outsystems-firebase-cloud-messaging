import Foundation
import OSFirebaseMessagingLib

@objc(OSFirebaseCloudMessaging)
class OSFirebaseCloudMessaging: CordovaImplementation {

    var plugin: FirebaseMessagingController?
    var callbackId:String=""
    
    override func pluginInitialize() {
        plugin = FirebaseMessagingController(delegate:self, firebaseManager: MessagingManager())
    }
    
    @objc(registerDevice:)
    func registerDevice(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        self.plugin?.registerDevice()
    }
    
    @objc(getToken:)
    func getToken(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        self.plugin?.getToken()
    }
    
    @objc(clearNotifications:)
    func clearNotifications(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        self.plugin?.clearNotifications()
    }
    
    @objc(getBadge:)
    func getBadge(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        self.plugin?.getBadge()
    }
    
    @objc(setBadge:)
    func setBadge(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        
        guard
            let badge = command.arguments[0] as? Int
        else {
            self.sendResult(result: "", error:FirebaseMessagingErrors.settingBadgeNumberError as NSError, callBackID: self.callbackId)
            return
        }
        
        self.plugin?.setBadge(badge:badge)
    }
    
    @objc(subscribe:)
    func subscribe(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        
        guard
            let topic = command.arguments[0] as? String
        else {
            self.sendResult(result: "", error:FirebaseMessagingErrors.gettingBadgeNumberError as NSError, callBackID: self.callbackId)
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
    func callback(result: String?, error: FirebaseMessagingErrors?) {
        if let error = error {
            self.sendResult(result: nil, error:error as NSError, callBackID: self.callbackId)
        } else {
            if let result = result {
                self.sendResult(result: result, error:nil , callBackID: self.callbackId)
            }
        }
    }
}

package com.outsystems.firebase.cloudmessaging;


import android.content.Context
import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingController
import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingInterface
import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingManager
import com.outsystems.plugins.firebasemessaging.controller.FirebaseNotificationManager
import com.outsystems.plugins.firebasemessaging.model.FirebaseMessagingErrors
import com.outsystems.plugins.oscordova.CordovaImplementation
import org.apache.cordova.CallbackContext
import org.json.JSONArray


class OSFirebaseCloudMessaging : CordovaImplementation() {

    override var callbackContext: CallbackContext? = null

    private val CHANNEL_ID = "com.outsystems.firebasecloudmessaging"
    private val KEY = "badge"

    private val controllerDelegate = object: FirebaseMessagingInterface {
        override fun callbackToken(token: String) {
            sendPluginResult(token)
        }
        override fun callbackSuccess() {
            sendPluginResult(true)
        }
        override fun callbackError(error: FirebaseMessagingErrors) {
            sendPluginResult(false, Pair(error.code, error.description))
        }
    }
    private val messaging = FirebaseMessagingManager()
    private val fbNotificationManager = FirebaseNotificationManager()
    private val controller = FirebaseMessagingController(controllerDelegate, messaging, fbNotificationManager)

    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        this.callbackContext = callbackContext
        when (action) {
            "getToken" -> {
                //controller.getToken()
                setBadgeNumber(args)
            }
            "subscribe" -> {
                val topic = ""
                //controller.subscribe(topic)
                getBadgeNumber()
            }
            "unsubscribe" -> {
                val topic = ""
                //controller.unsubscribe(topic)
                clearNotifications()
            }
        }
        return true
    }

    override fun onRequestPermissionResult(requestCode: Int,
                                           permissions: Array<String>,
                                           grantResults: IntArray) {
        TODO("Not yet implemented")
    }

    override fun areGooglePlayServicesAvailable(): Boolean {
        TODO("Not yet implemented")
    }

    private fun getBadgeNumber() {
        val badgeNumber = controller.getBadgeNumber(cordova.activity)
        if(badgeNumber != null){
            sendPluginResult(badgeNumber, null)
        }
        else{
            sendPluginResult(null, null)
        }
    }

    private fun setBadgeNumber(args : JSONArray) {
        val badge = 3
        controller.setBadgeNumber(cordova.activity, badge)
    }

    private fun clearNotifications() {
        controller.clearNotifications(cordova.activity)
    }

    private fun getResourceId(context: Context, typeAndName: String): Int {
        return context.resources.getIdentifier(typeAndName, null, context.packageName)
    }


}
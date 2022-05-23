package com.outsystems.firebase.cloudmessaging;

import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingController
import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingInterface
import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingManager
import com.outsystems.plugins.firebasemessaging.controller.FirebaseNotificationManager
import com.outsystems.plugins.firebasemessaging.controller.NotificationHelper
import com.outsystems.plugins.firebasemessaging.model.FirebaseMessagingError
import com.outsystems.plugins.oscordova.CordovaImplementation
import org.apache.cordova.CallbackContext
import org.json.JSONArray


class OSFirebaseCloudMessaging : CordovaImplementation() {

    override var callbackContext: CallbackContext? = null

    private val controllerDelegate = object: FirebaseMessagingInterface {
        override fun callbackBadgeNumber(badgeNumber: Int){
            sendPluginResult(badgeNumber)
        }
        override fun callbackToken(token: String) {
            sendPluginResult(token)
        }
        override fun callbackSuccess() {
            sendPluginResult(true)
        }
        override fun callbackError(error: FirebaseMessagingError) {
            sendPluginResult(false, Pair(error.code, error.description))
        }
    }
    private val notificationHelper = NotificationHelper()
    private val messaging = FirebaseMessagingManager()
    private val fbNotificationManager = FirebaseNotificationManager(notificationHelper)
    private val controller = FirebaseMessagingController(controllerDelegate, messaging, fbNotificationManager)

    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        this.callbackContext = callbackContext
        when (action) {
            "getToken" -> {
                controller.getToken()
            }
            "subscribe" -> {
                val topic = ""
                controller.subscribe(topic)
            }
            "unsubscribe" -> {
                val topic = ""
                controller.unsubscribe(topic)
            }
            "clearNotifications" -> {
                clearNotifications()
            }
            "sendLocalNotification" -> {
                sendLocalNotification(args)
            }
            "setBadge" -> {
                setBadgeNumber()
            }
            "getBadge" -> {
                getBadgeNumber()
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
        controller.getBadgeNumber(cordova.activity)
    }

    private fun sendLocalNotification(args : JSONArray) {
        val badge = args.get(0).toString().toInt()
        val title = args.get(1).toString()
        val text = args.get(2).toString()
        val channelName = args.get(3).toString()
        val channelDescription = args.get(4).toString()
        controller.sendLocalNotification(cordova.activity, badge, title, text, channelName, channelDescription)
    }

    private fun clearNotifications() {
        controller.clearNotifications(cordova.activity)
    }

    private fun setBadgeNumber() {
        controller.setBadgeNumber()
    }

}
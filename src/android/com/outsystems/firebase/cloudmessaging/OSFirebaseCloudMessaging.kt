package com.outsystems.firebase.cloudmessaging;

import com.outsystems.plugins.sociallogins.CordovaImplementation
import org.apache.cordova.CallbackContext
import org.json.JSONArray

class OSFirebaseCloudMessaging(override var callbackContext: CallbackContext?) : CordovaImplementation() {

    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        when (action) {
            "getToken" -> {
                //doLoginApple(args)
            }
            else -> return false
        }
        return true
    }

    override fun areGooglePlayServicesAvailable(): Boolean {
        TODO("Not yet implemented")
    }

}
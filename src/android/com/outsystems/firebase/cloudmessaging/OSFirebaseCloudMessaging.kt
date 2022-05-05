package com.outsystems.firebase.cloudmessaging;

import android.content.Intent
import com.google.gson.Gson
import com.outsystems.plugins.sociallogins.apple.AppleHelper
import com.outsystems.plugins.sociallogins.apple.SocialLoginsAppleController
import com.outsystems.plugins.sociallogins.facebook.FacebookHelper
import com.outsystems.plugins.sociallogins.facebook.SocialLoginsFacebookController
import com.outsystems.plugins.sociallogins.google.GoogleHelper
import com.outsystems.plugins.sociallogins.google.SocialLoginsGoogleController
import com.outsystems.plugins.sociallogins.linkedin.SocialLoginsLinkedinController
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaInterface
import org.apache.cordova.CordovaWebView
import org.json.JSONArray
import org.json.JSONException

class OSFirebaseCloudMessaging : CordovaImplementation() {

    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        when (action) {
            "loginApple" -> {
                //doLoginApple(args)
            }
            else -> return false
        }
        return true
    }

}
var exec = require('cordova/exec');

exports.getToken = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'getToken');
};

exports.subscribe = function (topic, success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'subscribe', [topic]);
};

exports.unsubscribe = function (topic, success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'unsubscribe', [topic]);
};

exports.clearNotifications = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'clearNotifications');
};

exports.setBadge = function (badge, success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'setBadge', [badge]);
};

exports.getBadge = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'getBadge');
};

exports.registerDevice = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'registerDevice');
};

exports.unregisterDevice = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'unregisterDevice');
};
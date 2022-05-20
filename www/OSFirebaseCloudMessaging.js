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

exports.requestPermission = function ( success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'requestPermission');
};

exports.clearNotifications = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'clearNotifications');
};

exports.setBadge = function (badge, success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'setBadge', [badge, title, body]);
};

exports.sendLocalNotification = function (badge, title, body, success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'sendLocalNotification', [badge, title, body]);
};

exports.getBadge = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'getBadge');
};
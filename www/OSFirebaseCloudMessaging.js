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

exports.sendLocalNotification = function (badge, title, body, channelName, channelDescription, success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'sendLocalNotification', [badge, title, body, channelName, channelDescription]);
};

exports.registerDevice = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'registerDevice');
};

exports.unregisterDevice = function (success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'unregisterDevice');
};

<<<<<<< HEAD
exports.getPendingNotifications = function (clearFromDatabase, success, error) {
    exec(success, error, 'OSFirebaseCloudMessaging', 'getPendingNotifications', [clearFromDatabase]);
};
=======
// Event listener
exports._listener = {};

/**
 * Register callback for given event.
 *
 * @param [ String ]   event    The name of the event.
 * @param [ Function ] callback The function to be exec as callback.
 *
 * @return [ Void ]
 */
 exports.on = function (event, callback) {
    var type = typeof callback;

    if (type !== 'function' && type !== 'string')
        return;

    if (!this._listener[event]) {
        this._listener[event] = [];
    }

    var item = [callback, window];

    this._listener[event].push(item);
};

/**
 * Unregister callback for given event.
 *
 * @param [ String ]   event    The name of the event.
 * @param [ Function ] callback The function to be exec as callback.
 *
 * @return [ Void ]
 */
 exports.un = function (event, callback) {
    var listener = this._listener[event];

    if (!listener)
        return;

    for (var i = 0; i < listener.length; i++) {
        var fn = listener[i][0];

        if (fn == callback) {
            listener.splice(i, 1);
            break;
        }
    }
};

/**
 * Fire the event with given arguments.
 *
 * @param [ String ] event The event's name.
 * @param [ *Array]  args  The callback's arguments.
 *
 * @return [ Void]
 */
 exports.fireEvent = function (event) {
    var args     = Array.apply(null, arguments).slice(1),
        listener = this._listener[event];

    if (!listener)
        return;

    if (args[0] && typeof args[0].data === 'string') {
        args[0].data = JSON.parse(args[0].data);
    }

    for (var i = 0; i < listener.length; i++) {
        var fn    = listener[i][0],
            scope = listener[i][1];

        if (typeof fn !== 'function') {
            fn = scope[fn];
        }

        fn.apply(scope, args);
    }
};
>>>>>>> d90386e65f5f8b148a455fe4ee4542fbcc7d20ef

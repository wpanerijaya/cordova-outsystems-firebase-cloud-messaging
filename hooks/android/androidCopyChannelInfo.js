const path = require('path');
const fs = require('fs');
const plist = require('plist');
const { ConfigParser } = require('cordova-common');

module.exports = function (context) {
    var projectRoot = context.opts.cordova.project ? context.opts.cordova.project.root : context.opts.projectRoot;
    var configXML = path.join(projectRoot, 'config.xml');
    var configParser = new ConfigParser(configXML);
    var channelName = configParser.getPlatformPreference("NotificationChannelDefaultName", "android");
    var channelDescription = configParser.getPlatformPreference("NotificationChannelDefaultDescription", "android");

    var appNamePath = path.join(projectRoot, 'config.xml');
    var appNameParser = new ConfigParser(appNamePath);
    var appName = appNameParser.name();
    var stringsXmlPath = path.join(projectRoot, 'platforms/android/app/src/main/res/values/strings.xml');
    var stringsXmlContents = fs.readFileSync(stringsXmlPath, 'utf8');

    var parser = new DOMParser();
    var xmlDoc = parser.parseFromString(stringsXmlContents);

    newElement = xmlDoc.createElement("string");
    newText = xmlDoc.createTextNode(channelName);
    newElement.appendChild(newText);

    xmlDoc.getElementsByTagName("resources")[0].appendChild(newElement);

    var serializer = new XMLSerializer();
    var xmlString = serializer.serializeToString(xmlDoc);

    fs.writeFileSync(stringsXmlPath, xmlString)
};

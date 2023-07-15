"use strict";

var path = require("path");

var utils = require("./utilities");

var constants = {
  googleServices: "google-services"
};

module.exports = function(context) {
  var cordovaAbove8 = utils.isCordovaAbove(context, 8);
  var cordovaAbove7 = utils.isCordovaAbove(context, 7);
  var defer;
  if (cordovaAbove8) {
    defer = require("q").defer();
  } else {
    defer = context.requireCordovaModule("q").defer();
  }
  
  var platform = context.opts.plugin.platform;
  var platformConfig = utils.getPlatformConfigs(platform);
  if (!platformConfig) {
    utils.handleError("Invalid platform", defer);
  }

  var wwwPath = utils.getResourcesFolderPath(context, platform, platformConfig);
  var sourceFolderPath = utils.getSourceFolderPath(context, wwwPath);
  
  var googleServicesConfigFile = utils.getConfigFile(sourceFolderPath, constants.googleServices, platformConfig.firebaseFileExtension);
  if (!googleServicesConfigFile) {
    utils.handleError("No google services configuration file", defer);
  }
  console.log(googleServicesConfigFile);

  var destFilePath = path.join(context.opts.plugin.dir, constants.googleServices + platformConfig.firebaseFileExtension);
  console.log(destFilePath);

  utils.copyFromSourceToDestPath(defer, googleServicesConfigFile, destFilePath);

  if (cordovaAbove7) {
    var destPath = path.join(context.opts.projectRoot, "platforms", platform, "app");
    if (utils.checkIfFolderExists(destPath)) {
      var destFilePath = path.join(destPath, constants.googleServices + platformConfig.firebaseFileExtension);
      console.log(destFilePath);
      utils.copyFromSourceToDestPath(defer, googleServicesConfigFile, destFilePath);
    }
  }
      
  return defer.promise;
}

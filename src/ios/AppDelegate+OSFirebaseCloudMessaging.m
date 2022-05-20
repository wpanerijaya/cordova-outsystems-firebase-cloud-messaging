#import "AppDelegate+OSFirebaseCloudMessaging.h"
#import <OSFirebaseMessagingLib/OSFirebaseMessagingLib-Swift.h>
#import <objc/runtime.h>

@implementation AppDelegate (OSFirebaseCloudMessaging)

+ (void)load {
    Method original = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
    Method swizzled = class_getInstanceMethod(self, @selector(application:swizzledDidFinishLaunchingWithOptions:));
    method_exchangeImplementations(original, swizzled);
}

- (BOOL)application:(UIApplication *)application swizzledDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self application:application swizzledDidFinishLaunchingWithOptions:launchOptions];    

    (void)[FirebaseMessagingApplicationDelegate.shared application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    (void)[FirebaseMessagingApplicationDelegate.shared application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];

}

@end

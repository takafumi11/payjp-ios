//
//  AppDelegate.m
//  example-objc
//
//  Created by Tatsuya Kitagawa on 2017/12/08.
//  Copyright © 2017年 PAY, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <SafariServices/SafariServices.h>
@import PAYJP;

NSString *const PAYJPPublicKey = @"pk_test_0383a1b8f91e8a6e3ea0e2a9";
NSString *const URLScheme = @"com.exmaple.jp.pay.example-objc";
NSString *const RedirectURLKey = @"ios-app";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  PAYJPSDK.publicKey = PAYJPPublicKey;
  PAYJPSDK.locale = [NSLocale currentLocale];
  PAYJPSDK.tdsRedirectURLKey = RedirectURLKey;

  return YES;
}

- (BOOL)application:(__unused UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
  NSLog(@"openURL => %@", url.absoluteString);

  if ([[url.scheme lowercaseString] isEqualToString:[URLScheme lowercaseString]]) {
    UIViewController *topController =
        [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
      topController = topController.presentedViewController;
    }
    // SFSafariViewControllerであればdismissする
    if ([topController isKindOfClass:[SFSafariViewController class]]) {
      [topController dismissViewControllerAnimated:YES completion:nil];
    }
    // TODO: 続きの処理

    return YES;
  }
  return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for
  // certain types of temporary interruptions (such as an incoming phone call or SMS message) or
  // when the user quits the application and it begins the transition to the background state. Use
  // this method to pause ongoing tasks, disable timers, and invalidate graphics rendering
  // callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store
  // enough application state information to restore your application to its current state in case
  // it is terminated later. If your application supports background execution, this method is
  // called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo
  // many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If
  // the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also
  // applicationDidEnterBackground:.
}

@end

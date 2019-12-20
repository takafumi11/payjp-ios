//
//  UIViewController+Alert.h
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/11/20.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PAYJP;

@interface UIViewController (Alert)

- (void)showToken:(PAYToken *)token;
- (void)showError:(NSError *)error;
- (NSString *)displayToken:(PAYToken *)token;

@end

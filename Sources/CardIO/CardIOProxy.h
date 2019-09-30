//
//  CardIOProxy.h
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/08/08.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CardIOProxy, CardIOCardParams;

@protocol CardIOProxyDelegate
- (void)cardIOProxy:(CardIOProxy *)proxy didFinishWithCardParams:(CardIOCardParams *)cardParams NS_SWIFT_NAME(cardIOProxy(_:didFinishWith:));
- (void)didCancelCardIOProxy:(CardIOProxy *)proxy NS_SWIFT_NAME(didCancel(in:));
@end

@interface CardIOProxy : NSObject

+ (BOOL)isCardIOAvailable;
- (instancetype)initWithDelegate:(id<CardIOProxyDelegate>)delegate;
- (void)presentCardIOFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END

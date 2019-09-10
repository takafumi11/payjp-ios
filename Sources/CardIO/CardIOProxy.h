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
- (void)cardIOProxy:(nonnull CardIOProxy *)proxy didFinishWithCardParams:(nonnull CardIOCardParams *)cardParams;
- (void)didCancelCardIOProxy:(nonnull CardIOProxy *)proxy;
@end

@interface CardIOProxy : NSObject

+ (BOOL)isCardIOAvailable;
- (instancetype)initWithDelegate:(id<CardIOProxyDelegate>)delegate;
- (void)presentCardIOFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END

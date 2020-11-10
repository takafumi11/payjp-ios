//
//  CardIOProxy.m
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/08/08.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//
//  Based on -
//  https://github.com/stripe/stripe-ios/blob/master/Stripe/STPCardIOProxy.m
//

#import "CardIOProxy.h"
#import <TargetConditionals.h>
#import "CardIOCardParams.h"
#if TARGET_OS_IOS

@protocol ClassProxy

+ (Class)proxiedClass;
+ (BOOL)isProxiedClassExists;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@interface CardIOUtilitiesProxy : NSObject <ClassProxy>
+ (BOOL)canReadCardWithCamera;
@end

@implementation CardIOUtilitiesProxy
+ (Class)proxiedClass {
  return NSClassFromString(@"CardIOUtilities");
}

+ (BOOL)isProxiedClassExists {
  Class proxiedClass = [self proxiedClass];
  return proxiedClass && [proxiedClass respondsToSelector:@selector(canReadCardWithCamera)];
}
@end

@interface CardIOCreditCardInfoProxy : NSObject <ClassProxy>
@property(nonatomic, copy, readwrite) NSString *cardNumber;
@property(nonatomic, assign, readwrite) NSUInteger expiryMonth;
@property(nonatomic, assign, readwrite) NSUInteger expiryYear;
@property(nonatomic, copy, readwrite) NSString *cvv;
@end

@implementation CardIOCreditCardInfoProxy
+ (Class)proxiedClass {
  return NSClassFromString(@"CardIOCreditCardInfo");
}

+ (BOOL)isProxiedClassExists {
  Class proxiedClass = [self proxiedClass];
  return proxiedClass && [proxiedClass instancesRespondToSelector:@selector(cardNumber)] &&
         [proxiedClass instancesRespondToSelector:@selector(expiryMonth)] &&
         [proxiedClass instancesRespondToSelector:@selector(expiryYear)] &&
         [proxiedClass instancesRespondToSelector:@selector(cvv)];
}
@end

@interface CardIOPaymentViewControllerProxy : UIViewController <ClassProxy>
/*!
 @param id The parameter here is going to bridge to `CardIOPaymentViewControllerDelegate` at
 runtime.
 */
+ (id)initWithPaymentDelegate:id;
@property(nonatomic, assign, readwrite) BOOL hideCardIOLogo;
@property(nonatomic, assign, readwrite) BOOL disableManualEntryButtons;
@property(nonatomic, assign, readwrite) CGFloat scannedImageDuration;
@end

@implementation CardIOPaymentViewControllerProxy
+ (Class)proxiedClass {
  return NSClassFromString(@"CardIOPaymentViewController");
}

+ (BOOL)isProxiedClassExists {
  Class proxiedClass = [self proxiedClass];
  return proxiedClass &&
         [proxiedClass instancesRespondToSelector:@selector(initWithPaymentDelegate:)] &&
         [proxiedClass instancesRespondToSelector:@selector(setHideCardIOLogo:)] &&
         [proxiedClass instancesRespondToSelector:@selector(setDisableManualEntryButtons:)] &&
         [proxiedClass instancesRespondToSelector:@selector(setScannedImageDuration:)];
}
@end
#pragma clang diagnostic pop

@interface CardIOProxy ()
@property(nonatomic, weak) id<CardIOProxyDelegate> delegate;
@end

@implementation CardIOProxy

+ (BOOL)isCardIOAvailable {
#if TARGET_OS_SIMULATOR
  return NO;
#else
  if ([CardIOPaymentViewControllerProxy isProxiedClassExists] &&
      [CardIOCreditCardInfoProxy isProxiedClassExists] &&
      [CardIOUtilitiesProxy isProxiedClassExists]) {
    return YES;
  }
  return NO;
#endif
}

+ (BOOL)canReadCardWithCamera {
#if TARGET_OS_SIMULATOR
  return NO;
#else
  return [[CardIOUtilitiesProxy proxiedClass] canReadCardWithCamera];
#endif
}

- (instancetype)initWithDelegate:(id<CardIOProxyDelegate>)delegate {
  self = [super init];
  if (self) {
    _delegate = delegate;
  }
  return self;
}

- (void)presentCardIOFromViewController:(UIViewController *)viewController {
  CardIOPaymentViewControllerProxy *cardIOViewController =
      [[[CardIOPaymentViewControllerProxy proxiedClass] alloc] initWithPaymentDelegate:self];
  cardIOViewController.hideCardIOLogo = YES;
  cardIOViewController.disableManualEntryButtons = YES;
  cardIOViewController.scannedImageDuration = 0;
  [viewController presentViewController:cardIOViewController animated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(UIViewController *)scanViewController {
  [scanViewController dismissViewControllerAnimated:YES completion:nil];
  [self.delegate didCancelCardIOProxy:self];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfoProxy *)info
             inPaymentViewController:(UIViewController *)scanViewController {
  [scanViewController
      dismissViewControllerAnimated:YES
                         completion:^{
                           CardIOCardParams *cardParams = [CardIOCardParams new];
                           cardParams.number = info.cardNumber;
                           cardParams.expiryMonth =
                               info.expiryMonth > 0 ? @(info.expiryMonth) : nil;
                           cardParams.expiryYear = info.expiryYear > 0 ? @(info.expiryYear) : nil;
                           cardParams.cvc = info.cvv;
                           [self.delegate cardIOProxy:self didFinishWithCardParams:cardParams];
                         }];
}

@end

#endif

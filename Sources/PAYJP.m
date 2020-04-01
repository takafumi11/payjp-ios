//
//  PAYJP.m
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2018/05/22.
//

#import "PAYJP.h"

NSString *const PAYJPApiEndpoint = @"https://api.zeny.pay-stage.com/v1/";

NSString *const PAYErrorDomain = @"PAYErrorDomain";

NSInteger const PAYErrorInvalidApplePayToken = 0;
NSInteger const PAYErrorSystemError = 1;
NSInteger const PAYErrorInvalidResponse = 2;
NSInteger const PAYErrorServiceError = 3;
NSInteger const PAYErrorInvalidJSON = 4;
NSInteger const PAYErrorFormInvalid = 5;
NSInteger const PAYErrorRequiredThreeDSecure = 6;

NSString *const PAYErrorInvalidApplePayTokenObject = @"PAYErrorInvalidApplePayToken";
NSString *const PAYErrorSystemErrorObject = @"PAYErrorSystemErrorObject";
NSString *const PAYErrorInvalidResponseObject = @"PAYErrorInvalidResponseObject";
NSString *const PAYErrorServiceErrorObject = @"PAYErrorServiceErrorObject";
NSString *const PAYErrorInvalidJSONObject = @"PAYErrorInvalidJSONObject";
NSString *const PAYErrorInvalidJSONErrorObject = @"PAYErrorInvalidJSONErrorObject";
NSString *const PAYErrorRequiredThreeDSecureIdObject = @"PAYErrorRequiredThreeDSecureIdObject";

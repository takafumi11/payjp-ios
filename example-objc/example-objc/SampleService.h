//
//  SampleService.h
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/11/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PAYJP;

typedef NS_ENUM(NSInteger, SampleStatus) {
  Complete,
  Error,
};

@interface SampleService : NSObject

+ (SampleService *)sharedService;
- (void)saveCardWithToken:(NSString *)token
               completion:(void (^)(SampleStatus status, NSError *error))completion;

@end

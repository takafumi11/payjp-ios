//
//  SampleService.h
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/11/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PAYJP;

@interface SampleService : NSObject

+ (SampleService *)sharedService;
- (void)saveCardWithToken:(NSString *)token completion:(void (^)(NSError *error))completion;

@end

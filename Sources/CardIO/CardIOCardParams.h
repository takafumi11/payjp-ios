//
//  CardIOCardParams.h
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/09/10.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardIOCardParams : NSObject

@property (nonatomic, copy, nullable) NSString *number;
@property (nonatomic, nullable) NSNumber *expiryMonth;
@property (nonatomic, nullable) NSNumber *expiryYear;
@property (nonatomic, copy, nullable) NSString *cvc;

@end

NS_ASSUME_NONNULL_END

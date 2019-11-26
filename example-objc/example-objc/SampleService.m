//
//  SampleService.m
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/11/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import "SampleService.h"

// TODO: REPLACE WITH YOUR ENDPOINT URL
NSString *const BACKEND_URL = @"";
NSString *const API_PATH = @"/save_card";

@implementation SampleService
static SampleService *shared = nil;

+ (SampleService *)sharedService {
  @synchronized(self) {
    if (!shared) {
      shared = [SampleService new];
    }
  }
  return shared;
}

- (void)saveCardWithToken:(NSString *)token
               completion:(void (^)(NSError *))completion {
  NSMutableDictionary *dict = [NSMutableDictionary new];
  [dict setValue:token forKey:@"card"];
  NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                 options:NSJSONWritingPrettyPrinted
                                                   error:nil];
  NSString *urlString = [BACKEND_URL stringByAppendingFormat:API_PATH];
  NSMutableURLRequest *request = [NSMutableURLRequest new];
  [request setURL:[NSURL URLWithString:urlString]];
  [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
  [request setValue:@"Application/json" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:data];

  NSURLSessionConfiguration *configuration =
      [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
  NSURLSessionDataTask *dataTask = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          NSHTTPURLResponse *httpUrlResponse = (NSHTTPURLResponse *)response;
          NSLog(@"Status code: %ld", httpUrlResponse.statusCode);

          if (httpUrlResponse.statusCode == 201) {
            NSLog(@"SampleService Success.");
            completion(nil);
          } else {
            if (error != nil) {
              NSLog(@"SampleService Error => %@", error);
              completion(error);
            } else {
              NSLog(@"SampleService Error other.");
              NSDictionary *info =
                  @{NSLocalizedDescriptionKey : @"予期しない問題が発生しました。"};
              NSError *error = [NSError errorWithDomain:@"SampleErrorDomain" code:0 userInfo:info];
              completion(error);
            }
          }
        }];

  [dataTask resume];
}

@end

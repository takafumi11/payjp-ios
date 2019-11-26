//
//  ExampleHostViewController.m
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/11/18.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import "ExampleHostViewController.h"
#import "ColorTheme.h"
#import "SampleService.h"
#import "UIViewController+Alert.h"
@import PAYJP;

@interface ExampleHostViewController ()

@end

@implementation ExampleHostViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 3) {
    UIColor *color = RGB(0, 122, 255);
    PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelTextColor:color
                                                                inputTextColor:color
                                                                     tintColor:color
                                                     inputFieldBackgroundColor:nil];
    PAYCardFormViewController *cardFormVc =
        [PAYCardFormViewController createCardFormViewControllerWithStyle:style tenantId:nil];
    cardFormVc.delegate = self;
    [self.navigationController pushViewController:cardFormVc animated:YES];
  }
}

#pragma MARK : PAYCardFormViewControllerDelegate

- (void)cardFormViewController:(PAYCardFormViewController *_Nonnull)_
         didCompleteWithResult:(enum CardFormResult)result {
  __weak typeof(self) wself = self;

  switch (result) {
    case CardFormResultCancel:
      NSLog(@"CardFormResultCancel");
      break;
    case CardFormResultSuccess:
      NSLog(@"CardFormResultSuccess");
      dispatch_async(dispatch_get_main_queue(), ^{
        [wself.navigationController popViewControllerAnimated:YES];
      });
      break;
  }
}

- (void)cardFormViewController:(PAYCardFormViewController *)_
              didProducedToken:(PAYToken *)token
             completionHandler:(void (^)(NSError *_Nullable))completionHandler {
  NSLog(@"token = %@", [self displayToken:token]);

  // サーバにトークンを送信
  SampleService *service = [SampleService sharedService];
  [service saveCardWithToken:token.identifer
                  completion:^(NSError *error) {
                    if (error != nil) {
                      NSLog(@"Failed save card. error = %@", error);
                      completionHandler(error);
                    } else {
                      NSLog(@"Success save card. token = %@", [self displayToken:token]);
                      completionHandler(nil);
                    }
                  }];
}

@end

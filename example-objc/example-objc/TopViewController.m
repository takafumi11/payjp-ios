//
//  TopViewController.m
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/11/18.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import "TopViewController.h"
#import "ColorTheme.h"
#import "UIViewController+Alert.h"
@import PAYJP;

@interface TopViewController ()

@end

@implementation TopViewController

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
         didCompleteWithResult:(enum CardFormResult)didCompleteWithResult {
  __weak typeof(self) wself = self;

  switch (didCompleteWithResult) {
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

- (void)cardFormViewController:(PAYCardFormViewController *_Nonnull)_
              didProducedToken:(PAYToken *_Nonnull)didProducedToken
             completionHandler:(void (^_Nonnull)(NSError *_Nullable))completionHandler {
    
    NSLog(@"token = %@", [self displayToken:didProducedToken]);
    
    // TODO: サーバにトークンを送信
    completionHandler(nil);
}

@end

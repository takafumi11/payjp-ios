//
//  TopViewController.m
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/11/18.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import "TopViewController.h"
#import "ColorTheme.h"
@import PAYJP;

@interface TopViewController ()

@end

@implementation TopViewController

#pragma MARK : -UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 3) {
    UIColor *color = RGB(0, 122, 255);
    PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelTextColor:color
                                                                inputTextColor:color
                                                                     tintColor:color
                                                     inputFieldBackgroundColor:nil];
    PAYCardFormViewController *cardFormVc =
        [PAYCardFormViewController createCardFormViewControllerWithStyle:style tenantId:nil];
    [self.navigationController pushViewController:cardFormVc animated:true];
  }
}

@end

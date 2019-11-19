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
      UIColor *red = RGB(255, 69, 0);
      PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelTextColor:red
                                                                  inputTextColor:red
                                                                       tintColor:red
                                                       inputFieldBackgroundColor:nil];
//      PAYCardFormViewController *nextView = [PAYCardFormViewControllerFactory create:style];
      [self.navigationController pushViewController:nextView animated:true];
  }
}

@end



//
//  CardFormViewExampleViewController.m
//  example-objc
//
//  Created by Li-Hsuan Chen on 2019/07/23.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import "CardFormViewExampleViewController.h"
@import PAYJP;

@interface CardFormViewExampleViewController ()

@property (weak, nonatomic) IBOutlet PAYCardFormView *cardFormView;
@property (weak, nonatomic) IBOutlet UILabel *tokenIdLabel;

@property (strong, nonatomic) PAYAPIClient *payjpClient;

@end

@implementation CardFormViewExampleViewController
@end

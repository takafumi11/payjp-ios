//
//  CardFormViewScrollViewController.m
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/08/28.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import "CardFormViewScrollViewController.h"
@import PAYJP;

@interface CardFormViewScrollViewController ()

@property (weak, nonatomic) IBOutlet PAYCardFormView *cardFormView;
@property (weak, nonatomic) IBOutlet UIButton *createTokenButton;
    
- (IBAction)cardHolderSwitchChanged:(id)sender;
- (IBAction)createToken:(id)sender;
- (IBAction)validateAndCreateToken:(id)sender;
    
@end

@implementation CardFormViewScrollViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardFormView.delegate = self;
}
    
- (void)isValidChangedIn:(PAYCardFormView *)cardFormView {
    BOOL isValid = self.cardFormView.isValid;
    self.createTokenButton.enabled = isValid;
}

- (IBAction)cardHolderSwitchChanged:(UISwitch *)sender {
    self.cardFormView.isHolderRequired = sender.isOn;
}
    
- (IBAction)createToken:(id)sender {
    // TODO: call createToken
}
    
- (IBAction)validateAndCreateToken:(id)sender {
    BOOL isValid = [self.cardFormView validateCardForm];
    if (isValid) {
        // TODO: call createToken
    }
}

@end

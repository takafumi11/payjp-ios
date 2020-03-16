//
//  CardDemoViewController.m
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2020/03/12.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

#import "CardDemoViewController.h"

@interface CardDemoViewController()
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cvcLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *cvcField;

@end

@implementation CardDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cardNumberField.delegate = self;
    _cvcField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentText = textField.text;
    NSString *newText = [currentText stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _cardNumberField) {
        _cardNumberLabel.text = newText;
    } else if (textField == _cvcField) {
        _cvcLabel.text = newText;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _cvcField) {
        [self backFlipCard];
    } else {
        [self flontFlipCard];
    }
}

- (void)backFlipCard {
    _cardView.backgroundColor = UIColor.systemGreenColor;
    self.cardNumberLabel.hidden = YES;
    self.cvcLabel.hidden = NO;
    [UIView transitionWithView:_cardView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
}

- (void)flontFlipCard {
    _cardView.backgroundColor = UIColor.systemBlueColor;
    self.cardNumberLabel.hidden = NO;
    self.cvcLabel.hidden = YES;
    [UIView transitionWithView:_cardView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
}

@end

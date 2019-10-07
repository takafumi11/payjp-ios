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
@property (weak, nonatomic) IBOutlet UITableViewCell *createTokenButton;
    
- (IBAction)cardHolderSwitchChanged:(id)sender;
    
@end

@implementation CardFormViewExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardFormView.delegate = self;
    
    self.createTokenButton.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.createTokenButton setUserInteractionEnabled:NO];
    self.createTokenButton.contentView.alpha = 0.5;
}
    
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section) {
        case 0:
        sectionName = NSLocalizedString(@"example_card_information_section", nil);
        break;
        case 2:
        sectionName = NSLocalizedString(@"example_token_id_section", nil);
        break;
        default:
        break;
    }
    return sectionName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Create Token
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (!self.cardFormView.isValid) {
            return;
        }
        [self createToken];
    }
    // Valdate and Create Token
    if (indexPath.section == 1 && indexPath.row == 2) {
        BOOL isValid = [self.cardFormView validateCardForm];
        if (isValid) {
            [self createToken];
        }
    }
}

- (void)createToken {
    __weak typeof(self) wself = self;
    
    [self.cardFormView createTokenWith:nil
                            completion:
     ^(PAYToken *token, NSError *error) {
         if (error.domain == PAYErrorDomain && error.code == PAYErrorServiceError) {
             id<PAYErrorResponseType> errorResponse = error.userInfo[PAYErrorServiceErrorObject];
             NSLog(@"[errorResponse] %@", errorResponse.description);
         }
         
         if (!token) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 wself.tokenIdLabel.text = nil;
                 [wself showError:error];
             });
             return;
         }
         
         NSLog(@"token = %@", [wself displayToken:token]);
         dispatch_async(dispatch_get_main_queue(), ^{
             wself.tokenIdLabel.text = token.identifer;
             [wself.tableView reloadData];
             [wself showToken:token];
         });
     }];
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)isValidChangedIn:(PAYCardFormView *)cardFormView {
    BOOL isValid = self.cardFormView.isValid;
    if (isValid) {
        self.createTokenButton.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self.createTokenButton setUserInteractionEnabled:YES];
        self.createTokenButton.contentView.alpha = 1.0;
    } else {
        self.createTokenButton.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.createTokenButton setUserInteractionEnabled:NO];
        self.createTokenButton.contentView.alpha = 0.5;
    }
}

- (IBAction)cardHolderSwitchChanged:(UISwitch *)sender {
    self.cardFormView.isHolderRequired = sender.isOn;
    [self.tableView reloadData];
}

#pragma MARK: - Alert

- (void)showToken:(PAYToken *)token {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"success"
                                message:[self displayToken:token]
                                preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleCancel
                      handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showError:(NSError *)error {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"error"
                                message:error.localizedDescription
                                preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleCancel
                      handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma MARK: - misc

- (NSString *)displayToken:(PAYToken *)token {
    return [NSString stringWithFormat:@"id=%@,\ncard.id=%@,\ncard.last4=%@,\ncard.exp=%hhu/%hu\ncard.name=%@",
            token.identifer, token.card.identifer, token.card.last4Number, token.card.expirationMonth, token.card.expirationYear, token.card.name];
}

@end

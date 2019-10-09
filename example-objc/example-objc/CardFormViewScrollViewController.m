//
//  CardFormViewScrollViewController.m
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/08/28.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#import "CardFormViewScrollViewController.h"
#import "ColorTheme.h"
@import PAYJP;

@interface CardFormViewScrollViewController ()

@property (weak, nonatomic) IBOutlet PAYCardFormLabelStyledView *cardFormView;
@property (weak, nonatomic) IBOutlet UIButton *createTokenButton;
@property (weak, nonatomic) IBOutlet UITextField *selectColorField;

- (IBAction)cardHolderSwitchChanged:(id)sender;
- (IBAction)createToken:(id)sender;
- (IBAction)validateAndCreateToken:(id)sender;

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation CardFormViewScrollViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardFormView.delegate = self;
    
    self.list = @[@"Normal", @"Red", @"Blue", @"Dark"];
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    self.selectColorField.delegate = self;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, 40)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(colorSelected:)];
    [toolbar setItems:@[spaceItem, doneItem]];
    
    self.selectColorField.inputView = self.pickerView;
    self.selectColorField.inputAccessoryView = toolbar;
}

-(void)colorSelected:(id)sender {
    [self.selectColorField endEditing:YES];
    NSString *selected = self.list[[self.pickerView selectedRowInComponent:0]];
    self.selectColorField.text = selected;
    ColorTheme theme = GetColorTheme(selected);
    
    switch (theme) {
        case Red:{
            UIColor *red = RGB(255, 69, 0);
            PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelTextColor:red inputTextColor:red tintColor:red];
            [self.cardFormView applyWithStyle:style];
            self.cardFormView.backgroundColor = UIColor.clearColor;
            break;
        }
        case Blue:{
            UIColor *blue = RGB(0, 103, 187);
            PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelTextColor:blue inputTextColor:blue tintColor:blue];
            [self.cardFormView applyWithStyle:style];
            self.cardFormView.backgroundColor = UIColor.clearColor;
            break;
        }
        case Dark:{
            UIColor *white = UIColor.whiteColor;
            UIColor *darkGray = RGB(61, 61, 61);
            PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelTextColor:white inputTextColor:darkGray tintColor:darkGray];
            [self.cardFormView applyWithStyle:style];
            self.cardFormView.backgroundColor = darkGray;
            break;
        }
        default:{
            UIColor *black = UIColor.blackColor;
            UIColor *defaultBlue = RGB(12, 95, 250);
            PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelTextColor:black inputTextColor:black tintColor:defaultBlue];
            [self.cardFormView applyWithStyle:style];
            self.cardFormView.backgroundColor = UIColor.clearColor;
            break;
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.list.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.list[row];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}
    
- (void)isValidChangedIn:(PAYCardFormLabelStyledView *)cardFormView {
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

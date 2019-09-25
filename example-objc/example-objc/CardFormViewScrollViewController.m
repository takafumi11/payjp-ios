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

@property (weak, nonatomic) IBOutlet PAYCardFormViewLabelStyle *cardFormView;
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
    
    self.list = @[@"Nomal", @"Red", @"Blue", @"Dark"];
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
            PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelFontColor:@"ff4500" inputFontColor:@"ff4500" cursorColor:@"ff4500"];
            [self.cardFormView applyWithStyle:style];
            self.cardFormView.backgroundColor = UIColor.clearColor;
            break;
        }
        case Blue:{
            PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelFontColor:@"0000ff" inputFontColor:@"0000ff" cursorColor:@"0000ff"];
            [self.cardFormView applyWithStyle:style];
            self.cardFormView.backgroundColor = UIColor.clearColor;
            break;
        }
        case Dark:{
            PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelFontColor:@"ffffff" inputFontColor:@"3d3d3d" cursorColor:@"3d3d3d"];
            [self.cardFormView applyWithStyle:style];
            self.cardFormView.backgroundColor = [UIColor colorWithRed:(CGFloat)61/255 green:(CGFloat)61/255 blue:(CGFloat)61/255 alpha:1];
            break;
        }
        default:{
            PAYCardFormStyle *style = [[PAYCardFormStyle alloc] initWithLabelFontColor:@"000000" inputFontColor:@"000000" cursorColor:@"0c5ffa"];
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

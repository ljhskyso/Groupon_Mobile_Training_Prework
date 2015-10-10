//
//  TipViewController.m
//  tipcalculator
//
//  Created by Jiheng Lu on 9/27/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"
#import "TableViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UIView *whiteBlockView;
@property (weak, nonatomic) IBOutlet UILabel *billLable;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *separaterLabel;
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipRateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

@property BOOL billAmountExists;
@property float minTipRate;
@property float maxTipRate;
@property float tipRate;
@property float totalAmount;
@property float tipAmount;
@property float billAmount;
@property NSArray *tipValues;

- (IBAction)onTap:(id)sender;
- (void)updateValues;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [self applyDefaults];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateValues];
    
    // set default values
    [self applyDefaults];
    
    // settingbutton
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}
- (IBAction)onHistoryButton:(id)sender {
    _billTextField.text = nil;
    [self.navigationController pushViewController:[[TableViewController alloc] init] animated:YES];
}
- (void)applyDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject *tmp = [defaults objectForKey:@"minTipRate"];
    if (tmp == nil) {
        _minTipRate = 10;
    } else {
        _minTipRate = [defaults floatForKey:@"minTipRate"];
    }
    tmp = [defaults objectForKey:@"maxTipRate"];
    if (tmp == nil) {
        _maxTipRate = 30;
    } else {
        _maxTipRate = [defaults floatForKey:@"maxTipRate"];
    }
    
    _tipValues=[[NSArray alloc] initWithObjects:
                [NSNumber numberWithFloat:_minTipRate],
                [NSNumber numberWithFloat:(_minTipRate + _maxTipRate) / 2],
                [NSNumber numberWithFloat:_maxTipRate],
                nil];
    NSString *seg0 =  [NSString stringWithFormat:@"%0.1f%%", _minTipRate];
    [_tipControl setTitle:seg0 forSegmentAtIndex:0];
    NSString *seg1 =  [NSString stringWithFormat:@"%0.1f%%", (_minTipRate + _maxTipRate) / 2];
    [_tipControl setTitle:seg1 forSegmentAtIndex:1];
    NSString *seg2 =  [NSString stringWithFormat:@"%0.1f%%", _maxTipRate];
    [_tipControl setTitle:seg2 forSegmentAtIndex:2];
    
    _tipRate = [_tipValues[1] floatValue];
    self.tipRateLabel.text = [NSString stringWithFormat:@"%0.2f%%", _tipRate];
    _tipSlider.value = 0.5;
    self.tipControl.selectedSegmentIndex = 1;
    
    _billAmountExists = false;
    _whiteBlockView.alpha = 1;
    
    
    
//    int dis = 150;
    
//    CGRect newFrame0 = self.billTextField.frame;
//    CGRect newFrame1 = self.billLable.frame;
//    CGRect newFrame2 = self.tipAmountLabel.frame;
//    CGRect newFrame3 = self.separaterLabel.frame;
//    CGRect newFrame4 = self.tipRateLabel.frame;
//    CGRect newFrame5 = self.tipLabel.frame;
//    
//    CGRect newFrame10 = self.totalTextLabel.frame;
//    CGRect newFrame11 = self.totalLabel.frame;
//    CGRect newFrame12 = self.tipControl.frame;
//    CGRect newFrame13 = self.tipSlider.frame;
//    CGRect newFrame14 = self.historyButton.frame;
//    CGRect newFrame15 = self.saveButton.frame;
//    
//    newFrame0.origin.y -= dis;
//    newFrame1.origin.y -= dis;
//    newFrame2.origin.y -= dis;
//    newFrame3.origin.y -= dis;
//    newFrame4.origin.y -= dis;
//    newFrame5.origin.y -= dis;
//    
//    newFrame10.origin.y -= dis;
//    newFrame11.origin.y -= dis;
//    newFrame12.origin.y -= dis;
//    newFrame13.origin.y -= dis;
//    newFrame14.origin.y -= dis;
//    newFrame15.origin.y -= dis;
//    
//    self.billTextField.frame = newFrame0;
//    self.billLable.frame = newFrame1;
//    self.tipAmountLabel.frame = newFrame2;
//    self.separaterLabel.frame = newFrame3;
//    self.tipRateLabel.frame = newFrame4;
//    self.tipLabel.frame = newFrame5;
//    
//    self.totalTextLabel.frame = newFrame10;
//    self.totalLabel.frame = newFrame11;
//    self.tipSlider.frame = newFrame12;
//    self.tipControl.frame = newFrame13;
//    self.historyButton.frame = newFrame14;
//    self.saveButton.frame = newFrame15;
    
    self.billTextField.frame = CGRectOffset(self.billTextField.frame, 0, -200);;
    
    
    
}
- (void)updateTipRate {
    _tipRate = [_tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    _tipSlider.value = (_tipRate - _minTipRate) / (_maxTipRate - _minTipRate);
    self.tipLabel.text = [NSString stringWithFormat:@"%0.2f%%", _tipRate];
}
- (void)updateValues {
    _billAmount = [self.billTextField.text floatValue];
    _tipAmount = _billAmount * _tipRate / 100;
    _totalAmount = _tipAmount + _billAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", _tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", _totalAmount];
}
- (void)upateTipRateBoundary {
    _minTipRate = [_tipValues[0] floatValue];
    _maxTipRate = [_tipValues[2] floatValue];
}

- (IBAction)sliderValueChanged:(id)sender {
    _tipRate = _tipSlider.value * (_maxTipRate - _minTipRate) + _minTipRate;
    self.tipRateLabel.text = [NSString stringWithFormat:@"%0.2f%%", _tipRate];
    [self updateValues];
    
    if (_tipRate <= (_maxTipRate-_minTipRate)/3+_minTipRate) {
        _tipControl.selectedSegmentIndex = 0;
    } else if (_tipRate >= (_maxTipRate-_minTipRate)*2/3+_minTipRate) {
        _tipControl.selectedSegmentIndex = 2;
    } else {
        _tipControl.selectedSegmentIndex = 1;
    }

}
- (IBAction)controlValueChanged:(id)sender {
    [self.view endEditing:YES];
    [self updateTipRate];
    [self updateValues];
    self.tipRateLabel.text = [NSString stringWithFormat:@"%0.2f%%", _tipRate];

}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateTipRate];
    [self updateValues];
}
- (IBAction)saveOnTap:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *data_entry = [NSMutableArray arrayWithObjects:
                         [NSNumber numberWithFloat:_billAmount],
                         [NSNumber numberWithFloat:_tipAmount],
                         [NSNumber numberWithFloat:_tipRate],
                         [NSNumber numberWithFloat:_totalAmount],nil];
    NSArray *obj = [defaults objectForKey:@"history"];
    NSMutableArray *history = [NSMutableArray arrayWithArray:obj];
    
    [history addObject:data_entry];
    [defaults setObject:history forKey:@"history"];
    
    [defaults synchronize];
    
    _billTextField.text = nil;
    
    NSLog(@"%@", history);
    NSLog(@"%lu",(unsigned long)history.count);
}


- (IBAction)billTextDidChange:(id)sender {
    if (_billAmountExists == false) {
        _billAmountExists = true;
        [self buttonSideAnimation:true];
    } else if (_billTextField.text.length == 0) {
        _billAmountExists = false;
        [self buttonSideAnimation:false];
    }
}

- (void)buttonSideAnimation:(bool) go_down {
    
    CGRect newFrame0 = self.billTextField.frame;
    CGRect newFrame1 = self.billLable.frame;
    CGRect newFrame2 = self.tipAmountLabel.frame;
    CGRect newFrame3 = self.separaterLabel.frame;
    CGRect newFrame4 = self.tipRateLabel.frame;
    CGRect newFrame5 = self.tipLabel.frame;
    
    CGRect newFrame10 = self.totalTextLabel.frame;
    CGRect newFrame11 = self.totalLabel.frame;
    CGRect newFrame12 = self.tipControl.frame;
    CGRect newFrame13 = self.tipSlider.frame;
    CGRect newFrame14 = self.historyButton.frame;
    CGRect newFrame15 = self.saveButton.frame;

    
    
    
    UIColor *color;
    int dis = 150;
    
    if (go_down) {
        newFrame0.origin.y -= dis;
        newFrame1.origin.y -= dis;
        newFrame2.origin.y -= dis;
        newFrame3.origin.y -= dis;
        newFrame4.origin.y -= dis;
        newFrame5.origin.y -= dis;

        newFrame10.origin.y -= dis;
        newFrame11.origin.y -= dis;
        newFrame12.origin.y -= dis;
        newFrame13.origin.y -= dis;
        newFrame14.origin.y -= dis;
        newFrame15.origin.y -= dis;
        
        color = [UIColor  cyanColor];
    } else {
        newFrame0.origin.y += dis;
        newFrame1.origin.y += dis;
        newFrame2.origin.y += dis;
        newFrame3.origin.y += dis;
        newFrame4.origin.y += dis;
        newFrame5.origin.y += dis;

        newFrame10.origin.y += dis;
        newFrame11.origin.y += dis;
        newFrame12.origin.y += dis;
        newFrame13.origin.y += dis;
        newFrame14.origin.y += dis;
        newFrame15.origin.y += dis;
        
        color = [UIColor whiteColor];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
//        self.billTextField.frame = newFrame0;
//        self.billLable.frame = newFrame1;
//        self.tipAmountLabel.frame = newFrame2;
//        self.separaterLabel.frame = newFrame3;
//        self.tipRateLabel.frame = newFrame4;
//        self.tipLabel.frame = newFrame5;

        self.view.backgroundColor = color;
        self.whiteBlockView.alpha = go_down ? 0 : 1;
        self.whiteBlockView.backgroundColor = color;
    } completion:^(BOOL finished) {
    }];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.totalTextLabel.frame = newFrame10;
//        self.totalLabel.frame = newFrame11;
//        self.tipSlider.frame = newFrame12;
//        self.tipControl.frame = newFrame13;
//        self.historyButton.frame = newFrame14;
//        self.saveButton.frame = newFrame15;
//    } completion:^(BOOL finished) {
//    }];
}

@end

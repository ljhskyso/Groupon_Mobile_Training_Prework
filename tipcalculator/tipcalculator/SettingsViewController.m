//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Jiheng Lu on 9/30/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *minDefault;
@property (weak, nonatomic) IBOutlet UITextField *maxDefault;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.minLabel.text = [NSString stringWithFormat:@"%0.1f%%", [defaults floatForKey:@"minTipRate"]];
    self.maxLabel.text = [NSString stringWithFormat:@"%0.1f%%", [defaults floatForKey:@"maxTipRate"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveOnTap:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:_minDefault.text.floatValue forKey:@"minTipRate"];
    [defaults setFloat:_maxDefault.text.floatValue forKey:@"maxTipRate"];
    [defaults synchronize];
    
    self.minLabel.text = [NSString stringWithFormat:@"%0.1f%%", _minDefault.text.floatValue];
    self.maxLabel.text = [NSString stringWithFormat:@"%0.1f%%", _maxDefault.text.floatValue];
    
    [self resetOnTap:nil];
}
- (IBAction)resetOnTap:(id)sender {
    _minDefault.text = nil;
    _maxDefault.text = nil;
}
@end

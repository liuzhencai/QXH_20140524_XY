//
//  MsgSettingController.m
//  QXH
//
//  Created by ZhaoLilong on 6/29/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MsgSettingController.h"

@interface MsgSettingController ()

@end

@implementation MsgSettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchStatus:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch.tag == 1) {
        NSLog(@"switch--->%d",mySwitch.on);
        if (mySwitch.on) {
            [UIView animateWithDuration:0.25 animations:^{
                _msgSettingView.alpha = 1.0;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                _msgSettingView.alpha = 0;
            }];
        }
    }
}

@end

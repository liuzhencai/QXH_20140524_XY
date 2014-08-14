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
    self.title = @"消息提醒";
    UISwitch *remindSwitch = (UISwitch *)[self.view viewWithTag:1];
    remindSwitch.on = [[defaults objectForKey:@"enableRemind"] boolValue];
    if (remindSwitch.on) {
        _msgSettingView.alpha = 1;
    }else{
        _msgSettingView.alpha = 0;
    }
    UISwitch *ringSwitch = (UISwitch *)[self.view viewWithTag:2];
    ringSwitch.on = [[defaults objectForKey:@"enableRing"] boolValue];
    UISwitch *shakeSwitch = (UISwitch *)[self.view viewWithTag:3];
    shakeSwitch.on = [[defaults objectForKey:@"enableShake"] boolValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchStatus:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    NSLog(@"switch--->%d",mySwitch.on);
    switch (mySwitch.tag) {
        case 1:
        {
            [defaults setObject:[NSNumber numberWithBool:mySwitch.on] forKey:@"enableRemind"];
            [defaults synchronize];
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
            break;
        case 2:
        {
            [defaults setObject:[NSNumber numberWithBool:mySwitch.on] forKey:@"enableRing"];
            [defaults synchronize];
        }
            break;
        case 3:
        {
            [defaults setObject:[NSNumber numberWithBool:mySwitch.on] forKey:@"enableShake"];
            [defaults synchronize];
        }
            break;
        default:
            break;
    }
}

@end

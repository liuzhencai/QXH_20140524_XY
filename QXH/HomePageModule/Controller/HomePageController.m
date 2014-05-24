//
//  HomePageController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "HomePageController.h"
//#import "ActivityController.h"
//#import "FindPeopleController.h"
#import "OneDreamController.h"
#import "SquareViewController.h"
#import "EverydayAskController.h"
#import "InfluenceViewController.h"
#import "InformationViewController.h"
#import "FindPeopleViewController.h"
#import "ActivityViewController.h"
#import "TribeController.h"


@interface HomePageController ()

@end

@implementation HomePageController

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
    self.hidesBottomBarWhenPushed = NO;
    // Do any additional setup after loading the view from its nib.
    self.title = @"首页";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    
    UIButton *btn  = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击资讯");
            InformationViewController* ainfor = [[InformationViewController alloc]initWithNibName:@"InformationViewController" bundle:nil];
            ainfor.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ainfor animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"点击活动");
//            ActivityController *aController = [[ActivityController alloc] initWithNibName:@"ActivityController" bundle:nil];
//            [self.navigationController pushViewController:aController animated:YES];
            ActivityViewController *activeCon = [[ActivityViewController alloc] init];
            [self.navigationController pushViewController:activeCon animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"点击找人");
//            FindPeopleController *fpController = [[FindPeopleController alloc] initWithNibName:@"FindPeopleController" bundle:nil];
//            [self.navigationController pushViewController:fpController animated:YES];
            
            FindPeopleViewController *fpController = [[FindPeopleViewController alloc] init];
            [self.navigationController pushViewController:fpController animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"点击直播间");
            OneDreamController *odController = [[OneDreamController alloc] initWithNibName:@"OneDreamController" bundle:nil];
            [self.navigationController pushViewController:odController animated:YES];
        }
            break;
        case 5:
        {
            NSLog(@"点击部落");
            TribeController *tribeVC = [[TribeController alloc] init];
            [self.navigationController pushViewController:tribeVC animated:YES];
        }
            break;
        case 6:
        {
            NSLog(@"点击广场");
            SquareViewController *svController = [[SquareViewController alloc] initWithNibName:@"SquareViewController" bundle:nil];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 7:
        {
            NSLog(@"点击每日一问");
            EverydayAskController *eaController = [[EverydayAskController alloc] initWithNibName:@"EverydayAskController" bundle:nil];
            [self.navigationController pushViewController:eaController animated:YES];
        }
            break;
        case 8:
        {
            NSLog(@"点击影响力");
            InfluenceViewController *ivController = [[InfluenceViewController alloc] initWithNibName:@"InfluenceViewController" bundle:nil];
            [self.navigationController pushViewController:ivController animated:YES];
        }
            break;
        default:
            break;
    }
    
}

@end

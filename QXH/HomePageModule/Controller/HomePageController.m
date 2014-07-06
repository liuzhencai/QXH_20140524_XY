//
//  HomePageController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "HomePageController.h"
#import "OneDreamController.h"
#import "SquareViewController.h"
#import "EverydayAskController.h"
#import "InfluenceViewController.h"
#import "InformationViewController.h"
#import "FindPeopleViewController.h"
#import "ActivityViewController.h"
#import "TribeController.h"
#import "chatRoomActivViewController.h"
#import "ChatController.h"
#import "FillNameCardViewController.h"
#import "LoginViewController.h"
#import "MessageBySend.h"
#import "UserInfoModelManger.h"
//#import "PullRefreshTableViewController.h"


@interface HomePageController ()<LoginDelegate>
{
    NSArray *pics;
}

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
    self.navigationItem.titleView = _topView;
    pics = @[@"banner_img02", @"banner_img01"];
    _topScroll.contentSize = CGSizeMake(320*pics.count, 132);
    [self addTopImage];
    
    if (![defaults objectForKey:USER_NAME] || ![defaults objectForKey:PASSWORLD]) {
        LoginViewController* login = [[LoginViewController alloc]init];
        login.delegate = self;
        UINavigationController *loginNavigation = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:loginNavigation animated:NO completion:nil];
    }else{//自动登录
        [self autoLogin];
    }
}

#pragma mark - loginDelegate
- (void)didLoginHandle:(LoginViewController *)loginViewController{
    NSLog(@"dddddddd");
    BOOL isNewMember = [[defaults objectForKey:@"isNewMember"] boolValue];
    if (isNewMember) {
        [defaults setObject:@NO forKey:@"isNewMember"];
        [defaults synchronize];
        FillNameCardViewController *fillNameCard = [[FillNameCardViewController alloc] init];
        [self.navigationController pushViewController:fillNameCard animated:YES];
    }
    
    NSLog(@"userid--->%@,token--->%@",[defaults objectForKey:@"userid"],[defaults objectForKey:@"token"]);
    if ([defaults objectForKey:@"userid"]) {
        /*获取个人信息，并储存起来*/
        [[UserInfoModelManger sharUserInfoModelManger]getUserInfo:^(UserInfoModel* user)
         {
             NSLog(@"获取到用户信息");
             _welcomeLabel.text = [NSString stringWithFormat:@"%@，欢迎您！",user.displayname];
             //             [_portraitView setImageWithURL:IMGURL([dict objectForKey:@"photo"]) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
             _portraitView.image = user.iconImageview.image;
             [_portraitView circular];
         }];
        
        //        [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict) {
        //            [self setTopViewValue:dict];
        //        }];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
}

- (void)autoLogin
{//自动登录
    NSString *name = [defaults objectForKey:@"userName"];
    NSString *passward = [defaults objectForKey:@"passworld"];
    [DataInterface login:name andPswd:passward withCompletinoHandler:^(NSMutableDictionary *dict) {
        //登录成功后保存用户名和密码
//        [defaults setObject:self.nameField.text forKey:USER_NAME];
//        [defaults setObject:self.pwField.text forKey:PASSWORLD];
        [defaults setObject:[dict objectForKey:@"userid"] forKey:@"userid"];
        [defaults setObject:@NO forKey:@"isNewMember"];
        NSDate *date = [NSDate date];
        [defaults setObject:date forKey:LOGIN_DATE];
        [defaults synchronize];
        NSLog(@"登陆返回信息：%@",dict);
        
        NSLog(@"userid--->%@,token--->%@",[defaults objectForKey:@"userid"],[defaults objectForKey:@"token"]);
        if ([defaults objectForKey:@"userid"]) {
//            /*获取个人信息，并储存起来*/
            [[UserInfoModelManger sharUserInfoModelManger]getUserInfo:^(UserInfoModel* user)
             {
                 NSLog(@"获取到用户信息");
                 _welcomeLabel.text = [NSString stringWithFormat:@"%@，欢迎您！",user.displayname];
                 //             [_portraitView setImageWithURL:IMGURL([dict objectForKey:@"photo"]) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
                 _portraitView.image = user.iconImageview.image;
                 [_portraitView circular];
             }];
        }
        
//        [self showAlert:[dict objectForKey:@"info"]];

        [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
        
        /*获取系统消息*/
           [MessageBySend sharMessageBySend];
    }];
}

- (void)setTopViewValue:(NSDictionary *)dict
{
    _welcomeLabel.text = [NSString stringWithFormat:@"%@，欢迎您！",[dict objectForKey:@"displayname"]];
    [_portraitView setImageWithURL:IMGURL([dict objectForKey:@"photo"]) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [_portraitView circular];
}

// 心跳
- (void)heartBeat
{
    [DataInterface heartBeatWithCompletionHandler:^(NSMutableDictionary *dict) {
    }];
}

- (void)addTopImage
{
//    [DataInterface getHomePageAdsWithCompletionHandler:^(NSMutableDictionary *dict) {
//        
//    }];

    for (int i = 0; i < pics.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 173)];
        image.image = [UIImage imageNamed:pics[i]];
        [_topScroll addSubview:image];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (int)scrollView.contentOffset.x/320;
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
            ActivityViewController *activeCon = [[ActivityViewController alloc] init];
            activeCon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activeCon animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"点击找人");
            FindPeopleViewController *fpController = [[FindPeopleViewController alloc] init];
            fpController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fpController animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"点击直播间");
            OneDreamController *odController = [[OneDreamController alloc] initWithNibName:@"OneDreamController" bundle:nil];
            odController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:odController animated:YES];
        }
            break;
        case 5:
        {
            NSLog(@"点击部落");
            TribeController *tribeVC = [[TribeController alloc] init];
            tribeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tribeVC animated:YES];
        }
            break;
        case 6:
        {
            NSLog(@"点击广场");
            SquareViewController *svController = [[SquareViewController alloc] initWithNibName:@"SquareViewController" bundle:nil];
            svController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svController animated:YES];
        }
            break;
        case 7:
        {
            NSLog(@"点击每日一问");
            EverydayAskController *eaController = [[EverydayAskController alloc] initWithNibName:@"EverydayAskController" bundle:nil];
            eaController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:eaController animated:YES];
        }
            break;
        case 8:
        {
            NSLog(@"点击影响力");
//            InfluenceViewController *ivController = [[InfluenceViewController alloc] initWithNibName:@"InfluenceViewController" bundle:nil];
//            ivController.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:ivController ani
//            ChatController *controller = [[ChatController alloc] initWithCustomView:tempView];
            
            
//            ChatController *controller = [[ChatController alloc]init];
//           
//            controller.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:controller animated:YES];

            
//             NSString* name = @"刘振财测试1";
//            [DataInterface modifyUserInfo:ORIGIN_VAL oldpwd:ORIGIN_VAL newpwd:ORIGIN_VAL signature:ORIGIN_VAL title:job degree:ORIGIN_VAL address:ORIGIN_VAL domicile:ORIGIN_VAL introduce:ORIGIN_VAL comname:ORIGIN_VAL comdesc:ORIGIN_VAL comaddress:ORIGIN_VAL comurl:ORIGIN_VAL induname:ORIGIN_VAL indudesc:ORIGIN_VAL schoolname:schoolname schooltype:ORIGIN_VAL sex:ORIGIN_VAL email:ORIGIN_VAL tags:ORIGIN_VAL attentiontags:ORIGIN_VAL hobbies:ORIGIN_VAL educations:ORIGIN_VAL honours:ORIGIN_VAL withCompletionHandler:^(NSMutableDictionary *dict) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
        }
            break;
        default:
            break;
    }
    
}

//#pragma mark chatcontroller
//- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message
//{
//    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
//    //    NSLog(@"Message Contents: %@", message[kMessageContent]);
//    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
//    
//    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
//    message[@"sentByUserId"] = @"currentUserId";
//    icout++;
//    
//    message[@"kMessageRuntimeSentBy"] = [NSNumber numberWithInt:((icout%2)?kSentByUser:kSentByOpponent)];
//    
//    // Must add message to controller for it to show
//    [chatController addNewMessage:message];
//}


@end

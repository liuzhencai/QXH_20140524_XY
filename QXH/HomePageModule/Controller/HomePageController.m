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
#import "GuideView.h"
#import "AppDelegate.h"
#import "ActivityDetailViewController.h"
#import "AdVIewController.h"
#import "InformationDetailController.h"
#import "Tool.h"
//#import "PullRefreshTableViewController.h"


#define NoMoneyMember @"您还不是正式会员，没有权限进入该功能"

@interface HomePageController ()<LoginDelegate,GuideViewDelegate>
{
    NSArray *pics;
    BOOL flag;
}

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *ads;

@end

#define FIRST_LAUNCH @"isFirstLaunch"

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
    if (iPhone5) {
        self.view = self.viewfour;
    }else
    {
        
        self.view = self.viewThree;
//        [self.view addSubview:self.viewThree];
//        [self.view addSubview self.viewThree];
    }
    self.hidesBottomBarWhenPushed = NO;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = _topView;
//    pics = @[@"banner_img02", @"banner_img01"];
//    _topScrollfour.contentSize = CGSizeMake(320*pics.count, 132);
//    _topScrollthree.contentSize = CGSizeMake(320*pics.count, 132);
//    [self addTopImage];
    
    [self loadPage];
}

- (void)loadPage
{
    if (![defaults objectForKey:USER_NAME] || ![defaults objectForKey:PASSWORLD]) {
        //login
        LoginViewController* login = [[LoginViewController alloc]init];
        login.delegate = self;
        UINavigationController *loginNavigation = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:loginNavigation animated:NO completion:nil];
    }else{//自动登录
        [self autoLogin];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!IOS7_OR_LATER) {
//        AppDelegate* dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        [dele.tabController hideTabBar:NO];
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
             NSLog(@"获取到用户信息--->%@",user.displayname);
//             _welcomeLabel.text = [NSString stringWithFormat:@"%@，欢迎您！",user.displayname];
             _welcomeLabel.text = @"欢迎来到校长会";
             [_portraitView setImageWithURL:IMGURL(user.photo) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
           
//             _portraitView.image = user.iconImageview.image;
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
             }];
        }
        [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary* dic){
            NSLog(@"dic==%@",dic);
            [self setTopViewValue:dic];
        }];
        [self setHomePageAds];
//        [self showAlert:[dict objectForKey:@"info"]];

        [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
        
        /*获取系统消息*/
           [MessageBySend sharMessageBySend];
        [[MessageBySend sharMessageBySend]getOfflineMessage];
    }];
}

- (void)setHomePageAds
{
    [DataInterface getHomePageAdsWithCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"首页公告--->%@",dict);
        NSArray *list = [dict objectForKey:@"list"];
        __block NSMutableArray *tmpAds = [[NSMutableArray alloc]init];
        if ([list count] > 0) {
            for (int i = 0; i < [list count]; i++) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[list[i] objectForKey:@"desc"], @"desc", [list[i] objectForKey:@"img"], @"img",[list[i] objectForKey:@"target"], @"target",[list[i] objectForKey:@"type"], @"type",nil];
                [tmpAds addObject:dict];
            }
            _ads = tmpAds;
            _pageControl.numberOfPages = _ads.count;
            _pageControlThree.numberOfPages = _ads.count;
            _topScrollfour.contentSize = CGSizeMake(320*_ads.count, 132);
            _topScrollthree.contentSize = CGSizeMake(320*_ads.count, 132);
            _adTitleLabelfour.text = [_ads[0] objectForKey:@"desc"];
            _adTitleLabelThree.text = [_ads[0] objectForKey:@"desc"];
        }
        for (int i = 0; i < _ads.count; i++) {
            @autoreleasepool {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, iPhone5?173:153 )];
                UIControl *control = [[UIControl alloc] initWithFrame:image.bounds];
                control.backgroundColor = [UIColor clearColor];
                control.tag = 5000+i;
                [control addTarget:self action:@selector(clickAd:) forControlEvents:UIControlEventTouchDown];
                [image addSubview:control];
                image.userInteractionEnabled = YES;
                [image setContentMode:UIViewContentModeScaleAspectFill];
                [image setImageWithURL:IMGURL([_ads[i] objectForKey:@"img"])];
                if (iPhone5) {
                    [_topScrollfour addSubview:image];
                }else{
                    [_topScrollthree addSubview:image];
                }
            }
        }
    }];
}

- (void)clickAd:(id)sender
{
    UIControl *control_ = (UIControl *)sender;
    NSInteger index = control_.tag - 5000;
    switch ([[_ads[index] objectForKey:@"type"] integerValue]) {
        case 1:
        {
            // 跳转至广场详情
            
        }
            break;
        case 2:
        {
            // 跳转至智谷详情
            InformationDetailController *controller = [[InformationDetailController alloc] initWithNibName:@"InformationDetailController" bundle:nil];
            controller.artid = [_ads[index] objectForKey:@"target"];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            // 跳转至活动详情
            ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
            activityDetail.activityId = [_ads[index] objectForKey:@"target"];
            [self.navigationController pushViewController:activityDetail animated:YES];
        }
            break;
        case 4:
        {
            // 跳转至自定义webview
            AdVIewController *controller = [[AdVIewController alloc] init];
            controller.url = [_ads[index] objectForKey:@"target"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)setTopViewValue:(NSDictionary *)dict
{
//    _welcomeLabel.text = [NSString stringWithFormat:@"%@，欢迎您！",[dict objectForKey:@"displayname"]];
    _welcomeLabel.text = @"欢迎来到校长会";
    [_portraitView setImageWithURL:IMGURL([dict objectForKey:@"photo"]) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [_portraitView circular];
}

- (void)reConnection
{
    NSString *name = [defaults objectForKey:@"userName"];
    NSString *passward = [defaults objectForKey:@"passworld"];
    [DataInterface login:name andPswd:passward withCompletinoHandler:^(NSMutableDictionary *dict) {
        //登录成功后保存用户名和密码
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
             }];
        }
        [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary* dic){
            NSLog(@"dic==%@",dic);
            [self setTopViewValue:dic];
        }];
        
        /*获取系统消息*/
        [MessageBySend sharMessageBySend];
        [[MessageBySend sharMessageBySend]getOfflineMessage];
    }];
}

- (void)tryReConnect
{
    NSLog(@"%s",__FUNCTION__);
    if (!flag) {
        [self reConnection];
    }
}

// 心跳
- (void)heartBeat
{
    /**
     *  长时间无返回，重新连接，判定时间为30s，若收不到心跳回应，则进行重新连接
     */
    flag = NO;
    if (!_timer) {
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:99999999.f target:self selector:@selector(tryReConnect) userInfo:nil repeats:YES];
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:30.f]];

    [DataInterface heartBeatWithCompletionHandler:^(NSMutableDictionary *dict) {
        flag = YES;
        [_timer setFireDate:[NSDate distantFuture]];
    }];
}

- (void)addTopImage
{
//    [DataInterface getHomePageAdsWithCompletionHandler:^(NSMutableDictionary *dict) {
//        
//    }];

    for (int i = 0; i < pics.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, iPhone5?173:153 )];
        image.image = [UIImage imageNamed:pics[i]];
        if (iPhone5) {
            [_topScrollfour addSubview:image];
        }else{
            [_topScrollthree addSubview:image];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (int)scrollView.contentOffset.x/320;
    _pageControlThree.currentPage = (int)scrollView.contentOffset.x/320;
    _adTitleLabelfour.text = [_ads[_pageControl.currentPage] objectForKey:@"desc"];
    _adTitleLabelThree.text = [_ads[_pageControlThree.currentPage] objectForKey:@"desc"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    
    UIButton *btn  = (UIButton *)sender;
    switch (btn.tag) {
        case 1:        {
            NSLog(@"点击资讯");
            InformationViewController* ainfor = [[InformationViewController alloc]init];
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
            if (![[Tool MoneyMember]isEqualToString:@"0"]) {
                /*只用0是不能访问的*/
                FindPeopleViewController *fpController = [[FindPeopleViewController alloc] init];
                fpController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fpController animated:YES];
            }else{
                [ self showAlert:NoMoneyMember];
            }

        }
            break;
        case 4:
        {
            NSLog(@"点击直播间");
             if (![[Tool MoneyMember]isEqualToString:@"0"]) {
                 OneDreamController *odController = [[OneDreamController alloc] initWithNibName:@"OneDreamController" bundle:nil];
                 odController.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:odController animated:YES];
             }else{
                 [ self showAlert:NoMoneyMember];
             }

        }
            break;
        case 5:
        {
            NSLog(@"点击部落");
            if (![[Tool MoneyMember]isEqualToString:@"0"]) {
                TribeController *tribeVC = [[TribeController alloc] init];
                tribeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tribeVC animated:YES];
            }else{
                [ self showAlert:NoMoneyMember];
             }
        }
            break;
        case 6:
        {
            NSLog(@"点击广场");
            if (![[Tool MoneyMember]isEqualToString:@"0"]) {
                SquareViewController *svController = [[SquareViewController alloc] initWithNibName:@"SquareViewController" bundle:nil];
                svController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:svController animated:YES];
            }else{
                [ self showAlert:NoMoneyMember];
            }
        }
            break;
        case 7:
        {
            NSLog(@"点击每日一问");
            if (![[Tool MoneyMember]isEqualToString:@"0"]) {
                EverydayAskController *eaController = [[EverydayAskController alloc] initWithNibName:@"EverydayAskController" bundle:nil];
                eaController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:eaController animated:YES];
            }else{
                [ self showAlert:NoMoneyMember];
            }
        }
            break;
        case 8:
        {
            NSLog(@"点击影响力");
//            InfluenceViewController *ivController = [[InfluenceViewController alloc] initWithNibName:@"InfluenceViewController" bundle:nil];
             if (![[Tool MoneyMember]isEqualToString:@"0"]) {
                 InfluenceViewController *ivController = [[InfluenceViewController alloc] init];
                 ivController.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:ivController animated:YES];
             }else{
                [ self showAlert:NoMoneyMember];
             }

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

#pragma mark - GuideViewDelegate
- (void)guideDidFinish:(GuideView *)guide{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_LAUNCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (guide) {
        [UIView animateWithDuration:0.3 animations:^{
            guide.alpha = 0.0;
        } completion:^(BOOL finish){
            [guide removeFromSuperview];
        }];
    }
}
@end

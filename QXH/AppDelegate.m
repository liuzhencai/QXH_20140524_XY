//
//  AppDelegate.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageController.h"
//#import "AddressListController.h"
#import "PersonalInfoController.h"
#import "AddressListViewController.h"

#import "LoginViewController.h"

#import "CustomTabBarController.h"

#import "NSString+MD5HexDigest.h"
#import "MessageBySend.h"
#import "UserInfoModelManger.h"

@implementation AppDelegate

@synthesize tabController;

- (void)logout
{
   [DataInterface logoutWithCompletionHandler:^(NSMutableDictionary *dict) {
       [self stopHeartBeat];
       [self login];
   }];
}

- (void)login
{
    //754672546@qq.com
    NSString *name = [defaults objectForKey:@"userName"];
    NSString *passward = [defaults objectForKey:@"passworld"];
    if (name && passward) {
        [DataInterface login:name andPswd:passward withCompletinoHandler:^(NSMutableDictionary *dict) {
            [defaults setObject:[dict objectForKey:@"userid"] forKey:@"userid"];
            [defaults setObject:[dict objectForKey:@"token"] forKey:@"token"];
            [defaults synchronize];
            [self startHeartBeat];
            /*后台进入前台时获取离线消息*/
            [[MessageBySend sharMessageBySend]getOfflineMessage];
            NSLog(@"file--->%@",[[NSBundle mainBundle] pathForResource:@"icon_buluo@2x" ofType:@"png"]);
            [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict) {

            }];
        }];
    }


}

// 心跳
- (void)heartBeat
{
    [DataInterface heartBeatWithCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"心跳返回--->%@",dict);
        if([[dict objectForKey:@"opercode"] isEqualToString:@"0141"]||[[dict objectForKey:@"opercode"] isEqualToString:@"0121"]){
            [self stopHeartBeat];
            [self login];
        }
    }];
}

- (void)registerAction
{
    [DataInterface registerUser:@"zhaolilong2012@gmail.com" andPswd:@"123456" withCompletionHandler:^(NSMutableDictionary *dict) {
        
    }];
}

- (void)loadPages
{
    
    tabController = [[CustomTabBarController alloc]init];

    // 添加主页导航控制器
    HomePageController *hpController = [[HomePageController alloc] initWithNibName:@"HomePageController" bundle:nil];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:hpController];
    homeNav.delegate = tabController;
    
    // 添加通讯录导航控制器
    AddressListViewController *alController = [[AddressListViewController alloc] init];
    UINavigationController *addrNav = [[UINavigationController alloc] initWithRootViewController:alController];
    addrNav.delegate = tabController;

    // 添加个人信息导航控制器
    PersonalInfoController *piController = [[PersonalInfoController alloc] initWithNibName:@"PersonalInfoController" bundle:nil];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:piController];
    meNav.delegate = tabController;

    [tabController setViewControllers:[NSArray arrayWithObjects:homeNav, addrNav, meNav, nil]];
    self.window.rootViewController = tabController;
    
}

#pragma mark - loginDelegate
- (void)didLoginHandle:(LoginViewController *)loginViewController{
    NSLog(@"登录完成");
    [self loadPages];
    
    /*获取个人信息，并储存起来*/
    [[UserInfoModelManger sharUserInfoModelManger]getUserInfo:^(UserInfoModel* user)
     {
         NSLog(@"获取到用户信息");
     }];
    
    [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
    
    [MessageBySend sharMessageBySend];
}

- (NSString *)getUmengDeviceId
{
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSString *testPath = [documentsDirectory stringByAppendingPathComponent:@"oid.txt"];
//    [fileManager createFileAtPath:testPath contents:[deviceID  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    return deviceID;
}

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:@"测试渠道"];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //TODO. 发布时将日志发送策略改为定时
    //    [MobClick setLogSendInterval:10];
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (void)stopHeartBeat
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)startHeartBeat
{
    [_timer setFireDate:[NSDate date]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    _timer = [NSTimer scheduledTimerWithTimeInterval:30.f
                                                target:self
                                              selector:@selector(heartBeat)
                                              userInfo:nil
                                               repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startHeartBeat) name:@"STARTHEARTBEAT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopHeartBeat) name:@"STOPHEARTBEAT" object:nil];
   
    /*暂时屏蔽友盟，崩溃较严重*/
//    [self getUmengDeviceId];
//    [self umengTrack];
    
//    [self testInterface];
//    [self registerAction];
    
//    if ([defaults objectForKey:@"userName"] && [defaults objectForKey:@"passworld"]) {
//        //自动登陆
////        [self login];
//        [self loadPages];
//    }else{
////        LoginViewController* login = [[LoginViewController alloc]init];
////        login.delegate = self;
////        UINavigationController* loginNavigation = [[UINavigationController alloc]initWithRootViewController:login];
////        self.window.rootViewController = loginNavigation;
//    }
    //初始化消息提醒
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"enableRemind"];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"enableRing"];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"enableShake"];

//    remindSwitch.on = [[defaults objectForKey:@"enableRemind"] boolValue];
//    ringSwitch.on = [[defaults objectForKey:@"enableRing"] boolValue];
//    shakeSwitch.on = [[defaults objectForKey:@"enableShake"] boolValue];
    
    [self loadPages];
    
    [WXApi registerApp:@"wx20ed46d643d2b069"];
    
    // Override point for customization after application launch.
//    [self loadPages];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    needReconnection = YES;
    [self stopHeartBeat];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (needReconnection) {
        [[UDPServiceEngine sharedEngine] reBuildUdpSocket];
        [self login];
        needReconnection = NO;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end

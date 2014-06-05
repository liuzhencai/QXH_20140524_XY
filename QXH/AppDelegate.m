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

@implementation AppDelegate

@synthesize tabController;

- (void)logout
{
   [DataInterface logoutWithCompletionHandler:^(NSMutableDictionary *dict) {
       
   }];
}

- (void)login
{
    NSDictionary *param = @{@"opercode": @"0102", @"username":@"zhaolilong2012@gmail.com", @"pwd":[@"123456" md5HexDigest],@"sign":[SignGenerator getSign]};
    [DataInterface login:@"zhaolilong2012@gmail.com" andPswd:@"123456" withCompletinoHandler:^(NSMutableDictionary *dict) {
        
        [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict) {
            
        }];
        
        [self performSelector:@selector(logout) withObject:nil afterDelay:10.f];
     
//
        [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];

    }];
}

// 心跳
- (void)heartBeat
{
    [DataInterface heartBeatWithCompletionHandler:^(NSMutableDictionary *dict) {
        
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
    
//    LoginViewController* login = [[LoginViewController alloc]init];
//    UINavigationController* loginNavigation = [[UINavigationController alloc]initWithRootViewController:login];
////    self.window.rootViewController = loginnavigation;
//    [self.window addSubview:loginNavigation.view];
    
}

#pragma mark - loginDelegate
- (void)didLoginHandle:(LoginViewController *)loginViewController{
    NSLog(@"登录完成");
   //    [self login];
    [self loadPages];
    
    [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [self testInterface];
//    [self registerAction];
    
    if (![defaults objectForKey:@"userName"] && [defaults objectForKey:@"passworld"]) {
        //自动登陆
        [self login];
        [self loadPages];
    }else{
        LoginViewController* login = [[LoginViewController alloc]init];
        login.delegate = self;
        UINavigationController* loginNavigation = [[UINavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController = loginNavigation;
    }
    
    // 登陆
//    [self login];
    
    [WXApi registerApp:@"wxd930ea5d5a258f4f"];
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp{
    
}

@end

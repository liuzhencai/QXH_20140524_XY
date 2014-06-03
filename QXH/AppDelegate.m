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

@implementation AppDelegate

@synthesize tabController;

- (void)testInterface
{
    NSDictionary *param = @{@"opercode": @"0104",@"platform":@"2",@"version":@"1.1"};
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"dict:%@",dict);
    }];
}

- (void)login
{
    NSDictionary *param = @{@"opercode": @"0102", @"username":@"zhaolilong2012@gmail.com", @"pwd":@"e10adc3949ba59abbe56e057f20f883e",@"sign":[SignGenerator getSign]};
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"返回数据--->%@",data);
        // 存储token和userid
        [defaults setObject:[data objectForKey:@"token"] forKey:@"token"];
        [defaults setObject:[data objectForKey:@"userid"] forKey:@"userid"];
        [defaults synchronize];
        [NSTimer scheduledTimerWithTimeInterval:HEART_BEAT target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
        // 登陆后维持心跳
    } andErrorHandler:^(id data) {
        
    }];
}

// 心跳
- (void)heartBeat
{
    NSDictionary *param = @{@"opercode": @"0101",@"userid":[defaults objectForKey:@"userid"],@"token":[defaults objectForKey:@"token"],@"sign":[SignGenerator getSign]};
    [[UDPServiceEngine sharedEngine] sendData:param withCompletionHandler:^(id data) {
        NSLog(@"心跳返回--->%@",data);
    } andErrorHandler:^(id data) {
        
    }];
}

- (void)registerAction
{
    [HttpRequest requestWithParams:@{@"opercode":@"0135",@"email":@"zhaolilong2012@gmail.com",@"pwd":@"123456"} andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"dict--->>>%@",dict);
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
    //    AddressListController *alController = [[AddressListController alloc] initWithNibName:@"AddressListController" bundle:nil];
    //    UINavigationController *addrNav = [[UINavigationController alloc] initWithRootViewController:alController];
    
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
//    UINavigationController* loginnavigation = [[UINavigationController alloc]initWithRootViewController:login];
//    self.window.rootViewController = loginnavigation;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [self testInterface];
    
//    [self registerAction];
    
    // 登陆
    [self login];
    
    [WXApi registerApp:@"wxd930ea5d5a258f4f"];
    
    // Override point for customization after application launch.
    [self loadPages];
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

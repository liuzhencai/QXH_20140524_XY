//
//  MyViewController.m
//  SuZhouDemo
//
//  Created by liuzhencai on 13-6-17.
//  Copyright (c) 2013年 liuzhencai. All rights reserved.
//

#import "MyViewController.h"
#import "config.h"
#import "AppDelegate.h"

@interface MyViewController (privateLiu)
/*返回按钮函数*/
-(void)popForwardBack;

/*退出程序*/
- (void)exit;

@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

//- (void)dealloc
//{
//    [backGroundImageView release];
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.hidesBottomBarWhenPushed) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.tabController setTabBarHiddenNow:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
//    UIImage * navigationBarImage;
//    navigationBarImage = [UIImage imageNamed:@"top_bar"];
//    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:0];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        [self.navigationController.navigationBar
         setBackgroundImage:[UIImage imageNamed:@"top_bar"]
         forBarMetrics:UIBarMetricsDefault];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
#endif
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //  自定义Pop按钮
    if (IS_OS_7_OR_LATER) {
//        
// self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popForwardBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popForwardBack)];  
        
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        
//        @selector(popForwardBack)
    }else{
        UIButton *leftbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        leftbuttonItem.frame = CGRectMake(10, 10, 23/2 , 38/2);
        [leftbuttonItem setBackgroundImage:[UIImage imageNamed:@"top_btn_arrow_normal"] forState:UIControlStateNormal];
        [leftbuttonItem setBackgroundImage:[UIImage imageNamed:@"top_btn_arrow_highlight"] forState:UIControlStateHighlighted];
        [leftbuttonItem addTarget:self action:@selector(popForwardBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbuttonItem];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
//    [leftItem release];
    
//    UIImage * rightButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_red" ofType:@"png"]];
//    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
//    righttbuttonItem.frame = CGRectMake(0, 0,74, 31);
//    [righttbuttonItem setBackgroundImage:rightButtonImage forState:UIControlStateNormal];
//    [righttbuttonItem setTitle:@"退出" forState:UIControlStateNormal];
//    [righttbuttonItem addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
//    self.navigationItem.rightBarButtonItem = righttItem;
//    [righttItem release];
    
    //背景
    backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, iPhone5?568:480)];
    NSLog(@"backGroundImageView.hight == %f",backGroundImageView.frame.size.height);
    backGroundImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_pay_backGround" ofType:@"png"]];
    [self.view insertSubview:backGroundImageView atIndex:0];
    
//    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
   
}

- (NSString *)cityNameWithCode:(NSString *)code{
    if ([code length]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"provincesAndCitys" ofType:@"plist"];
        NSArray *provList = [[NSArray alloc] initWithContentsOfFile:path];
        NSString *codeSubStr = [code substringToIndex:3];
        for (int i = 0; i < [provList count]; i ++) {
            NSDictionary *provDict = [provList objectAtIndex:i];
            NSString *provinceId = [provDict objectForKey:@"provinceid"];
            NSString *provSubStr = [provinceId substringToIndex:3];
            if ([codeSubStr isEqualToString:provSubStr]) {
                NSArray *cityList = [provDict objectForKey:@"citysList"];
                for (int j = 0; j < [cityList count]; j ++) {
                    NSDictionary *cityDict = [cityList objectAtIndex:j];
                    NSString *cityId = [cityDict objectForKey:@"cityid"];
                    if ([cityId isEqualToString:code]) {
                        NSString *provinceName = [provDict objectForKey:@"province"];
                        provinceName = [provinceName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        NSString *cityName = [cityDict objectForKey:@"city"];
                        NSString *returnString = [NSString stringWithFormat:@"%@%@",provinceName,cityName];
                        return returnString;
                    }
                }
            }
        }
    }
    return @"";
}

- (void)showAlert:(NSString *)msg{
//    if (!IsshowAlert) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定",nil];
        [alert show];
//    }
//    IsshowAlert = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    IsshowAlert = NO;
}

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                         color:(UIColor *)color
                          font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = text;
    if (color) {
        label.textColor = color;
    }
    return label;
}

#pragma mark-私有函数
-(void)popForwardBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-私有函数
/*退出程序*/
- (void)exit
{
    exit(0);
}
@end

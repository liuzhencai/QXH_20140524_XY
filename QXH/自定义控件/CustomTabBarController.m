//
//  CustomTabBarController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-22.
//  Copyright (c) 2013年 ZhaoLilong. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()
@property (nonatomic, strong) TabBarControl *firstControl;
@property (nonatomic, strong) TabBarControl *secondControl;
@property (nonatomic, strong) TabBarControl *thirdControl;
@end

@implementation CustomTabBarController
@synthesize firstControl, secondControl, thirdControl;
@synthesize currentTab;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideSystemTabBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    [self hideTabBar:viewController.hidesBottomBarWhenPushed];
}

- (void)hideTabBar:(BOOL)hidden
{           
    UIImageView *tabView_ = (UIImageView *)[self.view viewWithTag:101];
    if (hidden) {
        tabView_.frame = CGRectMake(0, SCREEN_H, 320, 49);
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
            if (!IOS7_OR_LATER) {
                [self setTabBarHiddenNow:[NSNumber numberWithInt:1]];
            }
        #endif
    }else{
        tabView_.frame = CGRectMake(0, SCREEN_H - 49, 320, 49);
    }
}

//重置内容视图
- (void)setTabBarHiddenNow:(NSNumber *)aboolNum {
    BOOL abool = aboolNum.boolValue;
    UIImageView *tabView_ = (UIImageView *)[self.view viewWithTag:101];
    UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [self.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.view.subviews objectAtIndex:0];
    }
    if (abool) {
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBar.frame.size.height);
        
    } else {
        contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBar.frame.size.height);
    }
    tabView_.hidden = abool;
}

-(void)addCustomElements
{
    UIImageView *tabView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bootom_bar"]];
    tabView.userInteractionEnabled = YES;
    tabView.tag = 101;
    tabView.frame = CGRectMake(0, SCREEN_H - 49, 320, 49);
    firstControl = [[TabBarControl alloc]initWithFrame:CGRectMake(0, 0, 320/3, 49) andBackgroundImage:[UIImage imageNamed:@"bootom_icon_home"] andTitle:@"首页" andDelegate:self];
    firstControl.tag = 1;
    secondControl = [[TabBarControl alloc]initWithFrame:CGRectMake(TabBarItemWidth*1, 0, 320/3, 49) andBackgroundImage:[UIImage imageNamed:@"bootom_icon_contacts"] andTitle:@"通讯录" andDelegate:self];
    secondControl.tag = 2;
    thirdControl = [[TabBarControl alloc] initWithFrame:CGRectMake(TabBarItemWidth*2, 0, 320/3, 49) andBackgroundImage:[UIImage imageNamed:@"bootom_icon_me"] andTitle:@"我" andDelegate:self];
    thirdControl.tag = 3;

    [tabView addSubview:firstControl];
    [tabView addSubview:secondControl];
    [tabView addSubview:thirdControl];
 
    [self.view addSubview:tabView];
 
    [self selectTab:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCustomElements];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideSystemTabBar{
    [self.tabBar setFrame:CGRectMake(0, SCREEN_H, 0, 0)];
}

- (void)selectTab:(int)tabID
{
    currentTab = tabID;
    switch(tabID)
    {
        case 0:
        {
            [firstControl setSelected:YES];
            firstControl.backgroundColor = RGBCOLOR(0, 121, 40);
            [secondControl setSelected:NO];
            secondControl.backgroundColor = [UIColor clearColor];
            [thirdControl setSelected:NO];
            thirdControl.backgroundColor = [UIColor clearColor];
        }
            break;
        case 1:
        {
            [firstControl setSelected:NO];
            firstControl.backgroundColor = [UIColor clearColor];
            [secondControl setSelected:YES];
            secondControl.backgroundColor = RGBCOLOR(0, 121, 40);
            [thirdControl setSelected:NO];
            thirdControl.backgroundColor = [UIColor clearColor];
        }
            break;
        case 2:
        {
            [firstControl setSelected:NO];
            firstControl.backgroundColor = [UIColor clearColor];
            [secondControl setSelected:NO];
            secondControl.backgroundColor = [UIColor clearColor];
            [thirdControl setSelected:YES];
            thirdControl.backgroundColor = RGBCOLOR(0, 121, 40);
        }
            break;
    }
    self.selectedIndex = tabID;
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum-1];
}

@end

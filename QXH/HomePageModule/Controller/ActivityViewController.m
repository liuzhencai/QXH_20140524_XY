//
//  ActivityViewController.m
//  QXH
//
//  Created by XUE on 14-5-19.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityCell.h"
#import "ActivityDetailViewController.h"
#import "PromotionalActvityViewController.h"
//#import "FilterViewController.h"
#import "SelectTribeViewController.h"
#import "FilterTimeViewController.h"

@interface ActivityViewController ()
@property (nonatomic, assign) int selectIndex;
@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectIndex = 1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"活动";
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,40, 30);
    [righttbuttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [righttbuttonItem setTitle:@"更多" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(160 * i, 0, 160, 30);
        btn.tag = 1 + i;
        NSString *title = @"进行的活动";
        [btn setTitleColor:COLOR_WITH_ARGB(83, 170, 97, 1.0) forState:UIControlStateNormal];
        if (i == 1) {
            title = @"结束的活动";
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        //83,170,97
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UIImageView *slippag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH, 2)];
    slippag.image = [UIImage imageNamed:@"navigation_slippage_bar_bg"];
    [self.view addSubview:slippag];
    
    for (int i = 0; i < 2; i ++) {
        UIImageView *slippag = [[UIImageView alloc] initWithFrame:CGRectMake(160 * i, 30, UI_SCREEN_WIDTH/2, 2)];
        slippag.tag = 1000 + i;
        slippag.image = [UIImage imageNamed:@"navigation_slippage_bar_green"];
        if (i == 1) {
            slippag.hidden = YES;
        }
        [self.view addSubview:slippag];
    }
    
    UITableView *table2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    table2.tag = 101;
    table2.delegate = self;
    table2.dataSource = self;
    [self.view addSubview:table2];
    
    UITableView *table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    table1.tag = 100;
    table1.delegate = self;
    table1.dataSource = self;
    [self.view addSubview:table1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == self.selectIndex) {
        return;
    }
    self.selectIndex = btn.tag;
    
    [btn setTitleColor:COLOR_WITH_ARGB(83, 170, 97, 1.0) forState:UIControlStateNormal];
    UIButton *otherBtn = (UIButton *)[self.view viewWithTag:btn.tag%2 + 1];
    [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSInteger tag = btn.tag + 99;
    UIImageView *slippag1 = (UIImageView *)[self.view viewWithTag:1000];
    UIImageView *slippag2 = (UIImageView *)[self.view viewWithTag:1001];
    //    BOOL hidden1 = tag%100;
//    [UIView animateWithDuration:0.1 animations:^{
        slippag1.hidden = !slippag1.hidden;
        slippag2.hidden = !slippag2.hidden;
//    } completion:nil];
    [self.view bringSubviewToFront:[self.view viewWithTag:tag]];
}


- (void)more:(UIButton *)sender{
//    SelectTribeViewController *selectTribe = [[SelectTribeViewController alloc] init];
//    selectTribe.selectTribeCallBack = ^(NSDictionary *Dict){
//        NSLog(@"call back:%@",Dict);
//    };
//    [self.navigationController pushViewController:selectTribe animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"发布",@"筛选", nil];
    
    [alert show];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    if(tableView.tag == 101){
        static NSString *addrIdentifier = @"activeEndIdentifier";
        ActivityCell *activeEndCell = nil;
        activeEndCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!activeEndCell) {
            activeEndCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
        }
        activeEndCell.statusLabel.text = @"已结束";
        
        cell = activeEndCell;
    }else if (tableView.tag == 100) {
        static NSString *myMsgIdentifier = @"activingIdentifier";
        ActivityCell *activityingCell = nil;
        activityingCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!activityingCell) {
            activityingCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
        }
        activityingCell.statusLabel.text = @"进行中";
        cell = activityingCell;
    }
    return cell;
    
    //    ActivityCell *cell;
    //    static NSString *cellIdentifier = @"activityIdentifier";
    //    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //    if (!cell) {
    //        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
    //    }
    //
    //    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
        [self.navigationController pushViewController:activityDetail animated:YES];
    }else{
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
        [self.navigationController pushViewController:activityDetail animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.firstOtherButtonIndex == buttonIndex) {//发起活动
        NSLog(@"发起活动");
        PromotionalActvityViewController *promotional = [[PromotionalActvityViewController alloc] init];
        [self.navigationController pushViewController:promotional animated:YES];
    }else if (2 == buttonIndex){//筛选
        NSLog(@"筛选");
        FilterTimeViewController *filterTime = [[FilterTimeViewController alloc] init];
        [self.navigationController pushViewController:filterTime animated:YES];
    }
}

@end

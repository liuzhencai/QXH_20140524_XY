//
//  SquareViewController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "SquareViewController.h"
#import "SquareCell.h"
#import "SquareShareController.h"
#import "ShareTextController.h"
#import "HistoryReviewController.h"
#import "SquareActivityCell.h"

@interface SquareViewController ()

@end

@implementation SquareViewController

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
    self.title = @"广场";
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,74, 31);
    [righttbuttonItem setTitle:@"发布" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(distribute:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    self.squareTable.frame = CGRectMake(0, 49, 320, SCREEN_H-49);
}

// 发布
- (void)distribute:(id)sender
{
    SquareShareController *controller = [[SquareShareController alloc]initWithNibName:@"SquareShareController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    switch (indexPath.row) {
        case 0:
            rowHeight = 82.f;
            break;
        case 1:
        {
            rowHeight = 162.f;
        }
            break;
        case 2:
        {
            rowHeight = 162.f;
        }
            break;
        default:
            rowHeight = 201.f;
            break;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"everydayAsk";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell.contentView addSubview:_everydayAskView];
        }
    }else if(indexPath.row == 1){
        static NSString *cellIdentifier = @"squareCellEx";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareCellEx" owner:nil options:nil] objectAtIndex:0];
        }
    }else if(indexPath.row == 2){
        static NSString *cellIdentifier = @"squareCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareCell" owner:nil options:nil] objectAtIndex:0];
        }
    }else{
        static NSString *cellIdentifier = @"squareActivityCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareActivityCell" owner:nil options:nil] objectAtIndex:0];
        }
    }
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareTextController *controller = [[ShareTextController alloc] initWithNibName:@"ShareTextController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    _slipbar.frame = CGRectMake((btn.tag - 1)*160, 49, 160, 2);
    [UIView commitAnimations];
    switch (btn.tag) {
        case 1:
        {
            [_lastestBtn setTitleColor:RGBCOLOR(78, 199, 60) forState:UIControlStateNormal];
            [_hotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_lastestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_hotBtn setTitleColor:RGBCOLOR(78, 199, 60) forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (IBAction)history:(id)sender {
    HistoryReviewController *controller = [[HistoryReviewController alloc] initWithNibName:@"HistoryReviewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)requestInfoListWithType:(NSString *)type arttype:(NSString *)arttype withCompletionBlock:(ListCallback)callback
{
    NSString *userid = @"123456";
    NSString *token = @"ab123456789";
    NSDictionary *param = @{@"opercode": @"0119",@"userid":userid,@"token":token, @"type":@"1", @"detailtype":type, @"tag":@"标签", @"arttype":arttype, @"start":@"10", @"direction":@"before", @"count":@"20"};
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        callback([ModelGenerator json2InfoList:dict]);
    }];
}

@end

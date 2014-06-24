//
//  SquareViewController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "SquareViewController.h"
#import "SquareCell.h"
#import "SquareCellEx.h"
#import "SquareShareController.h"
#import "ShareTextController.h"
#import "HistoryReviewController.h"
#import "SquareActivityCell.h"

@interface SquareViewController ()
{
    NSMutableArray *squareInfoList;
}
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
    
    //获取列表
    [self getSquareList];
}

- (void)getSquareList{
    [DataInterface getSquareInfoList:@"0" detailtype:@"1" tag:@"" arttype:@"" contentlength:@"" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        squareInfoList = [ModelGenerator json2SquareList:dict];
        [_squareTable reloadData];
    }];
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

- (UITableViewCell *)loadTblData:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    SquareInfo *model = [squareInfoList objectAtIndex:indexPath.row];

    UITableViewCell *tblCell = nil;
    /**
     *  1为广场发布的文章，2为转发到广场的咨询，3为转发到广场的活动
     */
    if (YES) {
        switch (model.type) {
            case 1:
            {
                static NSString *cellIdentifier = @"squareCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareCell" owner:nil options:nil] objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [(SquareCell *)cell setCellData:model];
                tblCell = cell;
            }
                break;
            case 2:
            {
                static NSString *cellIdentifier = @"squareCellEx";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareCellEx" owner:nil options:nil] objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [(SquareCellEx *)cell setCellData:model];
                tblCell = cell;
            }
                break;
            case 3:
            {
                static NSString *cellIdentifier = @"squareActivityCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareActivityCell" owner:nil options:nil] objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                tblCell = cell;
            }
                break;
            default:
                break;
        }
    }else{
        if (indexPath == 0) {
            // 添加每日一问
        }else{
            
        }
    }
    return tblCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [squareInfoList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    SquareInfo *model = [squareInfoList objectAtIndex:indexPath.row];
    if (YES) {
        switch (model.type) {
            case 1:
                rowHeight = 162.f;
                break;
            case 2:
                rowHeight = 162.f;
                break;
            case 3:
                rowHeight = 201.f;
                break;
            default:
                break;
        }
    }else{
        
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self loadTblData:tableView indexPath:indexPath];
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

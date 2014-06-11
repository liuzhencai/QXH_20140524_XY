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
{
    NSMutableArray *info;
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
    [self getSquareList:1];
}

- (void)getSquareList:(NSInteger)type{
    /**
     *  获取查询广场文章/咨询文章列表,获取收藏列表
     *
     *  @param type          信息类型(0为不区分[获取个人收藏文章时使用],1为广场消息，2为咨询)
     *  @param detailtype    信息明细类型 1为最新，2为最热,3为收藏
     *  @param tag           标签
     *  @param arttype       文章类型
     *  @param contentlength 文章列表中文章的长度
     *  @param start         起始消息的artid，不填写该字段读取最新消息n个
     *  @param count         获取消息数量
     */
    [DataInterface getInfoList:@"1" //1为广场消息
                    detailtype:[NSString stringWithFormat:@"%d",type] //1为最新，2为最热,3为收藏
                           tag:@""
                       arttype:@""
                 contentlength:@""
                         start:@""
                         count:@"20"
         withCompletionHandler:^(NSMutableDictionary *dict){
            info = [ModelGenerator json2InfoList:dict];
             [_squareTable reloadData];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取到活动列表" message:[info description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alert show];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [info count];
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:_everydayAskView];
        }
    }else if(indexPath.row == 1){
        static NSString *cellIdentifier = @"squareCellEx";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareCellEx" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if(indexPath.row == 2){
        static NSString *cellIdentifier = @"squareCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareCell" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else{
        static NSString *cellIdentifier = @"squareActivityCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareActivityCell" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self getSquareList:btn.tag];

}

- (IBAction)history:(id)sender {
    HistoryReviewController *controller = [[HistoryReviewController alloc] initWithNibName:@"HistoryReviewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

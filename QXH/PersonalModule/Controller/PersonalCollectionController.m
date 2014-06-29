//
//  PersonalCollectionController.m
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "PersonalCollectionController.h"
#import "SquareViewController.h"
#import "SquareCell.h"
#import "SquareCellEx.h"
#import "SquareActivityCell.h"
#import "ShareTextController.h"

@interface PersonalCollectionController ()
{
    NSMutableArray *info;
}
@end

@implementation PersonalCollectionController

- (void)getInfoList
{
    [DataInterface getInfoList:@"0" detailtype:@"" tag:@"" arttype:@"" contentlength:@"30" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        info = [ModelGenerator json2SquareList:dict];
        [_collectionTable reloadData];
    }];
}

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
    self.title = @"我的收藏";
    [self getInfoList];
    
    _collectionTable.frame = CGRectMake(0, 0, 320, SCREEN_H-49);
    
    _toolbarView.frame = CGRectMake(0, SCREEN_H - 49 - 64, 320, 49);
    [self.view addSubview:_toolbarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)loadTblData:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    SquareInfo *model = [info objectAtIndex:indexPath.row];
    
    UITableViewCell *tblCell = nil;
    /**
     *  1为广场发布的文章，2为转发到广场的咨询，3为转发到广场的活动
     */
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
            [(SquareActivityCell *)cell setCellData:model];
            tblCell = cell;
        }
            break;
        default:
            break;
    }
    return tblCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [info count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    SquareInfo *model = [info objectAtIndex:indexPath.row];
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
    SquareInfo *model = [info objectAtIndex:indexPath.row];
    ShareTextController *controller = [[ShareTextController alloc] initWithNibName:@"ShareTextController" bundle:nil];
    switch (model.type) {
        case 1:
            controller.type = SquareInfoTypeSq;
            break;
        case 2:
            controller.type = SquareInfoTypeInf;
            break;
        case 3:
            controller.type = SquareInfoTypeAct;
            break;
        default:
            break;
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"赞" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 3:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 4:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"举报" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

@end

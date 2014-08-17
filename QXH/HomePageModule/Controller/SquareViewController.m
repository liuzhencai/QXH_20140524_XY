//
//  SquareViewController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "SquareViewController.h"
#import "SquareCell.h"
#import "SquareNoPicCell.h"
#import "SquareCellEx.h"
#import "SquareAskCell.h"
#import "SquareTransmitCell.h"
#import "SquareShareController.h"
#import "ShareTextController.h"
#import "HistoryReviewController.h"
#import "SquareActivityCell.h"
#import "ActivityDetailViewController.h"
#import "MJRefresh.h"
#import "EverydayAskController.h"

@interface SquareViewController ()
{
    UIScrollView *infoScroll;
    NSMutableArray *squareInfoList;
    NSMutableArray *hotestInfoList;
}
@property (nonatomic, assign)     NSInteger curIndex;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:TYPE_LOOK_PUBLIC];
    [MobClick beginEvent:TYPE_LOOK_PUBLIC];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:TYPE_LOOK_PUBLIC];
    [MobClick endEvent:TYPE_LOOK_PUBLIC];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"广场";
    
    _curIndex = 1;
    
    squareInfoList = [[NSMutableArray alloc] init];
    hotestInfoList = [[NSMutableArray alloc] init];
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,74, 31);
    righttbuttonItem.titleLabel.font = [UIFont systemFontOfSize:16.5f];
    [righttbuttonItem setTitle:@"发布" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(distribute:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    infoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 51, 320, SCREEN_H-51)];
    infoScroll.pagingEnabled = YES;
    infoScroll.delegate = self;
    infoScroll.showsHorizontalScrollIndicator = NO;
    infoScroll.contentSize = CGSizeMake(640, infoScroll.bounds.size.height);
    self.squareTable.frame = CGRectMake(0, 0, 320, SCREEN_H-102);
    if (IOS7_OR_LATER) {
        [self.squareTable setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    }
    self.hotestTable.frame = CGRectMake(320, 0, 320, SCREEN_H-102);
    if (IOS7_OR_LATER) {
        [self.hotestTable setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    }
    [self setupRefresh:_squareTable];
    [_squareTable headerBeginRefreshing];
    [self setupRefresh:_hotestTable];
//    [_hotestTable headerBeginRefreshing];
    [infoScroll addSubview:_squareTable];
    [infoScroll addSubview:_hotestTable];
    [self.view addSubview:infoScroll];
}

- (void)getHotestListWithStart:(NSString *)start withCompletionHandler:(ListCallback)callback
{
    [DataInterface getInfoList:@"1" detailtype:@"2" tag:@"" classify:@"" arttype:@"" contentlength:@"30" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        callback([ModelGenerator json2SquareInfoList:dict]);
//        callback([ModelGenerator json2SquareList:dict]);
    }];
//    [DataInterface getSquareInfoList:@"0" detailtype:@"1" tag:@"" arttype:@"" contentlength:@"30" start:start count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
//        callback([ModelGenerator json2SquareList:dict]);
//    }];
}

- (void)getSquareListWithStart:(NSString *)start withCompletionHandler:(ListCallback)callback
{
    [DataInterface getSquareInfoList:@"0" detailtype:@"1" tag:@"" arttype:@"" contentlength:@"" start:start count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        callback([ModelGenerator json2SquareList:dict]);
    }];
}

// 发布
- (void)distribute:(id)sender
{
    SquareShareController *controller = [[SquareShareController alloc]initWithNibName:@"SquareShareController" bundle:nil];
    controller.controller = self;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh:(UITableView *)tableView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    switch (_curIndex) {
        case 1:
        {
            [self getSquareListWithStart:@"0" withCompletionHandler:^(NSMutableArray *list) {
                // 1.添加数据
                if ([squareInfoList count]!=0) {
                    [squareInfoList removeAllObjects];
                }
                [squareInfoList addObjectsFromArray:list];
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 刷新表格
                    [_squareTable reloadData];
                    
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [_squareTable headerEndRefreshing];
                });
            }];
        }
            break;
        case 2:
        {
            [self getHotestListWithStart:@"0" withCompletionHandler:^(NSMutableArray *list) {
                // 1.添加数据
                if ([hotestInfoList count]!=0) {
                    [hotestInfoList removeAllObjects];
                }
                [hotestInfoList addObjectsFromArray:list];
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 刷新表格
                    [_hotestTable reloadData];
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [_hotestTable headerEndRefreshing];
                });
            }];
        }
            break;
        default:
            break;
    }
}

- (void)footerRereshing
{
    switch (_curIndex) {
        case 1:
        {
            // 1.添加数据
            SquareInfo *model = [squareInfoList lastObject];
            [self getSquareListWithStart:[NSString stringWithFormat:@"%d",model.psid] withCompletionHandler:^(NSMutableArray *list) {
                [squareInfoList addObjectsFromArray:list] ;
                // 2.2秒后刷新表格UI
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [infoScroll scrollRectToVisible:CGRectMake(0, 51, 320, infoScroll.bounds.size.height) animated:NO];
                    // 刷新表格
                    [_squareTable reloadData];
                    
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [_squareTable footerEndRefreshing];
                });
            }];
        }
            break;
        case 2:
        {
//            SquareInfo *model = [squareInfoList lastObject];
//            InfoModel *tmpModel = (InfoModel *)model.content;
//            // 1.添加数据
//            [self getHotestListWithStart:tmpModel.sid withCompletionHandler:^(NSMutableArray *list) {
//                [hotestInfoList addObjectsFromArray:list] ;
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
//                    [infoScroll scrollRectToVisible:CGRectMake(320, 51, 320, infoScroll.bounds.size.height) animated:NO];
//                    // 刷新表格
//                    [_hotestTable reloadData];
                    
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [_hotestTable footerEndRefreshing];
                });
//            }];
        }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)loadTblData:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    SquareInfo *model = nil;
    if (_curIndex == 1) {
        model = [squareInfoList objectAtIndex:indexPath.row];
    }else{
        model = [hotestInfoList objectAtIndex:indexPath.row];
    }

    UITableViewCell *cell;
    switch (model.type) {
        case 1:
        {
            //发布动态
            InfoModel *tmpModel = (InfoModel *)model.content;
            NSLog(@"name--->%@,artImage--->%@",tmpModel.sname, tmpModel.artimgs);
            static NSString *cellIdentifier = @"SquareCell";
            SquareCell*  cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell1==nil) {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:@"SquareCell" owner:self options:nil] lastObject];
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (tmpModel) {
                [(SquareCell *)cell1 setCellData:model];
            }
            return  cell1;
            
        }
            break;
        case 2:
        {
            static NSString *cellIdentifier = @"squareCellEx";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareCellEx" owner:nil options:nil] objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [(SquareCellEx *)cell setCellData:model withFlag:0];
        }
            break;
        case 5:
        {
            //转发文章
            static NSString *cellIdentifier = @"squareCellEx";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareCellEx" owner:nil options:nil] objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [(SquareCellEx *)cell setCellData:model withFlag:1];
        }
            break;
        case 3:
        {
            /*转发活动*/
            static NSString *cellIdentifier = @"squareActivityCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareActivityCell" owner:nil options:nil] objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [(SquareActivityCell *)cell setCellData:model];
        }
            break;
        case 4:
        {
            static NSString *cellIdentifier = @"SquareAskCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareAskCell" owner:nil options:nil] objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [(SquareAskCell *)cell setCellData:model];
        }
            break;
//        case 5:
//        {
//            static NSString *cellIdentifier = @"SquareTransmitCell";
//            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if (cell == nil) {
//                cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareTransmitCell" owner:nil options:nil] objectAtIndex:0];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//        }
//            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_curIndex == 1) {
        return [squareInfoList count];
    }
    return [hotestInfoList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    SquareInfo *model = nil;
    if (_curIndex == 1) {
            model = [squareInfoList objectAtIndex:indexPath.row];
    }else{
        model = [hotestInfoList objectAtIndex:indexPath.row];
    }
    InfoModel *tmpModel = (InfoModel *)model.content;
    switch (model.type) {
        case 1:
        {
            if (tmpModel.content) {
                if ([tmpModel.artimgs isEqualToString:@""]) {
                    rowHeight = 100.f;
                }else{
                    
                    rowHeight =   [SquareCell height:model];
                    //                rowHeight = 162.f;
                }
            }
        }
            break;
        case 2:
        case 5:
        {
          rowHeight = [SquareCellEx height:model];
//            rowHeight = 162.f;
        }

            break;
        case 3:
        {
          rowHeight = [SquareActivityCell height:model];
        }
            
//           rowHeight = 201.f;
            break;
        case 4:
            rowHeight = 82.f;
            break;
        default:
            break;
    }
    NSLog(@"第%d行   高度--->%f", indexPath.row, rowHeight);
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self loadTblData:tableView indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SquareInfo *model = [squareInfoList objectAtIndex:indexPath.row];
    switch (model.type) {
        case 1:
        {
            ShareTextController *controller = [[ShareTextController alloc] initWithNibName:@"ShareTextController" bundle:nil];
            controller.info = model;
            controller.type = SquareInfoTypeSq;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            ShareTextController *controller = [[ShareTextController alloc] initWithNibName:@"ShareTextController" bundle:nil];
            controller.info = model;
            controller.type = SquareInfoTypeInf;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:
        {
            ShareTextController *controller = [[ShareTextController alloc] initWithNibName:@"ShareTextController" bundle:nil];
            controller.info = model;
            controller.type = SquareInfoTypeTrans;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
    
        }
            break;
        case 3:
            /**
             *  活动跳转至活动详情
             */
        {
            ActivityDetailViewController *tmpController = [[ActivityDetailViewController alloc]init];
            SquareActInfo *tmpInfo = model.content;
            tmpController.activityId = tmpInfo.actid;
            [self.navigationController pushViewController:tmpController animated:YES];
        }
            break;
        case 4:
        {
            EverydayAskController *controller = [[EverydayAskController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    _slipbar.frame = CGRectMake((btn.tag - 1)*160, 49, 160, 2);
    [UIView commitAnimations];
    _curIndex = btn.tag;
    switch (btn.tag) {
        case 1:
        {
            [_lastestBtn setTitleColor:RGBCOLOR(78, 199, 60) forState:UIControlStateNormal];
            [_hotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [infoScroll scrollRectToVisible:CGRectMake(0, 51, 320, infoScroll.bounds.size.height) animated:NO];
            if ([squareInfoList count] == 0) {
                [_squareTable headerBeginRefreshing];
            }
        }
            break;
        case 2:
        {
            [_lastestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_hotBtn setTitleColor:RGBCOLOR(78, 199, 60) forState:UIControlStateNormal];
            [infoScroll scrollRectToVisible:CGRectMake(320, 51, 320, infoScroll.bounds.size.height) animated:NO];
            if ([hotestInfoList count] == 0) {
                [_hotestTable headerBeginRefreshing];
            }
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == infoScroll) {
        _curIndex = (NSInteger)scrollView.contentOffset.x/320+1;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.25f];
        _slipbar.frame = CGRectMake((_curIndex-1)*160, 49, 160, 2);
        [UIView commitAnimations];
        if (_curIndex == 1) {
            [_lastestBtn setTitleColor:RGBCOLOR(78, 199, 60) forState:UIControlStateNormal];
            [_hotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if ([squareInfoList count] == 0) {
                [_squareTable headerBeginRefreshing];
            }
        }else{
            [_lastestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_hotBtn setTitleColor:RGBCOLOR(78, 199, 60) forState:UIControlStateNormal];
            if ([hotestInfoList count] == 0) {
                [_hotestTable headerBeginRefreshing];
            }
        }
    }
}

@end

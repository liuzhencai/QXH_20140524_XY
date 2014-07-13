//
//  InformationViewController.m
//  QXH
//
//  Created by liuzhencai on 14-5-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationCell.h"
#import "ClassificationControll.h"
#import "InformationDetailController.h"
#import "InfoModel.h"
#import "MJRefresh.h"

@interface InformationViewController ()
{
    NSMutableArray *artClassify;
    UIScrollView   *menuScroll;
    UIScrollView   *infoScroll;
    UIImageView    *instruction;
    BOOL           loadingMore; // 加载更多标识
}

@property (nonatomic, strong) NSMutableArray *tableArr;

@property (nonatomic, strong) NSMutableDictionary *artListData;

@property (nonatomic, assign) NSInteger curIndex;

- (void)requestInfoList:(NSString *)classify start:(NSString *)start withCompletionHandler:(ListCallback)callback;

@end

@implementation InformationViewController

#pragma mark - 目录点击响应
- (void)menuClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.curIndex = btn.tag - 1000;
    [self changeMenuState];
    [infoScroll scrollRectToVisible:CGRectMake(320*_curIndex, MENU_FIXED_HEIGHT, 320, SCREEN_H - MENU_FIXED_HEIGHT - 64) animated:NO];
}

#pragma mark - 添加动态导航目录
- (void)addDynamicMenu
{
    menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, MENU_FIXED_HEIGHT)];
    NSInteger menuNum = [artClassify count];
    menuScroll.contentSize = CGSizeMake(menuNum*MENU_FIXED_WIDTH, MENU_FIXED_HEIGHT);
    menuScroll.bounces = NO;
    menuScroll.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < menuNum; i++) {
        CodeSheetObject *obj = [artClassify objectAtIndex:i];
        UIButton *menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        menuItem.tag = 1000+i;
        [menuItem setTitle:obj.name forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuItem addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchDown];
        menuItem.frame = CGRectMake(i*MENU_FIXED_WIDTH, 0, MENU_FIXED_WIDTH, MENU_FIXED_HEIGHT);
        [menuScroll addSubview:menuItem];
    }
    
    UIImageView *lineBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MENU_FIXED_HEIGHT - 2, menuNum*MENU_FIXED_WIDTH, 2)];
    lineBgView.image = [UIImage imageNamed:@"navigation_slippage_bar_bg"];
    [menuScroll addSubview:lineBgView];
    
    instruction = [[UIImageView alloc] initWithFrame:CGRectMake(0, MENU_FIXED_HEIGHT - 2, MENU_FIXED_WIDTH, 2)];
    instruction.image = [UIImage imageNamed:@"navigation_slippage_bar_green"];
    [menuScroll addSubview:instruction];
    [self.view addSubview:menuScroll];
}

#pragma mark - 添加动态列表
- (void)addListView
{
    infoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MENU_FIXED_HEIGHT, 320, SCREEN_H - MENU_FIXED_HEIGHT - 64)];
    infoScroll.delegate = self;
    infoScroll.bounces = NO;
    infoScroll.pagingEnabled = YES;
    infoScroll.showsHorizontalScrollIndicator = NO;
    infoScroll.contentSize = CGSizeMake(320*[artClassify count], SCREEN_H - MENU_FIXED_HEIGHT - 64);
    for (int i = 0; i < [artClassify count]&&[artClassify count] > 0; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*320, 0, 320, SCREEN_H - MENU_FIXED_HEIGHT - 64) style:UITableViewStylePlain];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        if (IOS7_OR_LATER) {
            [tableView setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
        }
        tableView.backgroundColor = [UIColor clearColor];
        [self setupRefresh:tableView];
        [_tableArr addObject:tableView];
        [infoScroll addSubview:tableView];
    }
    [self.view addSubview:infoScroll];
    
    UITableView *tableView = [_tableArr objectAtIndex:0];
    [tableView headerBeginRefreshing];
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
    [self requestInfoList:((CodeSheetObject *)[artClassify objectAtIndex:_curIndex]).code start:@"0" withCompletionHandler:^(NSMutableArray *list) {
        // 1.添加数据
        NSString *indexKey = [NSString stringWithFormat:@"%d",_curIndex];
        NSArray *data = [_artListData objectForKey:indexKey];
        if ([data count] != 0) {
            [_artListData removeObjectForKey:indexKey];
        }
        [_artListData setObject:list forKey:indexKey];
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
            [tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [tableView headerEndRefreshing];
        });
    }];
}

- (void)footerRereshing
{
    NSString *indexKey = [NSString stringWithFormat:@"%d",_curIndex];
    NSArray *data = [_artListData objectForKey:indexKey];
    InfoModel *model = [data lastObject];
    // 1.添加数据
    [self requestInfoList:((CodeSheetObject *)[artClassify objectAtIndex:_curIndex]).code start:model.artid withCompletionHandler:^(NSMutableArray *list) {
        NSMutableArray *classifyArr = [_artListData objectForKey:indexKey];
        if ([classifyArr count] != 0) {
            if (loadingMore) {
                [classifyArr addObjectsFromArray:list];
            }else{
                [classifyArr removeAllObjects];
                [_artListData setObject:list forKey:indexKey];
            }
        }else{
            [_artListData setObject:list forKey:indexKey];
        }
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
            [infoScroll scrollRectToVisible:CGRectMake(320*_curIndex, MENU_FIXED_HEIGHT, 320, SCREEN_H - MENU_FIXED_HEIGHT - 64) animated:NO];
            // 刷新表格
            [tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [tableView footerEndRefreshing];
        });
    }];
}

- (void)requestArtClassify
{
    [DataInterface getCodeSheet:@"artClassify" fathercode:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
        artClassify = [ModelGenerator json2CodeSheet:dict];
        [self addDynamicMenu];
        [self addListView];
    }];
}

- (void)requestInfoList:(NSString *)classify start:(NSString *)start withCompletionHandler:(ListCallback)callback
{
    [DataInterface getInfoList:@"2" detailtype:@"1" tag:@"" classify:classify arttype:@"" contentlength:@"30" start:start count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        NSMutableArray *tmpArr = [ModelGenerator json2InfoList:dict];
        callback(tmpArr);
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
    self.title = @"智谷";
    _artListData = [[NSMutableDictionary alloc] init];
    _tableArr = [[NSMutableArray alloc]init];
    _curIndex = 0;
    loadingMore = YES;
    [self requestArtClassify];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)calculateRowHeight:(InfoModel *)model
{
    CGFloat rowHeight = 0.f;
    if ([model.sid integerValue] == 0) {
        rowHeight = 80;
    }else{
        rowHeight = 150;
    }
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_artListData objectForKey:[NSString stringWithFormat:@"%d",_curIndex]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoModel *model = [[_artListData objectForKey:[NSString stringWithFormat:@"%d",_curIndex]] objectAtIndex:indexPath.row];
    return [self calculateRowHeight:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *tableCell;
    NSString *indexKey = [NSString stringWithFormat:@"%d",_curIndex];
    NSArray *data = [_artListData objectForKey:indexKey];
    InfoModel *model = nil;
    if (row < [data count]) {
        model = [data objectAtIndex:row];
        if ([model.sid integerValue] == 0) {
            static NSString *infoIdentifier = @"InformationCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:nil options:nil] objectAtIndex:0];
            }
            [(InformationCell *)cell setModel:model];
            tableCell = cell;
        }else{
            static NSString *recInfoIdentifier = @"RecInformationCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recInfoIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RecInformationCell" owner:nil options:nil] objectAtIndex:0];
            }
            tableCell = cell;
        }
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InformationDetailController *controller = [[InformationDetailController alloc] initWithNibName:@"InformationDetailController" bundle:nil];
    InfoModel *model = [[_artListData objectForKey:[NSString stringWithFormat:@"%d",_curIndex]] objectAtIndex:indexPath.row];
    controller.artid = model.artid;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)changeMenuState
{
    for (int i = 0; i < [artClassify count]&&[artClassify count] > 0; i++) {
        UIButton *menuBtn_ = (UIButton *)[self.view viewWithTag:1000+i];
        if (i == _curIndex) {
            [menuBtn_ setTitleColor:COLOR_WITH_ARGB(83, 170, 97, 1.0) forState:UIControlStateNormal];
        }else{
            [menuBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    NSInteger maxOffset = [artClassify count]*MENU_FIXED_WIDTH-320;
    [UIView animateWithDuration:.25f animations:^{
        instruction.frame = CGRectMake(_curIndex*MENU_FIXED_WIDTH, MENU_FIXED_HEIGHT - 2, MENU_FIXED_WIDTH, 2);
        if (_curIndex != 0) {
            if (_curIndex*MENU_FIXED_WIDTH <= maxOffset) {
                menuScroll.contentOffset = CGPointMake((_curIndex-1)*MENU_FIXED_WIDTH, 0);
            }else{
                menuScroll.contentOffset = CGPointMake(maxOffset, 0);
            }
        }else{
            menuScroll.contentOffset = CGPointZero;
        }
    }];
    NSString *indexKey = [NSString stringWithFormat:@"%d",_curIndex];
    NSArray *data = [_artListData objectForKey:indexKey];
    if ([data count] == 0) {
        UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
        [tableView headerBeginRefreshing];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == infoScroll) {
        _curIndex = (NSInteger)scrollView.contentOffset.x/320;
        [self changeMenuState];
    }
}

@end

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

- (void)requestInfoList:(NSString *)detailtype withKey:(NSInteger)key;

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
    [self requestInfoList:((CodeSheetObject *)[artClassify objectAtIndex:0]).code withKey:0];
    
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
    for (int i = 0; i < [artClassify count]; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*320, 0, 320, SCREEN_H - MENU_FIXED_HEIGHT - 64) style:UITableViewStylePlain];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        if (IOS7_OR_LATER) {
            [tableView setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
        }
        tableView.backgroundColor = [UIColor clearColor];
        [_tableArr addObject:tableView];
        [infoScroll addSubview:tableView];
    }
    [self.view addSubview:infoScroll];
}

- (void)requestArtClassify
{
    [DataInterface getCodeSheet:@"artClassify" fathercode:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
        artClassify = [ModelGenerator json2CodeSheet:dict];
        [self addDynamicMenu];
        [self addListView];
    }];
}

- (void)requestInfoList:(NSString *)classify withKey:(NSInteger)key
{
    [DataInterface getInfoList:@"2" detailtype:@"1" tag:@"" classify:classify arttype:@"" contentlength:@"30" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        NSMutableArray *tmpArr = [ModelGenerator json2InfoList:dict];
        NSString *indexKey = [NSString stringWithFormat:@"%d",key];
        NSMutableArray *classifyArr = [_artListData objectForKey:indexKey];
        if ([classifyArr count] != 0) {
            if (loadingMore) {
                [classifyArr addObjectsFromArray:tmpArr];
            }else{
                [classifyArr removeAllObjects];
                [_artListData setObject:tmpArr forKey:indexKey];
            }
        }else{
            [_artListData setObject:tmpArr forKey:indexKey];
        }
        UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
        [infoScroll scrollRectToVisible:CGRectMake(320*key, MENU_FIXED_HEIGHT, 320, SCREEN_H - MENU_FIXED_HEIGHT - 64) animated:NO];
        [tableView reloadData];
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
    for (int i = 0; i < [artClassify count]; i++) {
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
        [self requestInfoList:((CodeSheetObject *)[artClassify objectAtIndex:_curIndex]).code withKey:_curIndex];
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

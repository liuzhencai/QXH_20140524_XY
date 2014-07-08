//
//  TribeController.m
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "TribeController.h"
#import "MyTribeListCell.h"
#import "CreatTribeViewController.h"
#import "TribeDynamicViewController.h"
#import "TribeDetailViewController.h"
#import "CustomSegmentControl.h"
#import "ChatRoomController.h"
#import "FindTribeResultViewController.h"

@interface TribeController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CustomSegmentControlDelegate>
@property (nonatomic, strong) UITableView *myTribesTable;
@property (nonatomic, strong) UITableView *allTribesTable;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, strong) NSMutableArray *tribeList;//我的部落
@property (nonatomic, strong) NSMutableArray *allTribeList;//所有部落

@end

#define MY_TRIBE_TABLE_TAG 2330
#define ALL_TRIBE_TABLE_TAG 2331

#define CELL_HEIGHT 80

@implementation TribeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectIndex = 1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"部落";
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,80, 30);
    [righttbuttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [righttbuttonItem setTitle:@"创建部落" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(createTribe:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    //segment
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"我的部落",@"所有部落"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *allTribeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    allTribeTable.tag = ALL_TRIBE_TABLE_TAG;
    self.allTribesTable = allTribeTable;
    allTribeTable.hidden = YES;
    allTribeTable.delegate = self;
    allTribeTable.dataSource = self;
    allTribeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:allTribeTable];
    
    UITableView *myTribeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    myTribeTable.tag = MY_TRIBE_TABLE_TAG;
    self.myTribesTable = myTribeTable;
    myTribeTable.delegate = self;
    myTribeTable.dataSource = self;
    myTribeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTribeTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找部落";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.delegate = self;
    allTribeTable.tableHeaderView = self.searchBar;
    
    [self getTribeList];
}

- (void)getTribeList{
    /**
     *  获取部落/群组/直播间列表
     *
     *  @param type      1为获取已加入的部落列表，2为搜索相关部落列表(为2时读取下列条件)
     *  @param tribename 部落名称
     *  @param authflag  0为全部，1为普通部落，2为官方认证部落
     *  @param status    1为状态正常的部落(可聊天使用的部落),2为申请中的部落(不能聊天)
     *  @param tribetype 1为部落，2为直播间
     *  @param tag       搜索是只允许单个标签搜索
     *  @param district  地域信息
     *  @param start     起始位置
     *  @param count     获取数量
     *  @param callback  回调
     */

    [DataInterface requestTribeList:@"1"
                          tribename:@""
                           authflag:@"0"
                             status:@"1"
                          tribetype:@"1"
                                tag:@""
                           district:@""
                              start:@"0"
                              count:@"20"
              withCompletionHandler:^(NSMutableDictionary *dict){
                  NSLog(@"部落列表返回值：%@",dict);

                  if (dict) {
                      NSArray *list = [dict objectForKey:@"list"];
                      self.tribeList = [NSMutableArray arrayWithArray:list];
                      [_myTribesTable reloadData];
                  }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomSegmentControlDelegate
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"%d",index);
    NSInteger tag = MY_TRIBE_TABLE_TAG + index;
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    table.hidden = NO;
    [self.view bringSubviewToFront:table];
    
    NSInteger lastTag = (tag + 1) % 2 + MY_TRIBE_TABLE_TAG;
    UITableView *lastTable = (UITableView *)[self.view viewWithTag:lastTag];
    lastTable.hidden = YES;
    if (index == 1) {
        /**
         *  获取部落/群组/直播间列表
         *
         *  @param type      1为获取已加入的部落列表，2为搜索相关部落列表(为2时读取下列条件)
         *  @param tribename 部落名称
         *  @param authflag  0为全部，1为普通部落，2为官方认证部落
         *  @param tribetype 1为部落，2为直播间
         *  @param tag       搜索是只允许单个标签搜索
         *  @param district  地域信息
         *  @param start     起始位置
         *  @param count     获取数量
         *  @param callback  回调
         */
        [DataInterface requestTribeList:@"2"
                              tribename:@""
                               authflag:@"0"
                                 status:@"0"
                              tribetype:@"1"
                                    tag:@""
                               district:@""
                                  start:@"0"
                                  count:@"20"
                  withCompletionHandler:^(NSMutableDictionary *dict){
                      NSLog(@"部落列表返回值：%@",dict);

                      NSArray *list = [dict objectForKey:@"list"];
                      self.allTribeList = [NSMutableArray arrayWithArray:list];
                      [table reloadData];
//                      [self showAlert:[dict objectForKey:@"info"]];
                  }];
    }
}

- (void)createTribe:(UIButton *)sender{
    NSLog(@"创建部落");
    CreatTribeViewController *creatTribe = [[CreatTribeViewController alloc] init];
    [self.navigationController pushViewController:creatTribe animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
        return [self.tribeList count];
    }else{
        return [self.allTribeList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == ALL_TRIBE_TABLE_TAG) {
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        MyTribeListCell *allListCell = nil;
        allListCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!allListCell) {
            allListCell = [[MyTribeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            allListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *memberDict = [self.allTribeList objectAtIndex:indexPath.row];
        if (memberDict) {
            [allListCell resetCellParamDict:memberDict];
        }
       
        return allListCell;
    }else if(tableView.tag == MY_TRIBE_TABLE_TAG){
        static NSString *addrIdentifier = @"addrListIdentifier";
        MyTribeListCell *addrListCell = nil;
        addrListCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!addrListCell) {
            addrListCell = [[MyTribeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            addrListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.tribeList) {
            NSDictionary *myTribeDict = [self.tribeList objectAtIndex:indexPath.row];
            [addrListCell resetCellParamDict:myTribeDict];
        }
        
        return addrListCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
        NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
        NSDictionary *tribeDict = [self.tribeList objectAtIndex:indexPath.row];
        ChatRoomController *chatview =[[ChatRoomController alloc]init];
        chatview.tribeInfoDict = tribeDict;
        [self.navigationController pushViewController:chatview animated:YES];
        
//        TribeDynamicViewController *tribeDynamic = [[TribeDynamicViewController alloc] init];
//        tribeDynamic.tribeInfoDict = tribeDict;
//        [self.navigationController pushViewController:tribeDynamic animated:YES];
    }else if(tableView.tag == ALL_TRIBE_TABLE_TAG){
        NSLog(@"点击我的消息第%d行", indexPath.row);

        NSDictionary *tribeDict = [self.allTribeList objectAtIndex:indexPath.row];
        TribeDetailViewController *detail = [[TribeDetailViewController alloc] init];
        detail.tribeDict = tribeDict;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");
    [DataInterface requestTribeList:@"2"
                          tribename:searchBar.text
                           authflag:@"0"
                             status:@"0"
                          tribetype:@""
                                tag:@""
                           district:@""
                              start:@"0"
                              count:@"20"
              withCompletionHandler:^(NSMutableDictionary *dict){
                  NSLog(@"部落列表返回值：%@",dict);
                  NSArray *list = [dict objectForKey:@"list"];
                  if ([list count]) {
                      //跳到下一页
                      FindTribeResultViewController *tribeResult = [[FindTribeResultViewController alloc] init];
                      tribeResult.allTribeList = [[NSMutableArray alloc] initWithArray:list];
                      [self.navigationController pushViewController:tribeResult animated:YES];
                  }else{
                      [self showAlert:@"没有找到相关部落"];
                  }
//                  [self showAlert:[dict objectForKey:@"info"]];
              }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

@end

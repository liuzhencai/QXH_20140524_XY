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
#import "MJRefresh.h"

@interface TribeController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CustomSegmentControlDelegate>
@property (nonatomic, strong) UITableView *myTribesTable;
@property (nonatomic, strong) UITableView *allTribesTable;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, strong) NSMutableArray *tribeList;//我的部落
@property (nonatomic, strong) NSMutableArray *allTribeList;//所有部落

@property (nonatomic, assign) NSInteger curIndex;//当前下标

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
        _tribeList = [[NSMutableArray alloc] initWithCapacity:0];
        _allTribeList = [[NSMutableArray alloc] initWithCapacity:0];
        _selectIndex = 1;
        _curIndex = 0;
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
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"我的部落",@"推荐部落"]];
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
    [self setupRefresh:allTribeTable];
    [self.view addSubview:allTribeTable];
    
    UITableView *myTribeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    myTribeTable.tag = MY_TRIBE_TABLE_TAG;
    self.myTribesTable = myTribeTable;
    myTribeTable.delegate = self;
    myTribeTable.dataSource = self;
    myTribeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh:myTribeTable];
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

//    [DataInterface requestTribeList:@"1"
//                          tribename:@""
//                           authflag:@"0"
//                             status:@"1"
//                          tribetype:@"1"
//                                tag:@""
//                           district:@""
//                              start:@"0"
//                              count:@"20"
//              withCompletionHandler:^(NSMutableDictionary *dict){
//                  NSLog(@"部落列表返回值：%@",dict);
//
//                  if (dict) {
//                      NSArray *list = [dict objectForKey:@"list"];
//                      self.tribeList = [NSMutableArray arrayWithArray:list];
//                      [_myTribesTable reloadData];
//                  }
//    }];
    
    [self.myTribesTable headerBeginRefreshing];
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
    _curIndex = index;
    if (_curIndex == 0) {
        if ([self.tribeList count] == 0) {
            [self.myTribesTable headerBeginRefreshing];
        }
    }else{
        if ([self.allTribeList count] == 0) {
            [self.allTribesTable headerBeginRefreshing];
        }
    }
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

//        [DataInterface requestTribeList:@"2"
//                              tribename:@""
//                               authflag:@"0"
//                                 status:@"0"
//                              tribetype:@"1"
//                                    tag:@""
//                               district:@""
//                                  start:@"0"
//                                  count:@"20"
//                  withCompletionHandler:^(NSMutableDictionary *dict){
//                      NSLog(@"部落列表返回值：%@",dict);
//
//                      NSArray *list = [dict objectForKey:@"list"];
//                      self.allTribeList = [NSMutableArray arrayWithArray:list];
//                      [table reloadData];
////                      [self showAlert:[dict objectForKey:@"info"]];
//                  }];
    }
}

- (void)createTribe:(UIButton *)sender{
    NSLog(@"创建部落");
    CreatTribeViewController *creatTribe = [[CreatTribeViewController alloc] init];
    [self.navigationController pushViewController:creatTribe animated:YES];
}

- (void)requestInfoList:(NSString *)type start:(NSString *)start withCompletionHandler:(ListCallback)callback{
    [DataInterface requestTribeList:type
                          tribename:@""
                           authflag:@"0"
                             status:@"0"
                          tribetype:@"1"
                                tag:@""
                           district:@""
                              start:start
                              count:@"20"
              withCompletionHandler:^(NSMutableDictionary *dict){
                  NSLog(@"部落列表返回值：%@",dict);
                  
                  NSMutableArray *list = (NSMutableArray *)[dict objectForKey:@"list"];
                  callback(list);
              }];
    
}

#pragma mark - Refresh
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
    NSString *type = _curIndex == 0 ? @"1":@"2";
    [self requestInfoList:type start:@"0" withCompletionHandler:^(NSMutableArray *list) {
        // 1.添加数据
        if (_curIndex == 0) {
            [self.tribeList removeAllObjects];
            [self.tribeList addObjectsFromArray:list];
            [self.myTribesTable reloadData];
            [self.myTribesTable headerEndRefreshing];
        }else{
            [self.allTribeList removeAllObjects];
            [self.allTribeList addObjectsFromArray:list];
            [self.allTribesTable reloadData];
            [self.allTribesTable headerEndRefreshing];
        }
        
        
        // 2.2秒后刷新表格UI
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 刷新表格
//            UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
//            [tableView reloadData];
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [tableView headerEndRefreshing];
//        });
    }];
}

- (void)footerRereshing{
    NSString *type = _curIndex == 0 ? @"1":@"2";
    NSString *startId = @"0";
    if (_curIndex == 0) {
        if ([self.tribeList count]) {
            NSDictionary *dict = [self.tribeList lastObject];
            startId = [[dict objectForKey:@"tribeid"] stringValue];
        }
    }else{
        if ([self.allTribeList count]) {
            NSDictionary *dict = [self.allTribeList lastObject];
            startId = [[dict objectForKey:@"tribeid"] stringValue];
        }
    }
    [self requestInfoList:type start:startId withCompletionHandler:^(NSMutableArray *list) {
        // 1.添加数据
        if (_curIndex == 0) {
            [self.tribeList addObjectsFromArray:list];
            [self.myTribesTable reloadData];
            [self.myTribesTable footerEndRefreshing];
        }else{
            [self.allTribeList addObjectsFromArray:list];
            [self.allTribesTable reloadData];
            [self.allTribesTable footerEndRefreshing];
        }
        
        
        // 2.2秒后刷新表格UI
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 刷新表格
        //            UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
        //            [tableView reloadData];
        //            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //            [tableView headerEndRefreshing];
        //        });
    }];
//    NSString *indexKey = [NSString stringWithFormat:@"%d",_curIndex];
//    NSArray *data = [_artListData objectForKey:indexKey];
//    InfoModel *model = [data lastObject];
//    // 1.添加数据
//    [self requestInfoList:((CodeSheetObject *)[artClassify objectAtIndex:_curIndex]).code start:model.artid withCompletionHandler:^(NSMutableArray *list) {
//        NSMutableArray *classifyArr = [_artListData objectForKey:indexKey];
//        if ([classifyArr count] != 0) {
//            if (loadingMore) {
//                [classifyArr addObjectsFromArray:list];
//            }else{
//                [classifyArr removeAllObjects];
//                [_artListData setObject:list forKey:indexKey];
//            }
//        }else{
//            [_artListData setObject:list forKey:indexKey];
//        }
//        // 2.2秒后刷新表格UI
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            UITableView *tableView = [_tableArr objectAtIndex:_curIndex];
//            [infoScroll scrollRectToVisible:CGRectMake(320*_curIndex, MENU_FIXED_HEIGHT, 320, SCREEN_H - MENU_FIXED_HEIGHT - 64) animated:NO];
//            // 刷新表格
//            [tableView reloadData];
//            
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [tableView footerEndRefreshing];
//        });
//    }];
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

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
#import "CustomSegmentView.h"
#import "CustomSegmentControl.h"

@interface TribeController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CustomSegmentControlDelegate>
@property (nonatomic, assign) int selectIndex;

@end

#define MY_TRIBE_TABLE_TAG 2330
#define ALL_TRIBE_TABLE_TAG 2331

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
    // Do any additional setup after loading the view from its nib.
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
    allTribeTable.delegate = self;
    allTribeTable.dataSource = self;
    [self.view addSubview:allTribeTable];
    
    UITableView *myTribeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    myTribeTable.tag = MY_TRIBE_TABLE_TAG;
    myTribeTable.delegate = self;
    myTribeTable.dataSource = self;
    [self.view addSubview:myTribeTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找部落";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTribeTable.tableHeaderView = self.searchBar;
    
    // Create the search display controller
    //    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    //    self.searchDC.searchResultsDataSource = self;
    //    self.searchDC.searchResultsDelegate = self;
    
    //网络请求
//    {
//    opercode:"0111",
//    userid:"1234565",		//用户唯一标识
//    token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
//    type:"1",			//1为获取已加入的部落列表，2为搜索相关部落列表(为2时读取下列条件)
//    tribename:"部落名称",		//部落名称
//    signature:"部落签名",		//部落签名
//    desc:"部落描述",		//部落描述
//    condition:"加入条件",		//加入条件
//    purpose:"宗旨",			//宗旨
//    rule:"章程",			//章程
//    tags:"标签，标签"，		//不同标签之间用逗号隔开
//    district:"130400",		//地域信息
//    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:nil];
    [HttpRequest requestWithParams:params andCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"返回值:%@",dict);
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
    [self.view bringSubviewToFront:table];
}

- (void)createTribe:(UIButton *)sender{
    NSLog(@"创建部落");
    CreatTribeViewController *creatTribe = [[CreatTribeViewController alloc] init];
    [self.navigationController pushViewController:creatTribe animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 100) {
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 20;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
        bgView.image = [UIImage imageNamed:@"bar_transition"];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        NSString *titleStr = nil;
        if (section == 0) {
            titleStr = @"A";
        }else if (section == 1){
            titleStr = @"B";
        }else {
            titleStr = @"C";
        }
        title.text = titleStr;
        title.backgroundColor = [UIColor clearColor];
        [bgView addSubview:title];
        
        return bgView;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = nil;
    if (tableView.tag == 100 ) {
        switch (section) {
            case 0:
            {
                sectionTitle = @"A";
            }
                break;
            case 1:
            {
                sectionTitle = @"B";
            }
                break;
            case 2:
            {
                sectionTitle = @"C";
            }
                break;
            default:
                break;
        }
    }
    return sectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView.tag == ALL_TRIBE_TABLE_TAG) {
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        MyTribeListCell *allListCell = nil;
        allListCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!allListCell) {
            allListCell = [[MyTribeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            allListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell = allListCell;
    }else if(tableView.tag == MY_TRIBE_TABLE_TAG){
        static NSString *addrIdentifier = @"addrListIdentifier";
        MyTribeListCell *addrListCell = nil;
        addrListCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!addrListCell) {
            addrListCell = [[MyTribeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            addrListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell = addrListCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
        NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
        TribeDynamicViewController *tribeDynamic = [[TribeDynamicViewController alloc] init];
        [self.navigationController pushViewController:tribeDynamic animated:YES];
    }else if(tableView.tag == ALL_TRIBE_TABLE_TAG){
        NSLog(@"点击我的消息第%d行", indexPath.row);
//        {
//        opercode:"0114",
//        userid:"1234565",		//用户唯一标识
//        token:"ab123456789",		//当用户登陆之后，服务器会指定唯一的令牌给相应的客户端，通过此令牌拥有用户权限
//        tribeid:"123444"		//部落唯一标示
//        }
        
        
        TribeDetailViewController *detail = [[TribeDetailViewController alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
//83,170,97
- (void)btnClick:(id)sender {
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
    [UIView animateWithDuration:0.1 animations:^{
        slippag1.hidden = !slippag1.hidden;
        slippag2.hidden = !slippag2.hidden;
    } completion:nil];
    [self.view bringSubviewToFront:[self.view viewWithTag:tag]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

@end

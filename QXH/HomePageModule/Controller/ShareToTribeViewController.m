//
//  ShareToTribeViewController.m
//  QXH
//
//  Created by XueYong on 5/22/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "ShareToTribeViewController.h"
#import "ShareToTribeCell.h"

@interface ShareToTribeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *tribesList;//部落列表
@end

@implementation ShareToTribeViewController

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
    self.title = @"部落";
    // Do any additional setup after loading the view.
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    _searchBar.placeholder = @"输入名字查找部落";
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.delegate = self;
    _mainTable.tableHeaderView = _searchBar;
    
    [self getTribeList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    
//    [DataInterface requestTribeList:@"2"
//                          tribename:@""
//                           authflag:@"0"
//                          tribetype:@"1"
//                                tag:@""
//                           district:@""
//                              start:@"0"
//                              count:@"20"
//              withCompletionHandler:^(NSMutableDictionary *dict)
    
    
     [DataInterface requestTribeList:@"1"
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
                  
                  if (dict) {
                      NSArray *list = [dict objectForKey:@"list"];
                      self.tribesList = [NSMutableArray arrayWithArray:list];
//                      UITableView *table = (UITableView *)[self.view viewWithTag:MY_TRIBE_TABLE_TAG];
                      [_mainTable reloadData];
                  }
                  [self showAlert:[dict objectForKey:@"info"]];
              }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tribesList count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
//    bgView.image = [UIImage imageNamed:@"bar_transition"];
//    return bgView;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
//    bgView.image = [UIImage imageNamed:@"bar_transition"];
//    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
//    NSString *titleStr = nil;
//    if (section == 0) {
//        titleStr = @"A";
//    }else if (section == 1){
//        titleStr = @"B";
//    }else {
//        titleStr = @"C";
//    }
//    title.text = titleStr;
//    title.backgroundColor = [UIColor clearColor];
//    [bgView addSubview:title];
//    
//    return bgView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    
    ShareToTribeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ShareToTribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.tribesList) {
        NSDictionary *tribe = [self.tribesList objectAtIndex:indexPath.row];
        [cell resetCellParamDict:tribe];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (self.shareToTribeBlock) {
        NSDictionary *dict = [self.tribesList objectAtIndex:indexPath.row];
        self.shareToTribeBlock(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}


@end

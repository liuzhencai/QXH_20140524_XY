//
//  AddressListsViewController.m
//  QXH
//
//  Created by XueYong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddrListCell.h"
#import "MyMsgCell.h"
#import "LoginViewController.h"
#import "NameCardViewController.h"
#import "PeocelCell.h"
#import "MyMessageCell.h"
#import "CustomSegmentControl.h"

@interface AddressListViewController ()<CustomSegmentControlDelegate>
@property (nonatomic, assign) int selectIndex;

@end

#define ADDRESS_LIST_TABLE_TAG 2330
#define MY_MESSAGE_LIST_TABLE_TAG 2331

@implementation AddressListViewController

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
    //登陆
//    LoginViewController *login = [[LoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
//    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.hidesBottomBarWhenPushed = NO;
    // Do any additional setup after loading the view from its nib.
    self.title = @"通讯录";
    
    //segment
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"通讯录",@"我的消息"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *myMessageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    myMessageTable.tag = MY_MESSAGE_LIST_TABLE_TAG;
    myMessageTable.delegate = self;
    myMessageTable.dataSource = self;
    [self.view addSubview:myMessageTable];
    
    UITableView *addressListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    addressListTable.tag = ADDRESS_LIST_TABLE_TAG;
    addressListTable.delegate = self;
    addressListTable.dataSource = self;
    [self.view addSubview:addressListTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找朋友";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addressListTable.tableHeaderView = self.searchBar;
    
    // Create the search display controller
    //    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    //    self.searchDC.searchResultsDataSource = self;
    //    self.searchDC.searchResultsDelegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomSegmentControlDelegate
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"segment clicked:%d",index);
    NSInteger tag = ADDRESS_LIST_TABLE_TAG + index;
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        return 20;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
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
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG ) {
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
    if (tableView.tag == MY_MESSAGE_LIST_TABLE_TAG) {
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        MyMessageCell *myMsgCell = nil;
        myMsgCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!myMsgCell) {
            myMsgCell = [[MyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
        }
        cell = myMsgCell;
    }else if(tableView.tag == ADDRESS_LIST_TABLE_TAG){
        static NSString *addrIdentifier = @"addrListIdentifier";
        PeocelCell *addrListCell = nil;
        addrListCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!addrListCell) {
            addrListCell = [[PeocelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
        }
        cell = addrListCell;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
        if (self.addressListBlock) {
            self.addressListBlock(nil);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NameCardViewController *nameCard = [[NameCardViewController alloc] init];
            [self.navigationController pushViewController:nameCard animated:YES];
        }
    }else if(tableView.tag == MY_MESSAGE_LIST_TABLE_TAG){
        NSLog(@"点击我的消息第%d行", indexPath.row);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

@end

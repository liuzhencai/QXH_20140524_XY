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
@interface AddressListViewController ()
@property (nonatomic, assign) int selectIndex;

@end

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
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    self.title = @"通讯录";
    
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(160 * i, 0, 160, 30);
        btn.tag = 1 + i;
        NSString *title = @"通讯录";
        [btn setTitleColor:COLOR_WITH_ARGB(83, 170, 97, 1.0) forState:UIControlStateNormal];
        if (i == 1) {
            title = @"我的消息";
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        //83,170,97
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UIImageView *slippag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH, 2)];
    slippag.image = [UIImage imageNamed:@"navigation_slippage_bar_bg"];
    [self.view addSubview:slippag];
    
    for (int i = 0; i < 2; i ++) {
        UIImageView *slippag = [[UIImageView alloc] initWithFrame:CGRectMake(160 * i, 30, UI_SCREEN_WIDTH/2, 2)];
        slippag.tag = 1000 + i;
        slippag.image = [UIImage imageNamed:@"navigation_slippage_bar_green"];
        if (i == 1) {
            slippag.hidden = YES;
        }
        [self.view addSubview:slippag];
    }
    
    UITableView *table2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    table2.tag = 101;
    table2.delegate = self;
    table2.dataSource = self;
    [self.view addSubview:table2];
    
    UITableView *table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    table1.tag = 100;
    table1.delegate = self;
    table1.dataSource = self;
    [self.view addSubview:table1];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找朋友";
//    self.searchBar.tintColor = [UIColor clearColor];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
    table1.tableHeaderView = self.searchBar;
    
    
    // Create the search display controller
    
    //    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    //
    //    self.searchDC.searchResultsDataSource = self;
    //
    //    self.searchDC.searchResultsDelegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 70;
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
    if (tableView.tag == 101) {
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
//        MyMsgCell *myMsgCell = nil;
//        myMsgCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
//        if (!myMsgCell) {
//            myMsgCell = [[[NSBundle mainBundle] loadNibNamed:@"MyMsgCell" owner:nil options:nil] objectAtIndex:0];
//        }
//        cell = myMsgCell;
        
        MyMessageCell *myMsgCell = nil;
        myMsgCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!myMsgCell) {
            myMsgCell = [[MyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
        }
        cell = myMsgCell;
    }else if(tableView.tag == 100){
        static NSString *addrIdentifier = @"addrListIdentifier";
//
//        AddrListCell *addrListCell = nil;
//        addrListCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
//        if (!addrListCell) {
//            addrListCell = [[[NSBundle mainBundle] loadNibNamed:@"AddrListCell" owner:nil options:nil] objectAtIndex:0];
//        }
//        cell = addrListCell;
        
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
    if (tableView.tag == 100) {
        NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
        if (self.addressListBlock) {
            self.addressListBlock(nil);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NameCardViewController *nameCard = [[NameCardViewController alloc] init];
            [self.navigationController pushViewController:nameCard animated:YES];
        }
    }else if(tableView.tag == 101){
        NSLog(@"点击我的消息第%d行", indexPath.row);
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
    //    BOOL hidden1 = tag%100;
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

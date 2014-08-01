//
//  FindAddressResultViewController.m
//  QXH
//
//  Created by XueYong on 7/12/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "FindAddressResultViewController.h"
#import "PeocelCell.h"
#import "NameCardViewController.h"

@interface FindAddressResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;

@end

@implementation FindAddressResultViewController

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
    // Do any additional setup after loading the view.
    self.title = @"好友搜索结果";
    //table
    if (self.membersList && [self.membersList count] > 0) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTable];
    }
    else {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, UI_SCREEN_WIDTH, 30)];
        tipLabel.text = @"没有找到人员信息";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tipLabel];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.membersList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myMsgIdentifier = @"identifier";
    PeocelCell *allListCell = nil;
    allListCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
    if (!allListCell) {
        allListCell = [[PeocelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
        allListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    NSDictionary *member = [self.membersList objectAtIndex:indexPath.section];
//    NSArray *list = [member objectForKey:@"list"];
//    NSDictionary *memberDict = [list objectAtIndex:indexPath.row];
    NSDictionary *memberDict = [self.membersList objectAtIndex:indexPath.row];
    if (memberDict) {
        [allListCell resetCellParamDict:memberDict];
    }
    
    return allListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击我的消息第%d行", indexPath.row);
//    NSDictionary *member = [self.membersList objectAtIndex:indexPath.section];
//    NSArray *list = [member objectForKey:@"list"];
//    NSDictionary *memberDict = [list objectAtIndex:indexPath.row];
    NSDictionary *memberDict = [self.membersList objectAtIndex:indexPath.row];
    NameCardViewController *nameCard = [[NameCardViewController alloc] init];
    nameCard.isMyFriend = YES;
    nameCard.memberDict = memberDict;
    [self.navigationController pushViewController:nameCard animated:YES];
}

@end

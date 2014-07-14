//
//  FilterViewController.m
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "FilterActivityResultViewController.h"
#import "FilterTimeViewController.h"
#import "InActivityCell.h"
#import "ActivityDetailViewController.h"

@interface FilterActivityResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *items;

@end

@implementation FilterActivityResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = @[@"活动类型",@"活动区域",@"活动时间"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"活动筛选结果";
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.activitysList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addrIdentifier = @"activeEndIdentifier";
    InActivityCell *activeEndCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
    if (!activeEndCell) {
        activeEndCell = [[InActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
        activeEndCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.activitysList) {
        NSDictionary *activityDict = [self.activitysList objectAtIndex:indexPath.row];
        [activeEndCell resetCellParamDict:activityDict];
    }
    return activeEndCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *inActivity = [self.activitysList objectAtIndex:indexPath.row];
    ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
    activityDetail.activityId = [inActivity objectForKey:@"actid"];
    [self.navigationController pushViewController:activityDetail animated:YES];
    
}

@end

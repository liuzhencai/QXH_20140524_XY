//
//  FindResultViewController.m
//  QXH
//
//  Created by XueYong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "FindResultViewController.h"
#import "PeocelCell.h"
#import "NameCardViewController.h"

@interface FindResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;

@end

@implementation FindResultViewController

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
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"找人";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_HEIGHT, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.findPeopleResults count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = [self.findPeopleResults objectAtIndex:section];
    NSArray *list = [dict objectForKey:@"list"];
    return [list count];
//    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    bgView.image = [UIImage imageNamed:@"bar_transition"];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    
    title.backgroundColor = [UIColor clearColor];
    
//    NSDictionary *dict = nil;
    NSDictionary *dict = [self.findPeopleResults objectAtIndex:section];
    if (dict) {
        NSString *titleStr = [dict objectForKey:@"name"];
        title.text = titleStr;
    }
    [bgView addSubview:title];
    return bgView;
    //    }
    //    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifiter = @"identifiter";
    PeocelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    if (!cell) {
        cell = [[PeocelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.name.text = @"李某某";
//    cell.duty.text = @"xxxxxxxxxxxxxx校长";
    NSDictionary *dict = [self.findPeopleResults objectAtIndex:indexPath.section];
    NSArray *list = [dict objectForKey:@"list"];
    NSDictionary *member = [list objectAtIndex:indexPath.row];
    if (member) {
        [cell resetCellParamDict:member];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    NSDictionary *dict = [self.findPeopleResults objectAtIndex:indexPath.section];
    NSArray *list = [dict objectForKey:@"list"];
    NSDictionary *member = [list objectAtIndex:indexPath.row];
    NameCardViewController *nameCard = [[NameCardViewController alloc] init];
    nameCard.memberDict = member;
    [self.navigationController pushViewController:nameCard animated:YES];
}

@end

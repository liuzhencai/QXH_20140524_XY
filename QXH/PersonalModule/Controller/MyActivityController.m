//
//  MyActivityController.m
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyActivityController.h"
#import "MyActivityCell.h"
#import "ActivityDetailViewController.h"

@interface MyActivityController ()

@end

@implementation MyActivityController

- (void)getActList
{
    [DataInterface getActList:@"10" count:@"20" actname:@"" contentlength:@"30" tag:@"" district:@"" canjoin:@"3" actstate:@"0" tribeid:@"0" begindate:@"" enddate:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
        [self showAlert:[dict description]];
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
    // Do any additional setup after loading the view from its nib.
    self.title = @"参加的活动";
    
    [self getActList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"myActivity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyActivityCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityDetailViewController *controller = [[ActivityDetailViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

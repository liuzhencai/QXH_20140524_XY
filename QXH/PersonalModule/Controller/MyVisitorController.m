//
//  MyVisitorController.m
//  QXH
//
//  Created by ZhaoLilong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyVisitorController.h"
#import "MyVisitorCell.h"
#import "NameCardViewController.h"

@interface MyVisitorController ()
{
    NSMutableArray *vistors;
}

@end

@implementation MyVisitorController

- (void)getVisitorList
{
    [DataInterface getVisitorList:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict) {
//        [self showAlert:[dict description]];
        vistors = [ModelGenerator json2VistorList:dict];
        [_vistorTbl reloadData];
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
    self.title = @"访客记录";
    [self getVisitorList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [vistors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"myVisitor";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyVisitorCell" owner:nil options:nil] objectAtIndex:0];
    }
    VistorModel *model = [vistors objectAtIndex:indexPath.row];
    [(MyVisitorCell *)cell setVistor:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameCardViewController *controller = [[NameCardViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

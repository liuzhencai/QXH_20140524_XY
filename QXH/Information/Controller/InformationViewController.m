//
//  InformationViewController.m
//  QXH
//
//  Created by liuzhencai on 14-5-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationCell.h"
#import "ClassificationControll.h"
#import "InformationDetailController.h"
#import "InfoModel.h"

@interface InformationViewController ()
{
    NSMutableArray *info;
}

- (void)requestInfoList:(NSString *)detailtype;

@end

@implementation InformationViewController

@synthesize _tableview;

- (void)requestInfoList:(NSString *)detailtype
{
    [DataInterface getInfoList:@"2" detailtype:detailtype tag:@"" arttype:@"" contentlength:@"30" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        info = [ModelGenerator json2InfoList:dict];
        [_tableview reloadData];
        NSLog(@"info--->%@",info);
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
    self.title = @"智谷";
    self._tableview.backgroundColor = [UIColor clearColor];
    
    [self requestInfoList:@"1"];
    
//    ClassificationControll* aview = [[ClassificationControll alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    aview.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:aview];
    
    CustomSegmentControl *segmentControl = [[CustomSegmentControl alloc]initWithFrame:CGRectMake(0, 0, 320, 34) andTitles:@[@"最新",@"收藏",@"教育",@"学生"]];
    segmentControl.delegate = self;
    [self.view addSubview:segmentControl];
//    NSInteger height = SCREEN_H;
    self._tableview.frame = CGRectMake(0, 34, 320, SCREEN_H-34) ;
    // Do any additional setup after loading the view from its nib.
}

- (void)segmentClicked:(NSInteger)index
{
    NSLog(@"index-->%d",index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [info count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"firstCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            [cell.contentView addSubview:_recommendView];
            
        }
    }else{
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        static NSString *cellIdentifier = @"InformationCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:nil options:nil] objectAtIndex:0];
        }
        [(InformationCell *)cell setModel:[info objectAtIndex:indexPath.row - 1]];
    }
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationDetailController *controller = [[InformationDetailController alloc] initWithNibName:@"InformationDetailController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

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
    NSMutableArray *artClassify;
}

- (void)requestInfoList:(NSString *)detailtype;

@end

@implementation InformationViewController

@synthesize _tableview;

- (void)requestArtClassify
{
    [DataInterface getCodeSheet:@"artClassify" fathercode:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
        artClassify = [ModelGenerator json2CodeSheet:dict];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (CodeSheetObject *obj in artClassify) {
            [titles addObject:obj.name];
        }
        CustomSegmentControl *segmentControl = [[CustomSegmentControl alloc]initWithFrame:CGRectMake(0, 0, 320, 34) andTitles:titles];
        segmentControl.delegate = self;
        [self.view addSubview:segmentControl];
        [self requestInfoList:@"热推"];
    }];
}

- (void)requestInfoList:(NSString *)classify
{
    [DataInterface getInfoList:@"2" detailtype:@"1" tag:@"" classify:classify arttype:@"" contentlength:@"30" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
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
    if (IOS7_OR_LATER) {
        [_tableview setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    }
    self._tableview.backgroundColor = [UIColor clearColor];
    self._tableview.frame = CGRectMake(0, 34, 320, SCREEN_H-34) ;

    [self requestArtClassify];
    
//    ClassificationControll* aview = [[ClassificationControll alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    aview.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:aview];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)segmentClicked:(NSInteger)index
{
    NSLog(@"index-->%d",index);
    [self requestInfoList:((CodeSheetObject *)artClassify[index]).code];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)calculateRowHeight:(InfoModel *)model
{
    CGFloat rowHeight = 0.f;
    if ([model.sid integerValue] == 0) {
        rowHeight = 80;
    }else{
        rowHeight = 150;
    }
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [info count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoModel *model = [info objectAtIndex:indexPath.row];
    return [self calculateRowHeight:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *tableCell;
    InfoModel *model = [info objectAtIndex:row];
    if ([model.sid integerValue] == 0) {
        static NSString *infoIdentifier = @"InformationCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:nil options:nil] objectAtIndex:0];
        }
        [(InformationCell *)cell setModel:model];
        tableCell = cell;
    }else{
        static NSString *recInfoIdentifier = @"RecInformationCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recInfoIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecInformationCell" owner:nil options:nil] objectAtIndex:0];
        }
        tableCell = cell;
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InformationDetailController *controller = [[InformationDetailController alloc] initWithNibName:@"InformationDetailController" bundle:nil];
    InfoModel *infomodel = [info objectAtIndex:indexPath.row];
    controller.artid = infomodel.artid;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

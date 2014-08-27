//
//  EverydayAskController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "EverydayAskController.h"
#import "AskCell.h"
#import "ShareTextController.h"

@interface EverydayAskController ()
{
    NSMutableArray *askInfo;
}

@end

@implementation EverydayAskController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:TYPE_LOOK__DAY_QUES];
    [MobClick beginEvent:TYPE_LOOK__DAY_QUES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:TYPE_LOOK__DAY_QUES];
    [MobClick endEvent:TYPE_LOOK__DAY_QUES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"问道";
    [DataInterface getEveryDayAsk:@"30" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        askInfo = [ModelGenerator json2AskInfo:dict];
        [_askTbl reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [askInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AskCell *cell;
    static NSString *cellIdentifier = @"askIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AskCell" owner:nil options:nil] objectAtIndex:0];
    }
    AskInfoModel *model = [askInfo objectAtIndex:indexPath.row];
    [cell setCellData:model];
    
    return cell;
}

- (SquareInfo *)convertAskInfoToSquareInfo:(AskInfoModel *)model
{
    SquareInfo *squareInfo = [[SquareInfo alloc] init];
    InfoModel *infoModel = [[InfoModel alloc] init];
    infoModel.artid = model.artid;
    infoModel.artimgs = model.artimgs;
    infoModel.authflag = model.authflag;
    infoModel.browsetime = model.browsetime;
    infoModel.content = model.content;
    infoModel.contentlength = [model.contentlength integerValue];
    infoModel.date = model.date;
//    infoModel.sid = model.sid;
    infoModel.sname = model.sname;
    infoModel.sphoto = model.sphoto;
    infoModel.title = model.title;
    squareInfo.content = infoModel;
    squareInfo.uid = [model.sid integerValue];
    return squareInfo;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareTextController *controller = [[ShareTextController alloc] initWithNibName:@"ShareTextController" bundle:nil];
    SquareInfo *squareInfo = [self convertAskInfoToSquareInfo:[askInfo objectAtIndex:indexPath.row]];
    controller.info = squareInfo;
    controller.type = SquareInfoTypeSq;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

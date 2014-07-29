//
//  SelectTribeController.m
//  QXH
//
//  Created by ZhaoLilong on 7/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SelectTribeController.h"
#import "MyTribeCell.h"
#import "MyTribeModel.h"

@interface SelectTribeController ()

@property (nonatomic, strong) NSMutableArray *tribeList;

@end

@implementation SelectTribeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestInfoList:(NSString *)type start:(NSString *)start withCompletionHandler:(ListCallback)callback{
    [DataInterface requestTribeList:type
                          tribename:@""
                           authflag:@"0"
                             status:@"0"
                          tribetype:@"1"
                                tag:@""
                           district:@""
                              start:start
                              count:@"20"
              withCompletionHandler:^(NSMutableDictionary *dict){
                  callback([ModelGenerator json2TribeList:dict]);
              }];
    
}

#pragma mark - Refresh
/**
 *  集成刷新控件
 */
- (void)setupRefresh:(UITableView *)tableView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tribeTbl addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tribeTbl addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestInfoList:@"1" start:@"0" withCompletionHandler:^(NSMutableArray *list) {
        [_tribeList removeAllObjects];
        [_tribeList addObjectsFromArray:list];
        [_tribeTbl reloadData];
        [_tribeTbl headerEndRefreshing];
    }];
}

- (void)footerRereshing{
    NSString *startId = @"0";
        if ([self.tribeList count]) {
            MyTribeModel *model = [self.tribeList lastObject];
            startId = model.tribeid;
        }
      [self requestInfoList:@"1" start:startId withCompletionHandler:^(NSMutableArray *list) {
        [_tribeList addObjectsFromArray:list];
        [_tribeTbl reloadData];
        [_tribeTbl footerEndRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tribeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"myTribe";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTribeCell" owner:nil options:nil] objectAtIndex:0];
    }
    MyTribeModel *model = [_tribeList objectAtIndex:indexPath.row];
    [(MyTribeCell *)cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyTribeModel *model = [_tribeList objectAtIndex:indexPath.row];
    switch (self.type) {
        case SelectTypeNameCard:
        {
            [self.navigationController popViewControllerAnimated:YES];
            [(MyCardController *)_parentController transmitNameCard:model.tribeid];
        }
            break;
        case SelectTypeInfTrans:
        {
            self.callback(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择部落";
    _tribeList = [[NSMutableArray alloc] init];
    [self setupRefresh:_tribeTbl];
    [_tribeTbl headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

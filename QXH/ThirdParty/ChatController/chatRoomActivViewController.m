//
//  chatRoomActivViewController.m
//  QXH
//
//  Created by liuzhencai on 14-6-19.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "chatRoomActivViewController.h"
#import "InActivityCell.h"
#import "ActivityDetailViewController.h"

@interface chatRoomActivViewController ()

@end

@implementation chatRoomActivViewController
@synthesize tableview,activitysList;
@synthesize navigation;

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
    
    //测试数据
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 20; i ++) {
        [tmpArr addObject:@{@"":@""}];
    }
    self.activitysList = [NSMutableArray arrayWithArray:tmpArr];
    
   tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
//    activityTable.tag = ACTIVITY_TABLE_TAG;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//        return [self.activitysList count];
    return 5;
 
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        return 210;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        static NSString *addrIdentifier = @"activeEndIdentifier";
        //        ActivityCell *activeEndCell = nil;
        //        activeEndCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        //        if (!activeEndCell) {
        //            activeEndCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
        //            activeEndCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        }
        //        activeEndCell.statusLabel.text = @"已结束";
        
        InActivityCell *activityingCell = nil;
        activityingCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!activityingCell) {
            activityingCell = [[InActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            activityingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    NSDictionary* dic = [self.activitysList objectAtIndex:indexPath.row];
        [activityingCell resetCellParamDict:dic];
        activityingCell.statusLabel.text = @"进行中";
        
        return activityingCell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    //    if (self.selectTribeCallBack) {
    //        NSDictionary *dict = @{@"key":@"isBack",@"value":@"YES"};
    //        self.selectTribeCallBack(dict);
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
  
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc] init];
        [navigation pushViewController:activityDetail animated:YES];
}


@end

//
//  TribeMembersViewController.m
//  QXH
//
//  Created by XueYong on 7/1/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "TribeMembersViewController.h"
#import "PeocelCell.h"

@interface TribeMembersViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;//
@property (nonatomic, strong) NSMutableArray *members;
@end

@implementation TribeMembersViewController

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
    self.title = @"成员";
    // Do any additional setup after loading the view.
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_mainTable];
    
    [self getMembers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMembers{
    if (self.tribeId) {
        /**
         *  获取部落成员列表
         *
         *  @param tribeid  部落id
         *  @param callback 回调
         */
        [DataInterface getTribeMembers:self.tribeId withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"获取部落成员列表返回值:%@",dict);
            NSArray *memberList = [dict objectForKey:@"list"];
            self.members = [NSMutableArray arrayWithArray:memberList];
            [_mainTable reloadData];
            [self showAlert:[dict objectForKey:@"info"]];
        }];
    }

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.members count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *myMsgIdentifier = @"myMsgIdentifier";
    PeocelCell *myMsgCell = nil;
    myMsgCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
    if (!myMsgCell) {
        myMsgCell = [[PeocelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
        myMsgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary* dic = (NSDictionary*)[self.members objectAtIndex:indexPath.row];
    [myMsgCell resetCellParamDict:dic];
    return myMsgCell;
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

@end

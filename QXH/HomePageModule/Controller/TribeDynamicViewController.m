//
//  TribeDynamicViewController.m
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "TribeDynamicViewController.h"
#import "CustomSegmentView.h"
#import "MyTribeDetailViewController.h"
#import "ActivityCell.h"
#import "PeocelCell.h"
#import "TribeQuestionCell.h"
#import "TribeConversationCell.h"

@interface TribeDynamicViewController ()
//@property (nonatomic, strong) UITableView *conversationTable;//会话
//@property (nonatomic, strong) UITableView *activityTable;//活动
//@property (nonatomic, strong) UITableView *membersTable;//成员

@end

@implementation TribeDynamicViewController

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
    self.title = @"xxxxxx部落";
    // Do any additional setup after loading the view.
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 40);
    [rightBtn setTitle:@"部落档案" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CustomSegmentView *segment = [[CustomSegmentView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32)];
    segment.items = @[@"会话",@"活动",@"成员"];
    segment.selectIndex = 0;
    [segment addTarget:self action:@selector(segmentAction:)];
    [self.view addSubview:segment];
    
    CGRect tableFrame = CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32);
    UITableView *activityTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    activityTable.tag = 1001;
    activityTable.delegate = self;
    activityTable.dataSource = self;
    [self.view addSubview:activityTable];
    
    UITableView *membersTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    membersTable.tag = 1002;
    membersTable.delegate = self;
    membersTable.dataSource = self;
    [self.view addSubview:membersTable];
    
    UITableView *conversationTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    conversationTable.tag = 1000;
    conversationTable.delegate = self;
    conversationTable.dataSource = self;
    [self.view addSubview:conversationTable];
//    [self.view addSubview:activityTable];
//    [self.view addSubview:membersTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detail:(UIButton *)sender{
    NSLog(@"详细资料");
    MyTribeDetailViewController *myTribeDetail = [[MyTribeDetailViewController alloc] init];
    [self.navigationController pushViewController:myTribeDetail animated:YES];
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

- (void)segmentAction:(CustomSegmentView *)segment{
    NSLog(@"select:%d",segment.selectIndex);
    NSInteger tag = segment.selectIndex + 1000;
    UIView* table = (UIView*)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [_items count];
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    bgView.image = [UIImage imageNamed:@"bar_transition"];
    
    if (tableView.tag == 1000) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd/HH:mm";
        NSString *dateString = [dateFormatter stringFromDate:date];
        UILabel *title = [self addLabelWithFrame:bgView.frame
                                            text:dateString
                                           color:[UIColor blackColor]
                                            font:[UIFont systemFontOfSize:12]];
        title.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:title];
    }
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1002) {
        return 70;
    }else if(tableView.tag == 1001){
        return 220;
    }else{
        if (indexPath.row == 0) {
            return 140;
        }
        return 110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1001) {
        static NSString *addrIdentifier = @"activeEndIdentifier";
        ActivityCell *activeEndCell = nil;
        activeEndCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!activeEndCell) {
            activeEndCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
            activeEndCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        activeEndCell.statusLabel.text = @"已结束";
        return activeEndCell;
    }else if(tableView.tag == 1002){
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        PeocelCell *myMsgCell = nil;
        myMsgCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!myMsgCell) {
            myMsgCell = [[PeocelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            myMsgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return myMsgCell;
    }else{
        if (indexPath.row == 0) {
            static NSString *identifierQuestion = @"identifierQuestion";
            TribeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierQuestion];
            if (!cell) {
                cell = [[TribeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierQuestion];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
            
        }else{
            static NSString *identifier = @"identifier";
            TribeConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TribeConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
//    if (self.selectTribeCallBack) {
//        NSDictionary *dict = @{@"key":@"isBack",@"value":@"YES"};
//        self.selectTribeCallBack(dict);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}


@end

//
//  chatRoomMemberViewController.m
//  QXH
//
//  Created by liuzhencai on 14-6-19.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "chatRoomMemberViewController.h"
#import "PeocelCell.h"
#import "NameCardViewController.h"

@interface chatRoomMemberViewController ()

@end

@implementation chatRoomMemberViewController
@synthesize tableview,Arrlist;
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
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - 50) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    // Do any additional setup after loading the view.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
        return [self.Arrlist count];
//    return 20;

}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
//    bgView.image = [UIImage imageNamed:@"bar_transition"];
//    
//    if (tableView.tag == CONVERSATION_TABLE_TAG) {
//        NSDate *date = [NSDate date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy-MM-dd/HH:mm";
//        NSString *dateString = [dateFormatter stringFromDate:date];
//        UILabel *title = [self addLabelWithFrame:bgView.frame
//                                            text:dateString
//                                           color:[UIColor blackColor]
//                                            font:[UIFont systemFontOfSize:12]];
//        title.textAlignment = NSTextAlignmentCenter;
//        [bgView addSubview:title];
//    }
//    
//    return bgView;
//}

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
    NSDictionary* dic = (NSDictionary*)[self.Arrlist objectAtIndex:indexPath.row];
    [myMsgCell resetCellParamDict:dic];
    return myMsgCell;
    
 
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);

    NameCardViewController *nameCard = [[NameCardViewController alloc] init];
    nameCard.memberDict = (NSDictionary*)[self.Arrlist objectAtIndex:indexPath.row];

    [navigation pushViewController:nameCard animated:YES];
    
    
}
@end

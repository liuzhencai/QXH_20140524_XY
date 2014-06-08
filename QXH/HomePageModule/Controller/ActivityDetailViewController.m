//
//  ActivityDetailViewController.m
//  QXH
//
//  Created by XUE on 14-5-19.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityCell.h"
#import "ShareView.h"
#import "ShareToTribeViewController.h"

@interface ActivityDetailViewController ()
@property (nonatomic, strong) UITableView *mainTable;

@end

@implementation ActivityDetailViewController

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
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"活动详情";
    // Do any additional setup after loading the view.
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT)];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTable];
    
    [self getActivityDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getActivityDetail{
    /**
     *  获取活动详细信息
     *
     *  @param actid    活动的唯一标示
     *  @param callback 回调
     */
//    + (void)getActDetailInfo:(NSString *)actid withCompletionHandler:(DictCallback)callback;
    NSString *actId = @"";
    if (self.activityId) {
        actId = self.activityId;
    }
    [DataInterface getActDetailInfo:actId withCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"活动详情返回值:%@",dict);
    }];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            rowHeight = 220.f;
        }
            break;
        case 1:
        {
            rowHeight = 130.f;
        }
            break;
        case 2:
        case 3:
            rowHeight = 100.f;
            break;
        case 4:
            rowHeight = 74.f;
            break;
        default:
            break;
    }
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
        {
            ActivityCell *dataCell;
            static NSString *cellIdentifier = @"activityIdentifier";
            dataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!dataCell) {
                dataCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
            }
            cell = dataCell;
        }
            break;
        case 1:
        {
            static NSString *cellIdentifier = @"introIdentifier";
            UITableViewCell *dataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!dataCell) {
                dataCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 120)];
                bgImage.image = [self stretchiOS6:@"label.png"];
                [dataCell.contentView addSubview:bgImage];
                
                UIImageView *titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 298, 30)];
                titleImgView.image = [UIImage imageNamed:@"title_bar_bg.png"];
                [bgImage addSubview:titleImgView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
                titleLabel.text = @"活动介绍";
                [titleImgView addSubview:titleLabel];
                
                //                UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
                //                flagLabel.text = @"活动介绍";
                //                [dataCell.contentView addSubview:flagLabel];
                
                UITextView *actContentView = [[UITextView alloc] initWithFrame:CGRectMake(1, 29, 298, 80)];
                actContentView.text = @"活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容活动内容";
                actContentView.editable = NO;
                //                actContentView.backgroundColor = [UIColor redColor];
                [bgImage addSubview:actContentView];
            }
            cell = dataCell;
        }
            break;
        case 2:
        {
            static NSString *cellIdentifier = @"signupIdentifier";
            UITableViewCell *dataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!dataCell) {
                dataCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                NSArray *items = [NSArray arrayWithObjects:@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3", nil];
                PortraitView *signUpView = [[PortraitView alloc] initWithFrame:CGRectMake(10, 0, 300, 90) title:@"报名的人 2" portraits:items andDelegate:self andShowBtn:NO];
                [dataCell.contentView addSubview:signUpView];
            }
            cell = dataCell;
        }
            break;
        case 3:
        {
            static NSString *cellIdentifier = @"followIdentifier";
            UITableViewCell *dataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!dataCell) {
                dataCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                PortraitView *followView = [[PortraitView alloc] initWithFrame:CGRectMake(10, 0, 300, 90) title:@"关注的人 2" portraits:[NSArray arrayWithObjects:@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3", nil] andDelegate:self andShowBtn:NO];
                [dataCell.contentView addSubview:followView];
            }
            cell = dataCell;
        }
            break;
        case 4:
        {
            static NSString *cellIdentifier = @"shareIdenifier";
            UITableViewCell *dataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!dataCell){
                dataCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 74)];
                bgImage.image = [self stretchiOS6:@"bootom_detail_bar_bg"];
                [dataCell.contentView addSubview:bgImage];
                
                UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                signUpBtn.backgroundColor = [UIColor redColor];
                signUpBtn.frame = CGRectMake(15, 15, 130, 44);
                [signUpBtn setTitle:@"报名" forState:UIControlStateNormal];
                [signUpBtn setBackgroundImage:[self stretchiOS6:@"btn_enroll_normal.png"] forState:UIControlStateNormal];
                [signUpBtn setBackgroundImage:[self stretchiOS6:@"btn_enroll_highlight.png"] forState:UIControlStateHighlighted];
                [signUpBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
                [dataCell.contentView addSubview:signUpBtn];
                
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                shareBtn.backgroundColor = [UIColor redColor];
                shareBtn.frame = CGRectMake(130 + 15 * 3, 15, 130, 44);
                [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
                [shareBtn setBackgroundImage:[self stretchiOS6:@"btn_share_normal.png"] forState:UIControlStateNormal];
                [shareBtn setBackgroundImage:[self stretchiOS6:@"btn_share_highlight.png"] forState:UIControlStateHighlighted];
                [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
                [dataCell.contentView addSubview:shareBtn];
            }
            cell = dataCell;
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)signUp:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    NSString *actId = @"";
    if (self.activityId) {
        actId = self.activityId;
    }
    if (btn.selected) {
//        message = @"成功报名";
        [btn setTitle:@"取消报名" forState:UIControlStateNormal];
        /**
         *  加入/关注活动
         *
         *  @param type     1为申请加入，2为关注
         *  @param actid    活动唯一标示
         *  @param callback 回调
         */
        
        [DataInterface joinAct:@"1" actid:actId withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"加入活动申请返回值:%@",dict);
            [self showAlert:[dict objectForKey:@"info"]];
        }];
        
    }else{
        [btn setTitle:@"报名" forState:UIControlStateNormal];
//        message = @"已取消报名";
        /**
         *  退出活动/取消关注
         *
         *  @param actid    活动唯一标示
         *  @param callback 回调
         */
        [DataInterface quitAct:actId withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"退出活动：%@",dict);
            [self showAlert:[dict objectForKey:@"info"]];
        }];
    }
}

- (void)share:(id)sender
{
    NSLog(@"点击了分享");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"分享到部落",@"分享到广场",@"分享到微信", nil];
    [alert show];
}

#pragma mark - PortraitViewDelegate

- (void)selectPortrait:(NSObject *)obj{
    NSLog(@"select portrait:%@",obj);
}

- (void)singUpPortrait:(NSObject *)obj{
    NSLog(@"我要报名 2");
    [self showAlert:@"成功报名"];
}

- (void)shareToSquare{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    
    ShareView *share = [[ShareView alloc] initWithParam:nil];
    share.alpha = 0.0;
    [share addSubview:view];
    [share sendSubviewToBack:view];
    [self.view addSubview:share];
    
    share.shareBlack = ^(NSDictionary *dict){
        NSLog(@"block");
        [self showAlert:@"分享成功"];
    };
    [share show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.firstOtherButtonIndex == buttonIndex) {//分享到部落
        NSLog(@"分享到部落");
        ShareToTribeViewController *shareToTribe = [[ShareToTribeViewController alloc] init];
        shareToTribe.shareToTribeBlock = ^(NSDictionary *dict){
            [self showAlert:@"分享到部落"];
        };
        [self.navigationController pushViewController:shareToTribe animated:YES];
    }else if (2 == buttonIndex){//分享到广场
        NSLog(@"分享到广场");
        [self shareToSquare];
    }else if (3 == buttonIndex){//分享到微信
        NSLog(@"分享到微信");
    }
}

- (UIImage *) stretchiOS6:(NSString *)icon {
    UIImage *image = [UIImage imageNamed:icon];
    CGFloat normalLeftCap = image.size.width * 0.5f;
    CGFloat normalTopCap = image.size.height * 0.5f;
    // 13 * 34
    // 指定不需要拉伸的区域
    UIEdgeInsets insets = UIEdgeInsetsMake(normalTopCap, normalLeftCap, normalTopCap - 1, normalLeftCap - 1);
    
    // ios6.0的拉伸方式只不过比iOS5.0多了一个拉伸模式参数
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
}


@end

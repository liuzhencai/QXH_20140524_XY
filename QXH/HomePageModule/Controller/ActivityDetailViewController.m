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
#import "InActivityCell.h"
#import "ActivityDetailCell.h"
#import "WXApi.h"
#import "WXApiObject.h"

#import "SelectCityViewController.h"//test

@interface ActivityDetailViewController (){
    enum WXScene _scene;
}
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSDictionary *activityDict;//活动详情

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
    NSString *actId = @"";
    if (self.activityId) {
        actId = self.activityId;
    }
    [DataInterface getActDetailInfo:actId withCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"活动详情返回值:%@",dict);
        if (dict) {
            self.activityDict = dict;
            [_mainTable reloadData];
        }
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
            rowHeight = 250 + 60;
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
//    if (self.isActivityEnd) {
//        return 4;
//    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
        {
            ActivityDetailCell *dataCell;
            static NSString *cellIdentifier = @"activityIdentifier";
            dataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!dataCell) {
                dataCell = [[ActivityDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            if (self.activityDict) {
                [dataCell resetCellParamDict:self.activityDict];
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
                
                UITextView *actContentView = [[UITextView alloc] initWithFrame:CGRectMake(bgImage.left + 10, titleLabel.bottom + 5, bgImage.width - 20, 80)];
                NSLog(@"frame:%@",NSStringFromCGRect(actContentView.frame));
                actContentView.tag = 220;
                actContentView.font = [UIFont systemFontOfSize:16];
                actContentView.backgroundColor = [UIColor clearColor];
                actContentView.text = @"";
                actContentView.editable = NO;
                [dataCell.contentView addSubview:actContentView];
            }
            UITextView *actContentView = (UITextView *)[dataCell.contentView viewWithTag:220];
            if (self.activityDict) {
                actContentView.text = [self.activityDict objectForKey:@"desc"];
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
//                NSArray *items = [NSArray arrayWithObjects:@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3", nil];
                
                NSArray *items = nil;
                if (self.activityDict) {
                    items = [self.activityDict objectForKey:@"joins"];
                }
                PortraitView *signUpView = [[PortraitView alloc] initWithFrame:CGRectMake(10, 0, 300, 90) title:@"报名的人" portraits:items andDelegate:self andShowBtn:NO];
                signUpView.tag = 330;
                [dataCell.contentView addSubview:signUpView];
            }
            PortraitView *signUpView = (PortraitView *)[dataCell.contentView viewWithTag:330];
            if (self.activityDict) {
                signUpView.portraits = [self.activityDict objectForKey:@"joins"];
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
                
                NSArray *items = nil;
                if (self.activityDict) {
                    items = [self.activityDict objectForKey:@"followers"];
                }
                PortraitView *followView = [[PortraitView alloc] initWithFrame:CGRectMake(10, 0, 300, 90) title:@"关注的人" portraits:items andDelegate:self andShowBtn:NO];
                followView.tag = 440;
                [dataCell.contentView addSubview:followView];
            }
            PortraitView *followView = (PortraitView *)[dataCell.contentView viewWithTag:440];
            if (self.activityDict) {
                followView.portraits = [self.activityDict objectForKey:@"followers"];
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
                signUpBtn.tag = 1101;
                [signUpBtn setBackgroundImage:[self stretchiOS6:@"btn_enroll_normal.png"] forState:UIControlStateNormal];
                [signUpBtn setBackgroundImage:[self stretchiOS6:@"btn_enroll_highlight.png"] forState:UIControlStateHighlighted];
                [signUpBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
                [dataCell.contentView addSubview:signUpBtn];
                
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                shareBtn.backgroundColor = [UIColor redColor];
                shareBtn.frame = CGRectMake(130 + 15 * 3, 15, 130, 44);
                [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
                [shareBtn setBackgroundImage:[self stretchiOS6:@"btn_share_normal.png"] forState:UIControlStateNormal];
                shareBtn.tag = 1102;
                [shareBtn setBackgroundImage:[self stretchiOS6:@"btn_share_highlight.png"] forState:UIControlStateHighlighted];
                [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
                [dataCell.contentView addSubview:shareBtn];
            }
            if (self.activityDict) {
                UIButton *signupBtn = (UIButton *)[dataCell.contentView viewWithTag:1101];
                UIButton *shareBtn = (UIButton *)[dataCell.contentView viewWithTag:1102];
                if ([self isInFollowers]) {
                    [signupBtn setTitle:@"已报名" forState:UIControlStateNormal];
                    signupBtn.enabled = NO;
                }else{
                    [signupBtn setTitle:@"报名" forState:UIControlStateNormal];
                    signupBtn.enabled = YES;
                }
//                if (self.isActivityEnd) {
//                    signupBtn.enabled = NO;
//                }
                int status = [[self.activityDict objectForKey:@"status"] intValue];
                if (status == 2 || status == 3) {//2为审批中的活动，3为审批拒绝的活动
                    shareBtn.enabled = NO;
                }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SelectCityViewController *selectCity = [[SelectCityViewController alloc] init];
//    selectCity.selectCityCallBack = ^(NSDictionary *cityDict){
//        NSLog(@"选择城市:%@",cityDict);
//        NSString *provinceName = [cityDict objectForKey:@"province"];
//        NSString *cityName = [cityDict objectForKey:@"city"];
//        NSString *address = [NSString stringWithFormat:@"%@%@",provinceName,cityName];
//        NSLog(@"%@",address);
//    };
//    [self.navigationController pushViewController:selectCity animated:YES];
}

- (void)signUp:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (self.isActivityEnd) {
        [self showAlert:@"本活动已结束，不能再报名"];
        return;
    }
    btn.selected = !btn.selected;
    NSString *actId = @"";
    if (self.activityId) {
        actId = self.activityId;
    }
//    if (btn.selected) {
//        [btn setTitle:@"" forState:UIControlStateNormal];
//         *  加入/关注活动
//         *  @param type     1为申请加入，2为关注
//         *  @param actid    活动唯一标示
//         *  @param callback 回调
//         */
        [DataInterface joinAct:@"1" actid:actId withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"加入活动申请返回值:%@",dict);
            if (dict) {
                [self showAlert:[dict objectForKey:@"info"]];
                [self getActivityDetail];
            }
        }];
//
//    }else{
//        [btn setTitle:@"报名" forState:UIControlStateNormal];
        /**
         *  退出活动/取消关注
         *  @param actid    活动唯一标示
         *  @param callback 回调
         */
//        [DataInterface quitAct:actId withCompletionHandler:^(NSMutableDictionary *dict){
//            NSLog(@"退出活动：%@",dict);
//            [self getActivityDetail];
//            [self showAlert:[dict objectForKey:@"info"]];
//        }];
//    }
}

- (void)share:(id)sender
{
    NSLog(@"点击了分享");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"分享到部落",@"分享到广场",@"分享到微信好友",@"分享到微信朋友圈", nil];
    [alert show];
}

#pragma mark - share to weixin
- (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [self.activityDict objectForKey:@"actname"];
    message.description = [self.activityDict objectForKey:@"desc"];
    [message setThumbImage:[UIImage imageNamed:@"icon"]];

//    NSString *imagesStr = [self.activityDict objectForKey:@"actimgs"];
//    NSArray *images = [imagesStr componentsSeparatedByString:@","];
//    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:IMGURL([images lastObject])]]];

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = INF_SHARE_URL(self.activityId);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

//是否报名
- (BOOL)isInFollowers{//joins
    NSArray *followers = [self.activityDict objectForKey:@"joins"];
    BOOL isIn = NO;
    for (int i = 0; i < [followers count]; i ++) {
        NSDictionary *follower = [followers objectAtIndex:i];
        NSInteger followerId = [[follower objectForKey:@"userid"] integerValue];
        NSInteger userId = [[defaults objectForKey:@"userid"] integerValue];
        if (followerId == userId) {
            isIn= YES;
            break;
        }
    }
    return isIn;
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
    
    ShareView *share = [[ShareView alloc] initWithParam:self.activityDict];
    share.alpha = 0.0;
    [share addSubview:view];
    [share sendSubviewToBack:view];
    [self.view addSubview:share];
    
    share.shareBlack = ^(id objct){
        NSLog(@"block");
//        [self showAlert:@"分享成功"];
        /**
         *  转发通用接口(转发指将咨询文章，活动转发到广场的操作)
         *
         *  @param type     2为咨询转发，3为活动转发
         *  @param targetid 要转发的目标id
         *  @param refsign  转发语
         *  @param callback 回调
         */

        NSString *refsign = (NSString *)objct;
        [DataInterface transmit:@"3"
                       targetid:self.activityId
                        refsign:refsign
          withCompletionHandler:^(NSMutableDictionary *dict){
              NSLog(@"分享到广场返回信息：%@",dict);
              [self showAlert:[dict objectForKey:@"info"]];

        }];
    };
    [share show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.firstOtherButtonIndex == buttonIndex) {//分享到部落
        NSLog(@"分享到部落");
        ShareToTribeViewController *shareToTribe = [[ShareToTribeViewController alloc] init];
        shareToTribe.shareToTribeBlock = ^(NSDictionary *paramDict){
            NSLog(@"分享不落信息：%@",paramDict);
            /**
             *  分享内容
             *  @param artid       广场消息的唯一标示
             *  @param contenttype 1为广场文章，2为咨询分享，3为活动分享
             *  @param sharetype   1为分享给好友，2为分享给部落
             *  @param targetid    分享给好友或部落的id，如果为多个好友或部落，中间以逗号隔开
             *  @param callback 回调
             */
            if (paramDict) {
                [DataInterface shareContent:self.activityId
                                 sourcetype:@"3"
                                  sharetype:@"2"
                                   targetid:[paramDict objectForKey:@"tribeid"]
                      withCompletionHandler:^(NSMutableDictionary *dict){
                          NSLog(@"分享到部落返回信息%@",dict);
                          [self showAlert:[dict objectForKey:@"info"]];
                          
                      }];
            }
        };
        [self.navigationController pushViewController:shareToTribe animated:YES];
    }else if (2 == buttonIndex){//分享到广场
        NSLog(@"分享到广场");
        [self shareToSquare];
    }else if (3 == buttonIndex){//分享到微信好友
        NSLog(@"分享到微信好友");
        _scene = WXSceneSession;
        [self sendLinkContent];
    }else if(4 == buttonIndex){//分享到微信朋友圈
        NSLog(@"分享到微信朋友圈");
        _scene = WXSceneTimeline;
        [self sendLinkContent];
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

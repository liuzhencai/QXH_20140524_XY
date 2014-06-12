//
//  InformationDetailController.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "InformationDetailController.h"
#import "InformationCommentController.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface InformationDetailController ()
{
    InfoDetailModel *detailmodel;
}
@end

@implementation InformationDetailController

- (void)setValueForView
{
    _articleTitleLabel.text = detailmodel.title;
    _sourceLabel.text = detailmodel.authflag;
    _authLabel.text = detailmodel.author;
    _readNumLabel.text = detailmodel.browsetime;
    _commentNumLabel.text = detailmodel.commenttime;
    _postLabel.text = detailmodel.relaytime;
    _dateLabel.text = detailmodel.date;
}

- (void)getDetailInfo
{
    [DataInterface getDetailInfo:@"2" artid:_artid withCompletionHandler:^(NSMutableDictionary *dict) {
        detailmodel = [ModelGenerator json2InfoDetail:dict];
        [self setValueForView];
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
    // Do any additional setup after loading the view from its nib.
    self.title = @"智谷";
    
    [self getDetailInfo];
  
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,74, 31);
    [righttbuttonItem setTitle:@"分享" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    _toolbarView.frame = CGRectMake(0, SCREEN_H - 49 - 64, 320, 49);
    [self.view addSubview:_toolbarView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%d",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            // 分享至广场
            NSString *targetid = @"123123"; // 好友id
            [DataInterface shareContent:self.artid contenttype:@"2" sharetype:@"1" targetid:targetid withCompletionHandler:^(NSMutableDictionary *dict) {
                
            }];
        }
            break;
        case 1:
        {
            // 分享至部落
            NSString *targetid = @"123123"; // 部落id
            [DataInterface shareContent:self.artid contenttype:@"2" sharetype:@"2" targetid:targetid withCompletionHandler:^(NSMutableDictionary *dict) {
                
            }];
        }
            break;
        case 2:
        {
            // 分享至微信
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = @"专访张小龙：产品之上的世界观";
            message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
            [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
            
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
//            req.scene = _scene;
            
            [WXApi sendReq:req];
        }
            break;
        default:
            break;
    }
}

- (void)share:(id)sender
{
    NSLog(@"分享");

//    [self showAlert:@"分享"];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分 享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享至广场",@"分享至部落",@"分享至微信", nil];
    [sheet showInView:self.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击收藏");

            [self showAlert:@"点击收藏"];

        }
            break;
        case 2:
        {
            NSLog(@"点击赞");

            [self showAlert:@"点击赞"];

        }
            break;
        case 3:
        {
            NSLog(@"点击转发");

            [self showAlert:@"点击转发"];

        }
            break;
        case 4:
        {
            NSLog(@"点击评论");
            InformationCommentController *controller = [[InformationCommentController alloc]initWithNibName:@"InformationCommentController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:
        {
            NSLog(@"点击举报");

            [self showAlert:@"点击举报"];

        }
            break;
        default:
            break;
    }
}

- (IBAction)showAll:(id)sender {
    NSLog(@"查看全部");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == InfomationTypeNormal) {
        return 2;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    if (self.type == InfomationTypeNormal) {
        switch (indexPath.row) {
            case 0:
            {
                rowHeight = 195.f;
            }
                break;
            case 1:
            {
                rowHeight = 44.f;
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                rowHeight = 90;
            }
                break;
            case 1:
            {
                rowHeight = 195;
            }
                break;
            case 2:
            {
                rowHeight = 44;
            }
                break;
            default:
                break;
        }
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.type == InfomationTypeNormal) {
        switch (indexPath.row) {
            case 0:
            {
                static NSString *cellIdentifier = @"detailCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [cell.contentView addSubview:_informationDetailView];
                }
            }
                break;
            case 1:
            {
                static NSString *cellIdentifier = @"descCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.textLabel.text = @"资讯内容";
                }
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                static NSString *cellIdentifier = @"recommendCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [cell.contentView addSubview:_recommendView];
                }
            }
                break;
            case 1:
            {
                static NSString *cellIdentifier = @"detailCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [cell.contentView addSubview:_informationDetailView];
                }
            }
                break;
            case 2:
            {
                static NSString *cellIdentifier = @"descCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.textLabel.text = @"资讯内容";
                }
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)requestInfoDetail
{
    
}

@end

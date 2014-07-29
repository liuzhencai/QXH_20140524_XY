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
#import "SelectTribeController.h"
#import "GCPlaceholderTextView.h"

@interface InformationDetailController ()
{
    InfoDetailModel *detailmodel;
    enum WXScene _scene;
}

@end

@implementation InformationDetailController

- (void)setValueForView
{
    _articleTitleLabel.text = detailmodel.title;
    _readNumLabel.text = detailmodel.browsetime;
    _commentNumLabel.text = detailmodel.commenttime;
    _postLabel.text = detailmodel.sharetime;
    _dateLabel.text = detailmodel.date;
    _praiseLabel.text = [NSString stringWithFormat:@"%d",detailmodel.laud];
    
    [_infoDetailWeb loadRequest:[NSURLRequest requestWithURL:INFURL(self.artid) cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f]];
    // 加载webview数据
//    [_infoDetailWeb loadHTMLString:detailmodel.content baseURL:[NSURL URLWithString:@"http://180.97.46.40:8070"]];
}

- (void)getDetailInfo
{
    [DataInterface getDetailInfo:@"2" artid:_artid withCompletionHandler:^(NSMutableDictionary *dict) {
        detailmodel = nil;
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
    NSLog(@"clickbtn--->%d",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            SelectTribeController *controller = [[SelectTribeController alloc] initWithNibName:@"SelectTribeController" bundle:nil];
            controller.type = SelectTypeInfTrans;
            controller.parentController = self;
            controller.callback = ^(MyTribeModel *model){
                [DataInterface shareContent:self.artid sourcetype:@"2" sharetype:@"2" targetid:model.tribeid withCompletionHandler:^(NSMutableDictionary *dict) {
                    [self showAlert:[dict objectForKey:@"info"]];
                }];
            };
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            // 微信
            _scene = WXSceneSession;
        }
            break;
        case 2:
        {
            // 朋友圈
            _scene = WXSceneTimeline;
        }
            break;
        default:
            break;
    }
    [self sendLinkContent];
}

- (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = detailmodel.title;
    message.description = detailmodel.title;
//    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:IMGURL(detailmodel.sphoto)]]];
    [message setThumbImage:[UIImage imageNamed:@"img_news"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = INF_SHARE_URL(self.artid);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)share:(id)sender
{
    NSLog(@"微信分享");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分 享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"部落", @"微信朋友", @"微信朋友圈", nil];
    [actionSheet showInView:self.view];
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
            btn.selected = !btn.selected;
            NSString *collected = nil;
            if (btn.selected) {
                collected = @"1";
            }else{
                collected = @"2";
            }
            [DataInterface squareArticleCollection:collected artid:self.artid withCompletionHandler:^(NSMutableDictionary *dict) {
                [self showAlert:[dict objectForKey:@"info"]];
            }];

        }
            break;
        case 2:
        {
            [DataInterface praiseArticle:self.artid laud:@"1" comment:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
                [self showAlert:[dict objectForKey:@"info"]];
                [self getDetailInfo];
            }];
        }
            break;
        case 3:
        {
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc]init];
            [alertView setUseMotionEffects:TRUE];
            [alertView setButtonTitles:@[@"取消", @"转发"]];
            GCPlaceholderTextView *commentView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, 260, 60)];
            commentView.placeholder = @"请在此输入评论";
            commentView.backgroundColor = [UIColor clearColor];
            [alertView setContainerView:commentView];
            [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
                switch (buttonIndex) {
                    case 1:
                    {
                        [DataInterface transmit:@"2" targetid:self.artid refsign:commentView.text withCompletionHandler:^(NSMutableDictionary *dict) {
                            [self showAlert:[dict objectForKey:@"info"]];
                            [alertView close];
                        }];
                    }
                        break;
                    default:
                        break;
                }
            }];
            [alertView show];
        }
            break;
        case 4:
        {
            NSLog(@"点击评论");
            InformationCommentController *controller = [[InformationCommentController alloc]initWithNibName:@"InformationCommentController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.artid = self.artid;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [DataInterface transmit:@"2" targetid:self.artid refsign:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
            [self showAlert:[dict objectForKey:@"info"]];
        }];
    };
}

- (IBAction)showAll:(id)sender {
    NSLog(@"查看全部");
}

@end

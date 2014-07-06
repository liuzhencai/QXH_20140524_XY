//
//  InformationDetailController.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "InformationDetailController.h"
#import "InformationCommentController.h"

@interface InformationDetailController ()
{
    InfoDetailModel *detailmodel;
}
@end

@implementation InformationDetailController

- (void)setValueForView
{
    _articleTitleLabel.text = detailmodel.title;
    _readNumLabel.text = detailmodel.browsetime;
    _commentNumLabel.text = detailmodel.commenttime;
    _postLabel.text = detailmodel.relaytime;
    _dateLabel.text = detailmodel.date;
    _praiseLabel.text = [NSString stringWithFormat:@"%d",detailmodel.laud];
    
    [_infoDetailWeb loadRequest:[NSURLRequest requestWithURL:INFURL(self.artid) cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f]];
    // 加载webview数据
//    [_infoDetailWeb loadHTMLString:detailmodel.content baseURL:[NSURL URLWithString:@"http://180.97.46.40:8070"]];
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

- (void)share:(id)sender
{
    NSLog(@"微信分享");
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
            }];
        }
            break;
        case 3:
        {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"转发到广场" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alerView show];
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

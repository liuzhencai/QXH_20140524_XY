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
        [_infoDetailTbl reloadData];
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
    
    if (IOS7_OR_LATER) {
        [_infoDetailTbl setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    }
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonINdex:%d",buttonIndex);
    switch (buttonIndex) {
        case 1:
        {
            /*
            [DataInterface shareContent:self.artid contenttype:@"2" sharetype:@"2" targetid:<#(NSString *)#> withCompletionHandler:^(NSMutableDictionary *dict) {
                <#code#>
            }]
             */
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)share:(id)sender
{
    NSLog(@"分享");

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"分享到部落",@"分享到广场",@"分享到微信", nil];
    [alert show];
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
            controller.artid = self.artid;
            [self.navigationController pushViewController:controller animated:YES];
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
                rowHeight = 110.f;
            }
                break;
            case 1:
            {
                rowHeight = [NSString getStringRect:detailmodel.content].height;
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
                rowHeight = 110.f;
            }
                break;
            case 2:
            {
                rowHeight = [NSString getStringRect:detailmodel.content].height;
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
                    UILabel *label = [[UILabel alloc]init];
                    label.numberOfLines = 0;
                    label.font = [UIFont systemFontOfSize:13.f];
                    label.tag = 101;
                    [cell.contentView addSubview:label];
                }
                UILabel *label_ = (UILabel *)[cell.contentView viewWithTag:101];
                label_.text = detailmodel.content;
                CGSize size = [label_ boundingRectWithSize:CGSizeMake(300, FLT_MAX)];
                label_.frame = CGRectMake(10, 0, size.width, size.height);
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
                    UILabel *label = [[UILabel alloc]init];
                    label.numberOfLines = 0;
                    label.font = [UIFont systemFontOfSize:13.f];
                    label.tag = 201;
                    [cell.contentView addSubview:label];
                }
                UILabel *label_ = (UILabel *)[cell.contentView viewWithTag:201];
                label_.text = detailmodel.content;
                CGSize size = [label_ boundingRectWithSize:CGSizeMake(300, FLT_MAX)];
                label_.frame = CGRectMake(10, 0, size.width, size.height);
            }
                break;
            default:
                break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

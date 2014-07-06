//
//  ShareTextController.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "ShareTextController.h"
#import "CommentCell.h"
#import "SquareCell.h"
#import "InfoModel.h"
#import "InformationCommentCell.h"
#import "NameCardViewController.h"
#import "InformationDetailController.h"

@interface ShareTextController ()

@end

@implementation ShareTextController

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
    
    self.title = @"详情";

    _contentTable.frame = CGRectMake(0, 0, 320, SCREEN_H-49);
    _toolbarView.frame = CGRectMake(0, SCREEN_H - 49-64, 320, 49);
    [self.view addSubview:_toolbarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    switch (indexPath.section) {
        case 0:
            rowHeight = 68.f;
            break;
        case 1:
        {
            InfoModel *tmpModel = (InfoModel *)_info.content;
            CGSize textSize = [NSString getStringRect:tmpModel.content font:[UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT] labelSize:CGSizeMake(SQUARE_DETAIL_CONTENT_WIDTH, FLT_MAX)];
            if (![tmpModel.artimgs isEqualToString:@""]) {
                rowHeight = textSize.height + SQUARE_DETAIL_PIC_SIZE + 30;
            }else{
                rowHeight = textSize.height + 20;
            }
        }
            break;
        case 2:
            rowHeight = 44.f;
            break;
        case 3:
            rowHeight = 68.f;
            break;
        default:
            break;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell *cell = nil;
    InfoModel *tmpModel = (InfoModel *)_info.content;
    switch (self.type) {
            /**
             *  广场文章
             */
        case 1:
        {
            switch (section) {
                case 0:
                {
                    static NSString *headCell = @"HeadCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:headCell];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headCell];
                        // 添加用户信息
                        UIImageView *portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
                        portraitView.tag = 101;
                        [portraitView circular];
                        [cell.contentView addSubview:portraitView];
                        
                        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 21)];
                        nameLabel.tag = 102;
                        nameLabel.text = tmpModel.sname;
                        [cell.contentView addSubview:nameLabel];
                    }
                    UIImageView *portraitView_ = (UIImageView *)[cell.contentView viewWithTag:101];
                    [portraitView_ setImageWithURL:IMGURL(_info.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
                }
                    break;
                case 1:
                {
                    static NSString *contentCell = @"ContentCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:contentCell];
                    if (cell==nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCell];
                        UILabel *contentLabel = [[UILabel alloc] init];
                        contentLabel.numberOfLines = 0;
                        contentLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        contentLabel.text = tmpModel.content;
                        CGSize textSize = [contentLabel boundingRectWithSize:CGSizeMake(SQUARE_DETAIL_CONTENT_WIDTH, FLT_MAX)];
                        contentLabel.frame = CGRectMake(10, 10, SQUARE_DETAIL_CONTENT_WIDTH, textSize.height);
                        [cell.contentView addSubview:contentLabel];
                        
                        /**
                         *  添加图片
                         */
                        
                        if (![tmpModel.artimgs isEqualToString:@""]) {
                            if ([tmpModel.artimgs rangeOfString:@","].location != NSNotFound) {
                                NSArray *imgs = [tmpModel.artimgs componentsSeparatedByString:@","];
                                for (int i = 0; i < [imgs count]; i++) {
                                    @autoreleasepool {
                                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(SQUARE_DETAIL_PIC_SIZE+10)*i, textSize.height+20, SQUARE_DETAIL_PIC_SIZE, SQUARE_DETAIL_PIC_SIZE)];
                                        [imageView setImageWithURL:IMGURL(imgs[i])];
                                        [cell.contentView addSubview:imageView];
                                    }
                                }
                            }else{
                                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, textSize.height+20, SQUARE_DETAIL_PIC_SIZE, SQUARE_DETAIL_PIC_SIZE)];
                                [imageView setImageWithURL:IMGURL(tmpModel.artimgs)];
                                [cell.contentView addSubview:imageView];
                            }
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
                    break;
                case 2:
                {
                    static NSString *commentCell = @"CommentCell";
                    // 添加阅读评论赞等信息
                    cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCell];
                        // 添加用户信息
                        UILabel *readLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 21)];
                        readLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        readLabel.tag = 121;
                        [cell.contentView addSubview:readLabel];
                        
                        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 80, 21)];
                        commentLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        commentLabel.tag = 122;
                        [cell.contentView addSubview:commentLabel];
                        
                        UILabel *praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 80, 21)];
                        praiseLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        praiseLabel.tag = 123;
                        [cell.contentView addSubview:praiseLabel];
                        
                        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 80, 21)];
                        timeLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        timeLabel.tag = 124;
                        [cell.contentView addSubview:timeLabel];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    UILabel *readLabel_ = (UILabel *)[cell.contentView viewWithTag:121];
                    readLabel_.text = @"阅读：10";
                    UILabel *commentLabel_ = (UILabel *)[cell.contentView viewWithTag:122];
                    commentLabel_.text = @"评论：20";
                    UILabel *praiseLabel_ = (UILabel *)[cell.contentView viewWithTag:123];
                    praiseLabel_.text = @"赞：30";
                    UILabel *timeLabel_ = (UILabel *)[cell.contentView viewWithTag:124];
                    timeLabel_.text = @"2014-06-21";
                }
                    break;
                case 3:
                {
                    // 添加评论列表
                    static NSString *cellIdentifier = @"informationComment";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCommentCell" owner:nil options:nil] objectAtIndex:0];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
//                    [(InformationCommentCell *)cell setModel:[commentList objectAtIndex:indexPath.row]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            /**
             *  转发到广场的咨询
             */
        case 2:
        {
            switch (section) {
                case 0:
                {
                    static NSString *headCell = @"HeadCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:headCell];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headCell];
                        // 添加用户信息
                        UIImageView *portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
                        portraitView.tag = 101;
                        [portraitView setImageWithURL:IMGURL(_info.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
                        [portraitView circular];
                        [cell.contentView addSubview:portraitView];
                        
                        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 21)];
                        nameLabel.tag = 102;
                        nameLabel.text = _info.uname;
                        [cell.contentView addSubview:nameLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
                    break;
                case 1:
                {
                    static NSString *contentCell = @"ContentCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:contentCell];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCell];
                        
                        CGSize textSize = CGSizeZero;
                        if (![_info.uduty isEqualToString:@""]) {
                            UILabel *contentLabel = [[UILabel alloc] init];
                            contentLabel.numberOfLines = 0;
                            contentLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                            contentLabel.text = _info.refsign;
                            textSize = [contentLabel boundingRectWithSize:CGSizeMake(SQUARE_DETAIL_CONTENT_WIDTH, FLT_MAX)];
                            contentLabel.frame = CGRectMake(10, 10, SQUARE_DETAIL_CONTENT_WIDTH, textSize.height);
                            [cell.contentView addSubview:contentLabel];
                        }
                        
                        /**
                         *  添加咨询信息
                         */
                        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, textSize.height+20, 300, SQUARE_DETAIL_PICINF_SIZE + 20)];
                        bgView.backgroundColor = [UIColor lightGrayColor];
                        bgView.highlighted = NO;
                        
                        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SQUARE_DETAIL_PICINF_SIZE, SQUARE_DETAIL_PICINF_SIZE)];
                        [imgView setImageWithURL:IMGURL(tmpModel.artimgs)];
                        [bgView addSubview:imgView];
                        
                        UILabel *subContentLabel = [[UILabel alloc] init];
                        subContentLabel.numberOfLines = 0;
                        subContentLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        subContentLabel.text = tmpModel.title;
                        subContentLabel.lineBreakMode = kTextLineBreakByTruncatingTail;
                        subContentLabel.frame = CGRectMake(20+SQUARE_DETAIL_PICINF_SIZE, 10, 200, SQUARE_DETAIL_PICINF_SIZE);
                        [bgView addSubview:subContentLabel];
                        
                        [cell.contentView addSubview:bgView];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
                    break;
                case 2:
                {
                    static NSString *commentCell = @"CommentCell";
                    // 添加阅读评论赞等信息
                    cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCell];
                        // 添加用户信息
                        UILabel *readLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 21)];
                        readLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        readLabel.tag = 121;
                        [cell.contentView addSubview:readLabel];
                        
                        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 80, 21)];
                        commentLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        commentLabel.tag = 122;
                        [cell.contentView addSubview:commentLabel];
                        
                        UILabel *praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 80, 21)];
                        praiseLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        praiseLabel.tag = 123;
                        [cell.contentView addSubview:praiseLabel];
                        
                        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 80, 21)];
                        timeLabel.font = [UIFont systemFontOfSize:SQUARE_DETAIL_CONTENT_FONT];
                        timeLabel.tag = 124;
                        [cell.contentView addSubview:timeLabel];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    UILabel *readLabel_ = (UILabel *)[cell.contentView viewWithTag:121];
                    readLabel_.text = @"阅读：10";
                    UILabel *commentLabel_ = (UILabel *)[cell.contentView viewWithTag:122];
                    commentLabel_.text = @"评论：20";
                    UILabel *praiseLabel_ = (UILabel *)[cell.contentView viewWithTag:123];
                    praiseLabel_.text = @"赞：30";
                    UILabel *timeLabel_ = (UILabel *)[cell.contentView viewWithTag:124];
                    timeLabel_.text = @"2014-06-21";
                }
                    break;
                case 3:
                {
                    // 添加评论列表
                    static NSString *cellIdentifier = @"informationComment";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCommentCell" owner:nil options:nil] objectAtIndex:0];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    //                    [(InformationCommentCell *)cell setModel:[commentList objectAtIndex:indexPath.row]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoModel *tmpModel = (InfoModel *)_info.content;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            NameCardViewController *controller = [[NameCardViewController alloc]init];
            NSDictionary *item = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:_info.uid] forKey:@"userid"];
            controller.memberDict = item;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            if (self.type == SquareInfoTypeInf) {
                InformationDetailController *controller = [[InformationDetailController alloc] initWithNibName:@"InformationDetailController" bundle:nil];
                InfoModel *tmpModel = (InfoModel *)_info.content;
                controller.artid = tmpModel.artid;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
 
- (IBAction)click:(id)sender {
    UIButton *btn = (UIButton *)sender;
    InfoModel *tmpModel = (InfoModel *)_info.content;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击了收藏");
            btn.selected = !btn.selected;
            NSString *collected = nil;
            if (btn.selected) {
                collected = @"1";
            }else{
                collected = @"2";
            }
            [DataInterface squareArticleCollection:collected artid:tmpModel.artid withCompletionHandler:^(NSMutableDictionary *dict) {
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
            break;
        case 2:
        {
            NSLog(@"点击了赞");
            [DataInterface praiseArticle:tmpModel.artid laud:@"1" comment:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
            break;
        case 3:
        {
            NSLog(@"点击了评论");
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc]init];
            [alertView setUseMotionEffects:TRUE];
            [alertView setButtonTitles:@[@"取消", @"发表"]];
            UITextView *commentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 60)];
            commentView.backgroundColor = [UIColor clearColor];
            [alertView setContainerView:commentView];
            [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
                switch (buttonIndex) {
                    case 1:
                    {
                        [DataInterface praiseArticle:tmpModel.artid laud:@"0" comment:commentView.text withCompletionHandler:^(NSMutableDictionary *dict) {
                            /**
                             *  刷新评论列表
                             */
                            [self showAlert:[dict objectForKey:@"info"]];
                            [alertView close];
                        }];
                    }
                    default:
                        break;
                }
            }];
            [alertView show];
        }
            break;
        case 4:
        {
            NSLog(@"点击了举报");
            [DataInterface reportInfoType:@"3" targetid:tmpModel.artid content:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
            break;
        default:
            break;
    }
}


@end

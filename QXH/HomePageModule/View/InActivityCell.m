//
//  InActivityCell.m
//  QXH
//
//  Created by xuey on 14-5-28.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "InActivityCell.h"


@implementation InActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgImgView = [self addImageViewWithFrame:CGRectMake(10, 10, 300, 210 - 20)
                                                   imageName:[UIImage imageNamed:@"label"]];
        [self.contentView addSubview:bgImgView];
        
        UIImageView *titleBgImgView = [self addImageViewWithFrame:CGRectMake(1, 1, bgImgView.width - 2, 30)
                                                   imageName:[UIImage imageNamed:@"title_bar_bg"]];
        self.titleBgImgView = titleBgImgView;
        [bgImgView addSubview:titleBgImgView];
        
        UIImageView *typeBgImgView = [self addImageViewWithFrame:CGRectMake(230, 5, 60, 20)
                                                        imageName:[UIImage imageNamed:@"img_bg_type"]];
        self.typeBgImgView = typeBgImgView;
        [bgImgView addSubview:typeBgImgView];
        //title
        _activityTitleLabel = [self addLabelWithFrame:CGRectMake(10, 0, 200, 30)
                                                 text:@"活动标题活动标题活动标题活动xxx"
                                                color:GREEN_FONT_COLOR
                                                 font:[UIFont systemFontOfSize:16]];
        _activityTitleLabel.numberOfLines = 0;
        
        [bgImgView addSubview:_activityTitleLabel];
        
        //type
        _activityTypeLabel = [self addLabelWithFrame:typeBgImgView.frame
                                                 text:@"活动类型"
                                                color:[UIColor blackColor]
                                                 font:[UIFont systemFontOfSize:14]];
        _activityTypeLabel.textAlignment = NSTextAlignmentCenter;
        _activityTypeLabel.textColor = [UIColor whiteColor];
        [bgImgView addSubview:_activityTypeLabel];
        
        //desc
//        _activityDescriptionLabel = [self addLabelWithFrame:CGRectMake(10, titleBgImgView.bottom + 10, 280, 40)
//                                                 text:@"活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述"
//                                                color:[UIColor blackColor]
//                                                 font:[UIFont systemFontOfSize:16]];
        _activityDescriptionLabel = [self addLabelWithFrame:CGRectMake(10, titleBgImgView.bottom + 0, 280, 0)
                                                       text:@"活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述"
                                                      color:[UIColor blackColor]
                                                       font:[UIFont systemFontOfSize:16]];
        _activityDescriptionLabel.numberOfLines = 0;
        [bgImgView addSubview:_activityDescriptionLabel];
        
        //image
        _activityImage = [self addImageViewWithFrame:CGRectMake(210 - 35, _activityDescriptionLabel.bottom + 5, 112, 84)
                                                       imageName:[UIImage imageNamed:@"img_news"]];
        [bgImgView addSubview:_activityImage];
        
//        NSArray *items = @[@"来   自:",@"发起人:",@"时   间:",@"地   点:"];
        NSArray *items = @[@"来自:",@"发起人:",@"时间:",@"地点:"];
        for (int i = 0; i < [items count]; i ++) {
            
            UILabel *itemTitle = [self addLabelWithFrame:CGRectMake(22, _activityDescriptionLabel.bottom + 5 + i * 30, 32, 30)
                                                     text:[items objectAtIndex:i]
                                                    color:[UIColor blackColor]
                                                     font:[UIFont systemFontOfSize:12]];
            [bgImgView addSubview:itemTitle];
            
            UILabel *itemValue = [self addLabelWithFrame:CGRectMake(itemTitle.right, itemTitle.top, 100 + 18, 30)
                                                    text:@""
                                                   color:[UIColor blackColor]
                                                    font:[UIFont systemFontOfSize:12]];
            [bgImgView addSubview:itemValue];
            
            NSString *imageName = nil;
            switch (i) {
                case 0:{//来自
                    imageName = @"icon_comefrom";
                    self.tribeLabel = itemValue;
                    self.tribeLabel.text = @"XXXX部落";
                }
                    break;
                case 1:{//发起人
                    imageName = @"icon_zhujiangren";
                    itemTitle.frame = CGRectMake(itemTitle.left, itemTitle.top, itemTitle.width + 8, itemTitle.height);
                    itemValue.frame = CGRectMake(itemTitle.right, itemValue.top, itemValue.width - 8, itemValue.height);
                    self.orgnizerLabel = itemValue;
                    self.orgnizerLabel.text = @"苍井空";
                }
                    break;
                case 2:{//时间
                    imageName = @"icon_time";
                    self.timeLabel = itemValue;
//                    itemValue.font = [UIFont systemFontOfSize:10];
                    self.timeLabel.text = @"2014-05-25";
                }
                    break;
                case 3:{//地点
                    imageName = @"icon_place";
                    self.addrLabel = itemValue;
                    self.addrLabel.text = @"中关村";
                    itemValue.frame = CGRectMake(itemValue.left, itemValue.top, itemValue.width + 120, itemValue.height);
                }
                    break;
                    
                default:
                    break;
            }
            
            UIImageView *iconImgView = [self addImageViewWithFrame:CGRectMake(5, itemTitle.top + 8, 13, 13)
                                                         imageName:[UIImage imageNamed:imageName]];
            [bgImgView addSubview:iconImgView];
        }
        
        //sign up
        _signUpLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(10, 185 - 20, 60, 15)];
        _signUpLabel.font = [UIFont systemFontOfSize:12];
        _signUpLabel.textAlignment = NSTextAlignmentCenter;
        _signUpLabel.backgroundColor = [UIColor clearColor];
        [bgImgView addSubview:_signUpLabel];
        
        
        //line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_signUpLabel.right, _signUpLabel.top, 1, _signUpLabel.height)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [bgImgView addSubview:lineView];
        
        //follow
        _followLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(_signUpLabel.right + 1, _signUpLabel.top, 60, 15)];
        _followLabel.backgroundColor = [UIColor clearColor];
        _followLabel.font = [UIFont systemFontOfSize:12];
        _followLabel.textAlignment = NSTextAlignmentCenter;
        [bgImgView addSubview:_followLabel];
        
        
        //status image
        _activityStatus = [self addImageViewWithFrame:CGRectMake(224, 178, 75, 21)
                                                     imageName:[UIImage imageNamed:@""]];
        _activityStatus.backgroundColor = COLOR_WITH_ARGB(16, 120, 45, 1.0);
        _activityStatus.hidden = YES;
        [bgImgView addSubview:_activityStatus];
        
        //stauts label
        _statusLabel = [self addLabelWithFrame:_activityStatus.frame
                                                 text:@"进行中"
                                                color:[UIColor whiteColor]
                                                 font:[UIFont systemFontOfSize:12]];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.hidden = YES;
        [bgImgView addSubview:_statusLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellParamDict:(id)objt{
    NSDictionary *params = (NSDictionary *)objt;
    if (params) {
        NSMutableString *titleString = [NSMutableString stringWithFormat:@"%@",[params objectForKey:@"actname"]];

        if ([titleString length] > 12) {
            CGFloat height = 40;
            CGRect titleframe = self.activityTitleLabel.frame;
            titleframe.size.height = height;
            self.activityTitleLabel.frame = titleframe;
            [titleString insertString:@"\n" atIndex:12];
            
            CGRect titleBGframe = self.titleBgImgView.frame;
            titleBGframe.size.height = 40;
            self.titleBgImgView.frame = titleBGframe;
            
            CGRect imageframe = self.activityImage.frame;
            imageframe.origin.y = 43;
            self.activityImage.frame = imageframe;
            
            CGRect typeFrame = self.typeBgImgView.frame;
            typeFrame.origin.y = 10;
            self.typeBgImgView.frame = typeFrame;
            self.activityTypeLabel.frame = typeFrame;
        }
        self.activityTitleLabel.text = titleString;

        self.activityTypeLabel.text = [params objectForKey:@"acttype"];
        self.activityDescriptionLabel.text = [params objectForKey:@"desc"];
        NSString *imageUrlStr = [params objectForKey:@"photos"];
        [self.activityImage setImageWithURL:IMGURL(imageUrlStr) placeholderImage:[UIImage imageNamed:@"img_news"]];
        self.tribeLabel.text = [params objectForKey:@""];
        self.orgnizerLabel.text = [params objectForKey:@""];
        self.timeLabel.text = [params objectForKey:@"begindate"];
        self.addrLabel.text = [params objectForKey:@"actaddr"];
        
        
        //218 134 74
        NSString *nowCount = [NSString stringWithFormat:@"%d",[[params objectForKey:@"nowcount"] intValue]];
        NSString *signUpString = [NSString stringWithFormat:@"%@人报名",nowCount];
        self.signUpLabel.text = signUpString;
        [self.signUpLabel setTextColor:COLOR_WITH_ARGB(218, 134, 74, 1.0) range:[signUpString rangeOfString:nowCount]];

        NSString *folcount = [NSString stringWithFormat:@"%d",[[params objectForKey:@"folcount"] intValue]];
        NSString *followString = [NSString stringWithFormat:@"%@人关注",folcount];
        self.followLabel.text = followString;
        [self.followLabel setTextColor:COLOR_WITH_ARGB(218, 134, 74, 1.0) range:[followString rangeOfString:folcount]];
        
        self.activityStatus.image = [UIImage imageNamed:@""];
        self.statusLabel.text = @"进行中";
    }
}

@end

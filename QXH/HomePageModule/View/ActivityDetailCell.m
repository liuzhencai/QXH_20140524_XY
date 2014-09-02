//
//  ActivityDetailCell.m
//  QXH
//
//  Created by XueYong on 6/10/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "ActivityDetailCell.h"
#import "UIImageView+WebCache.h"


@implementation ActivityDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgImgView = [self addImageViewWithFrame:CGRectMake(10, 10, 300, 230 + 60)
                                                   imageName:[UIImage imageNamed:@"label"]];
        [self.contentView addSubview:bgImgView];
        
        _titleBgImgView = [self addImageViewWithFrame:CGRectMake(1, 1, bgImgView.width - 2, 30)
                                                        imageName:[UIImage imageNamed:@"title_bar_bg"]];
        [bgImgView addSubview:_titleBgImgView];
        
        _typeBgImgView = [self addImageViewWithFrame:CGRectMake(230, 5, 60, 20)
                                                       imageName:[UIImage imageNamed:@"img_bg_type"]];
        [bgImgView addSubview:_typeBgImgView];
        //title活动标题
        _activityTitleLabel = [self addLabelWithFrame:CGRectMake(10, 0, 200, 30)
                                                 text:@""
                                                color:GREEN_FONT_COLOR
                                                 font:[UIFont systemFontOfSize:16]];
        _activityTitleLabel.numberOfLines = 0;
        [bgImgView addSubview:_activityTitleLabel];
        
        //type活动类型
        _activityTypeLabel = [self addLabelWithFrame:_typeBgImgView.frame
                                                text:@""
                                               color:[UIColor whiteColor]
                                                font:[UIFont systemFontOfSize:14]];
        _activityTypeLabel.textAlignment = NSTextAlignmentCenter;
        [bgImgView addSubview:_activityTypeLabel];
        
        //desc
//        _activityDescriptionLabel = [self addLabelWithFrame:CGRectMake(10, titleBgImgView.bottom + 10, 280, 40)
//                                                       text:@"活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述"
//                                                      color:[UIColor blackColor]
//                                                       font:[UIFont systemFontOfSize:16]];
        _activityDescriptionLabel = [self addLabelWithFrame:CGRectMake(10, _titleBgImgView.bottom + 0, 280, 0)
                                                       text:@""
                                                      color:[UIColor blackColor]
                                                       font:[UIFont systemFontOfSize:16]];
        _activityDescriptionLabel.numberOfLines = 0;
        [bgImgView addSubview:_activityDescriptionLabel];
        
        //image
        _activityImage = [self addImageViewWithFrame:CGRectMake(210 - 35, _activityDescriptionLabel.bottom + 5, 112, 84)
                                           imageName:[UIImage imageNamed:@"img_news"]];
        [bgImgView addSubview:_activityImage];
        
        NSArray *items = @[@"来自:",@"发起人:",@"活动开始时间:",@"活动结束时间:",@"报名截止时间:",@"地点:"];
        for (int i = 0; i < [items count]; i ++) {
            UILabel *itemTitle = [self addLabelWithFrame:CGRectMake(22, _activityDescriptionLabel.bottom + 5 + i * 40, 32 + 10, 40)
                                                    text:[items objectAtIndex:i]
                                                   color:[UIColor blackColor]
                                                    font:[UIFont systemFontOfSize:14]];
            [bgImgView addSubview:itemTitle];
            
            UILabel *itemValue = [self addLabelWithFrame:CGRectMake(itemTitle.right, itemTitle.top, 100 + 18 - 10, 40)
                                                    text:@""
                                                   color:[UIColor blackColor]
                                                    font:[UIFont systemFontOfSize:14]];
            [bgImgView addSubview:itemValue];
            
            NSString *imageName = nil;
            switch (i) {
                case 0:{//来自
                    imageName = @"icon_comefrom";
                    self.tribeLabel = itemValue;
                    self.tribeLabel.text = @"";
                }
                    break;
                case 1:{//发起人
                    imageName = @"icon_zhujiangren";
                    self.orgnizerLabel = itemValue;
                    self.orgnizerLabel.text = @"";
                    itemTitle.frame = CGRectMake(itemTitle.left, itemTitle.top, itemTitle.width + 8, itemTitle.height);
                    itemValue.frame = CGRectMake(itemTitle.right, itemValue.top, itemValue.width - 8, itemValue.height);
                }
                    break;
                case 2:{//时间
                    imageName = @"icon_time";
                    self.timeLabel = itemValue;
                    self.timeLabel.text = @"";
                    itemTitle.frame = CGRectMake(itemTitle.left, itemTitle.top, itemTitle.width + 50, itemTitle.height);
                    itemValue.frame = CGRectMake(itemTitle.right, itemValue.top, itemValue.width + 70, itemValue.height);
                }
                    break;
                case 3:{//活动结束时间
                    imageName = @"icon_time";
                    self.endTimeLabel = itemValue;
                    self.endTimeLabel.text = @"";
                    itemTitle.frame = CGRectMake(itemTitle.left, itemTitle.top, itemTitle.width + 50, itemTitle.height);
                    itemValue.frame = CGRectMake(itemTitle.right, itemValue.top, itemValue.width + 70, itemValue.height);
                }
                    break;
                case 4:{//活动报名截止时间
                    imageName = @"icon_time";
                    self.signUpEndTimeLabel = itemValue;
                    self.signUpEndTimeLabel.text = @"";
                    itemTitle.frame = CGRectMake(itemTitle.left, itemTitle.top, itemTitle.width + 50, itemTitle.height);
                    itemValue.frame = CGRectMake(itemTitle.right, itemValue.top, itemValue.width + 70, itemValue.height);
                }
                    break;
                case 5:{//地点
                    imageName = @"icon_place";
                    self.addrLabel = itemValue;
                    self.addrLabel.text = @"";
                    self.addrLabel.numberOfLines = 0;
                    itemValue.frame = CGRectMake(itemValue.left, itemValue.top - 5, itemValue.width + 120, itemValue.height + 10);
                }
                    break;
                    
                default:
                    break;
            }
            
            UIImageView *iconImgView = [self addImageViewWithFrame:CGRectMake(5, itemTitle.top + 15, 13, 13)
                                                         imageName:[UIImage imageNamed:imageName]];
            [bgImgView addSubview:iconImgView];
        }
        
//        //sign up
//        _signUpLabel = [self addLabelWithFrame:CGRectMake(10, 185, 80, 15)
//                                          text:@"2人报名"
//                                         color:[UIColor blackColor]
//                                          font:[UIFont systemFontOfSize:14]];
//        [bgImgView addSubview:_signUpLabel];
//        //follow
//        _followLabel = [self addLabelWithFrame:CGRectMake(112, _signUpLabel.top, 80, 15)
//                                          text:@"2人关注"
//                                         color:[UIColor blackColor]
//                                          font:[UIFont systemFontOfSize:16]];
//        [bgImgView addSubview:_followLabel];
//        
//        //status image
//        _activityStatus = [self addImageViewWithFrame:CGRectMake(224, 178, 75, 21)
//                                            imageName:[UIImage imageNamed:@""]];
//        //        _activityStatus.backgroundColor = [UIColor greenColor];
//        _activityStatus.backgroundColor = COLOR_WITH_ARGB(16, 120, 45, 1.0);
//        [bgImgView addSubview:_activityStatus];
//        
//        //stauts label
//        _statusLabel = [self addLabelWithFrame:_activityStatus.frame
//                                          text:@"进行中"
//                                         color:[UIColor blackColor]
//                                          font:[UIFont systemFontOfSize:14]];
//        _statusLabel.textAlignment = NSTextAlignmentCenter;
//        [bgImgView addSubview:_statusLabel];
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
//
            CGRect imageframe = self.activityImage.frame;
            imageframe.origin.y = 43;
            self.activityImage.frame = imageframe;
//
            CGRect typeFrame = self.typeBgImgView.frame;
            typeFrame.origin.y = 10;
            self.typeBgImgView.frame = typeFrame;
            self.activityTypeLabel.frame = typeFrame;
        }
        self.activityTitleLabel.text = titleString;
        self.activityTitleLabel.text = [params objectForKey:@"actname"];
        self.activityTypeLabel.text = [params objectForKey:@"acttype"];
        self.activityDescriptionLabel.text = [params objectForKey:@"desc"];
        NSString *imageUrl = [params objectForKey:@"actimgs"];
        NSArray *images = [imageUrl componentsSeparatedByString:@","];
        imageUrl = [images lastObject];
        [self.activityImage setImageWithURL:IMGURL(imageUrl) placeholderImage:[UIImage imageNamed:@"title_bar_bg"]];
        self.tribeLabel.text = [params objectForKey:@"comefrom"];
        self.orgnizerLabel.text = [params objectForKey:@"creatername"];
        self.timeLabel.text = [params objectForKey:@"begindate"];
        self.addrLabel.text = [params objectForKey:@"actaddr"];
        self.endTimeLabel.text = [params objectForKey:@"enddate"];
        self.signUpEndTimeLabel.text = [params objectForKey:@"signupenddate"];
    }
    
//    self.signUpLabel.text = @"2人报名";
//    self.followLabel.text = @"2人关注";
//    self.activityStatus.image = [UIImage imageNamed:@""];
//    self.statusLabel.text = @"进行中";
}


@end

//
//  OnLiveCell.m
//  QXH
//
//  Created by XueYong on 6/8/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "OnLiveCell.h"

@implementation OnLiveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgImgView = [self addImageViewWithFrame:CGRectMake(10, 10, 300, 180)
                                                   imageName:[UIImage imageNamed:@"label"]];
        [self.contentView addSubview:bgImgView];
        
        UIImageView *titleBgImgView = [self addImageViewWithFrame:CGRectMake(1, 1, bgImgView.width - 2, 30)
                                                        imageName:[UIImage imageNamed:@"title_bar_bg"]];
        [bgImgView addSubview:titleBgImgView];
        
        UIImageView *typeBgImgView = [self addImageViewWithFrame:CGRectMake(230, 5, 60, 20)
                                                       imageName:[UIImage imageNamed:@"img_bg_type"]];
        [bgImgView addSubview:typeBgImgView];
        //title
        _activityTitleLabel = [self addLabelWithFrame:CGRectMake(10, 5, 200, 20)
                                                 text:@"活动标题"
                                                color:[UIColor blackColor]
                                                 font:[UIFont systemFontOfSize:16]];
        [bgImgView addSubview:_activityTitleLabel];
        
        //type
        _activityTypeLabel = [self addLabelWithFrame:typeBgImgView.frame
                                                text:@"活动类型"
                                               color:[UIColor blackColor]
                                                font:[UIFont systemFontOfSize:14]];
        [bgImgView addSubview:_activityTypeLabel];
        
        //desc
        _activityDescriptionLabel = [self addLabelWithFrame:CGRectMake(5, titleBgImgView.bottom + 10, 280, 20)
                                                       text:@"活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述"
                                                      color:[UIColor blackColor]
                                                       font:[UIFont systemFontOfSize:16]];
        _activityDescriptionLabel.numberOfLines = 0;
        [bgImgView addSubview:_activityDescriptionLabel];
        
        //image
        _activityImage = [self addImageViewWithFrame:CGRectMake(210 - 35, _activityDescriptionLabel.bottom + 5, 80 + 32, 60 + 24)
                                           imageName:[UIImage imageNamed:@"img_news"]];
        [bgImgView addSubview:_activityImage];
        
//        NSArray *items = @[@"来   自:",@"时   间:",@"",@"地   点:"];
        NSArray *items = @[@"来自:",@"时间:",@"",@"地点:"];
        for (int i = 0; i < [items count]; i ++) {
            
            UILabel *itemTitle = [self addLabelWithFrame:CGRectMake(22, _activityDescriptionLabel.bottom + 5 + i * 27, 32, 27)
                                                    text:[items objectAtIndex:i]
                                                   color:[UIColor blackColor]
                                                    font:[UIFont systemFontOfSize:12]];
            [bgImgView addSubview:itemTitle];
//            itemTitle.backgroundColor = [UIColor redColor];
            
            UILabel *itemValue = [self addLabelWithFrame:CGRectMake(itemTitle.right, itemTitle.top, 118, 27)
                                                    text:@""
                                                   color:[UIColor blackColor]
                                                    font:[UIFont systemFontOfSize:12]];
            [bgImgView addSubview:itemValue];
//            itemValue.backgroundColor = [UIColor greenColor];
            
            NSString *imageName = @"";
            switch (i) {
                case 0:{//来自
                    imageName = @"icon_comefrom";
                    self.tribeLabel = itemValue;
                    self.tribeLabel.text = @"XXXX部落";
                }
                    break;
                case 1:{//时间
                    //                    imageName = @"icon_zhujiangren";
                    imageName = @"icon_time";
                    
                    self.orgnizerLabel = itemValue;
                    self.orgnizerLabel.text = @"2014-05-25/09:30";
                }
                    break;
                case 2:{//时间
                    //                    imageName = @"icon_time";
                    self.timeLabel = itemValue;
                    self.timeLabel.text = @"2014-05-25/09:30";
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
            
            UIImageView *iconImgView = [self addImageViewWithFrame:CGRectMake(5, itemTitle.top + 7, 13, 13)
                                                         imageName:[UIImage imageNamed:imageName]];
            [bgImgView addSubview:iconImgView];
        }
        
        //sign up
        //        _signUpLabel = [self addLabelWithFrame:CGRectMake(10, 185, 80, 15)
        //                                                 text:@"2人报名"
        //                                                color:[UIColor blackColor]
        //                                                 font:[UIFont systemFontOfSize:14]];
        //        [bgImgView addSubview:_signUpLabel];
        //        //follow
        //        _followLabel = [self addLabelWithFrame:CGRectMake(112, _signUpLabel.top, 80, 15)
        //                                                 text:@"2人关注"
        //                                                color:[UIColor blackColor]
        //                                                 font:[UIFont systemFontOfSize:16]];
        //        [bgImgView addSubview:_followLabel];
        //
        //        //status image
        //        _activityStatus = [self addImageViewWithFrame:CGRectMake(224, 178, 75, 21)
        //                                                     imageName:[UIImage imageNamed:@""]];
        ////        _activityStatus.backgroundColor = [UIColor greenColor];
        //        _activityStatus.backgroundColor = COLOR_WITH_ARGB(16, 120, 45, 1.0);
        //        [bgImgView addSubview:_activityStatus];
        //
        //        //stauts label
        //        _statusLabel = [self addLabelWithFrame:_activityStatus.frame
        //                                                 text:@"进行中"
        //                                                color:[UIColor blackColor]
        //                                                 font:[UIFont systemFontOfSize:14]];
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
    self.activityTitleLabel.text = @"活动标题";
    self.activityTypeLabel.text = @"活动类型";
    self.activityDescriptionLabel.text = @"活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述";
    self.activityImage.image = [UIImage imageNamed:@""];
    self.tribeLabel.text = @"XXXX部落";
    self.orgnizerLabel.text = @"苍井空";
    self.timeLabel.text = @"2014-05-25";
    self.addrLabel.text = @"中关村";
    
    self.signUpLabel.text = @"2人报名";
    self.followLabel.text = @"2人关注";
    self.activityStatus.image = [UIImage imageNamed:@""];
    self.statusLabel.text = @"进行中";
}

@end

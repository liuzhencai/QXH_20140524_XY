//
//  TribeQuestionCell.m
//  QXH
//
//  Created by XueYong on 5/23/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "TribeQuestionCell.h"

#define HEIGHT_CELL 140
@implementation TribeQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 25)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"群动态事件";
        label.font = [UIFont systemFontOfSize:16.0];
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, label.bottom, UI_SCREEN_WIDTH - 20, 25)];
        title.text = @"每日一问";
        title.font = [UIFont systemFontOfSize:18.0];
        title.textColor = GREEN_FONT_COLOR;
        title.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:title];
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, title.bottom, 36, 36)];
        _headImgView.image = [UIImage imageNamed:@"img_portrait72"];
//        _headImgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _headImgView.top, 120, 30)];
        _name.text = @"名字";
        _name.font = [UIFont boldSystemFontOfSize:16.0];
        _name.textColor = GREEN_FONT_COLOR;
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 10 - 120, _headImgView.top, 120, 30)];
        _time.textAlignment = NSTextAlignmentRight;
        _time.text = @"22分钟前";
        _time.font = [UIFont systemFontOfSize:14.0];
        _time.textColor = [UIColor lightGrayColor];
        _time.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_time];
        
        _speechContent = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, UI_SCREEN_WIDTH - 20 - 36 - 10, 50)];
        _speechContent.text = @"发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容";
        _speechContent.numberOfLines = 0;
        _speechContent.font = [UIFont systemFontOfSize:14.0];
//        _speechContent.textColor = [UIColor lightGrayColor];
        _speechContent.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_speechContent];
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

@end

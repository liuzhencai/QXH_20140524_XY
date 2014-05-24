//
//  TribeConversationCell.m
//  QXH
//
//  Created by XueYong on 5/24/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "TribeConversationCell.h"
#define HEIGHT_CELL 110
@implementation TribeConversationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 36, 36)];
        _headImgView.image = [UIImage imageNamed:@"img_portrait72"];
//        _headImgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 20, 10, 100, 30)];
        _name.text = @"名字";
        _name.font = [UIFont boldSystemFontOfSize:16.0];
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(_name.right, _name.top, 120, 30)];
        _time.text = @"12:30:00";
        _time.font = [UIFont systemFontOfSize:14.0];
        _time.textColor = [UIColor lightGrayColor];
        _time.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_time];
        
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_name.left, _name.bottom, 234, 60)];
        bgImgView.image = [UIImage imageNamed:@"label_green"];
        [self.contentView addSubview:bgImgView];
        
        _speechContent = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, bgImgView.width - 20, 50)];
        _speechContent.text = @"发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容发言内容";
        _speechContent.numberOfLines = 0;
        _speechContent.font = [UIFont systemFontOfSize:14.0];
        _speechContent.textColor = [UIColor lightGrayColor];
        _speechContent.backgroundColor = [UIColor clearColor];
        [bgImgView addSubview:_speechContent];
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

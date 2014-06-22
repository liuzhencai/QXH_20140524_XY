//
//  InformationCommentCell.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "InformationCommentCell.h"

@implementation InformationCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(InfoCommentModel *)model
{
    [_portraitView circular];
    [_portraitView setImageWithURL:IMGURL(model.sphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [_reviewerLabel setText:model.sname];
    [_dateLabel setText:model.date];
    [_commentLabel setText:model.comment];
}

@end

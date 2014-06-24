//
//  SquareCellEx.m
//  QXH
//
//  Created by ZhaoLilong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SquareCellEx.h"

@implementation SquareCellEx

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

- (void)setCellData:(SquareInfo *)model
{
    [self.portraitView setImageWithURL:IMGURL(model.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [self.portraitView circular];
    _nameLabel.text = model.uname;
    _dateLabel.text = model.date;
    _positionLabel.text = model.uduty;
    _contentLabel.text = model.usign;
    _subContentLabel.text = model.info.content;
    [_subImageView setImageWithURL:IMGURL(model.info.artimgs)];
}

@end

//
//  MyVisitorCell.m
//  QXH
//
//  Created by ZhaoLilong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyVisitorCell.h"

@implementation MyVisitorCell

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

- (void)setVistor:(VistorModel *)vistor
{
    [_portraitView circular];
    [_portraitView setImageWithURL:IMGURL(vistor.photo) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    _titleLabel.text = vistor.displayname;
    _dateLabel.text = vistor.date;
    _displayLabel.text = vistor.signature;
}

@end

//
//  SquareCell.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-5.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "SquareCell.h"

@implementation SquareCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(SquareInfo *)model
{
    _nameLabel.text = model.uname;
    [_portraitView setImageWithURL:IMGURL(model.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    _positionLabel.text = model.uduty;
    _contentLabel.text = model.info.content;
    if ([model.info.sphoto rangeOfString:@","].location != NSNotFound) {
        NSArray *imgs = [model.info.sphoto componentsSeparatedByString:@","];
        for (int i = 1; i < [imgs count]; i++) {
            
        }
    }else{
        [_imageView1 setImageWithURL:IMGURL(model.info.sphoto)];
    }
//    [_imageView1 setImageWithURL:(NSURL *) placeholderImage:(UIImage *)]
}

@end

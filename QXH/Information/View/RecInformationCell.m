//
//  RecInformationCell.m
//  QXH
//
//  Created by ZhaoLilong on 6/17/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "RecInformationCell.h"

@implementation RecInformationCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(InfoModel *)data
{
    [_portraitImg setImageWithURL:IMGURL(data.sphoto) placeholderImage:[UIImage imageNamed:@"img_portrait"]];
    [_portraitImg setRound:YES];
    [_recPersonname setText:[NSString stringWithFormat:@"%@推荐",data.sname]];
    [_recPerson setText:data.sname];
    [_artTitle setText: data.title];
    [_artDate setText:data.date];
    [_artImg setImageWithURL:IMGURL(data.artimgs) placeholderImage:[UIImage imageNamed:@"img_news"]];
}

@end

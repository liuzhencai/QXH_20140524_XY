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
    InfoModel *tmpModel = (InfoModel *)model.content;
    _nameLabel.text = tmpModel.sname;
    [_portraitView setImageWithURL:IMGURL(tmpModel.sphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [_portraitView circular];
    _positionLabel.text = model.uduty;
    _contentLabel.text = tmpModel.content;
    if (![tmpModel.artimgs isEqualToString:@""]) {
        if ([tmpModel.artimgs rangeOfString:@","].location != NSNotFound) {
            NSArray *imgs = [tmpModel.artimgs componentsSeparatedByString:@","];
            for (int i = 0; i < [imgs count]; i++) {
                [(UIImageView *)[self viewWithTag:(111+i)] setHidden:NO];
                [(UIImageView *)[self viewWithTag:(111+i)] setImageWithURL:IMGURL(imgs[i])];
            }
        }else{
            [(UIImageView *)[self viewWithTag:111] setHidden:NO];
            [(UIImageView *)[self viewWithTag:111] setImageWithURL:IMGURL(tmpModel.artimgs)];
        }
    }
}

@end

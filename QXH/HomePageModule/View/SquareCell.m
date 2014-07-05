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
    [_portraitView setImageWithURL:IMGURL(model.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    _positionLabel.text = model.uduty;
    _contentLabel.text = tmpModel.content;
    if ([tmpModel.artimgs isEqualToString:@""]) {
        _picView.hidden = YES;
    }else{
        _picView.hidden = NO;
        if ([tmpModel.artimgs rangeOfString:@","].location != NSNotFound) {
            NSArray *imgs = [tmpModel.artimgs componentsSeparatedByString:@","];
            for (int i = 0; i < [imgs count]; i++) {
                [(UIImageView *)[self viewWithTag:(111+i)] setHidden:NO];
                [(UIImageView *)[self viewWithTag:(111+i)] setImageWithURL:IMGURL(imgs[i])];
            }
        }else{
            [_imageView1 setImageWithURL:IMGURL(tmpModel.artimgs)];
        }
    }
}

@end

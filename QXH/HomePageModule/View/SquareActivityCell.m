//
//  SquareActivityCell.m
//  QXH
//
//  Created by xuey on 14-6-5.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "SquareActivityCell.h"

@implementation SquareActivityCell

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
    SquareActInfo *actInfo = model.content;
    [_portraitView setImageWithURL:IMGURL(model.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [_portraitView circular];
    _nameLabel.text = model.uname;
    _postionLabel.text = model.uduty;
    _statusLabel.layer.cornerRadius = 3.f;
    _statusLabel.text = actInfo.acttype;
    _contentLabel.text = model.refsign;
    _dateLabel.text = model.date;
    _activityTitle.text = actInfo.actname;
    _sourceLabel.text = actInfo.comefrom;
    _posterLabel.text = actInfo.creatername;
    _activityTimeLbl.text = actInfo.signupbegindate;
    _addrLabel.text = actInfo.actaddr;
    
}

@end

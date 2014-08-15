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
    _posterLabel.text = actInfo.creatername;
    _contentLabel.text = model.refsign;
//    _posterLabel.backgroundColor = [UIColor redColor];
    if ([_postionLabel.text length]) {
        /*职位*/
        [_contentLabel setFrame:CGRectMake(70, 56, 242, 21)];
        [_bomview setFrame:CGRectMake(70, 79, 242, 115)];
    }else{
       [_contentLabel setFrame:CGRectMake(70, 30, 242, 21)];
        [_bomview setFrame:CGRectMake(70, 57, 242, 115)];
    }
    
    _dateLabel.text = model.date;
    _activityTitle.text = actInfo.actname;
    _sourceLabel.text = actInfo.comefrom;
  
    _activityTimeLbl.text = actInfo.signupbegindate;
    _addrLabel.text = actInfo.actaddr;
    NSLog(@"image:%@",IMGURL(actInfo.photos));
    NSArray *photos = [actInfo.photos componentsSeparatedByString:@","];
    NSString *imageUrl = @"";
    if ([photos count]) {
        imageUrl = [photos lastObject];
    }
    [_picView setImageWithURL:IMGURL(imageUrl) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
}

/*计算高度*/
+ (float)height:(SquareInfo *)model
{
//    SquareActInfo *actInfo = model.content;
    float heightX = 0;
    if ([model.uduty length] == 0) {
        
        heightX = 20;
    }
    return (201-heightX);
}


@end

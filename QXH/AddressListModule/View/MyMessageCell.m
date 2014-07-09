//
//  MyMessageCell.m
//  QXH
//
//  Created by XueYong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyMessageCell.h"
#import "UIImageView+WebCache.h"

@implementation MyMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat height = self.frame.size.height;
        CGFloat lableHeight = 25;
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 48)/2.0, 48, 48)];
        [_headImgView setRound:YES];
        _headImgView.image = [UIImage imageNamed:@"img_portrait96"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, (height - 2 * lableHeight)/2.0, 140, lableHeight)];
        _name.text = @"李某某";
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _duty = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight)];
        _duty.text = @"xxxxxxxxxxxxx校长";
        _duty.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_duty];
        
        _date = [[UILabel alloc] initWithFrame:CGRectMake(_name.right + 10, (height - 2 * lableHeight)/2.0, 100, lableHeight)];
        _date.textAlignment = NSTextAlignmentRight;
        _date.text = @"2014-05-19";
        _date.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_date];
        
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 12) / 2.0, 8, 12)];
        //        _arrowImgView.backgroundColor = [UIColor redColor];
        _arrowImgView.image = [UIImage imageNamed:@"list_arrow_right_gray"];
        [self.contentView addSubview:_arrowImgView];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, UI_SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:line];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews{
    CGFloat height = self.frame.size.height;
    CGFloat lableHeight = 25;
    
    _headImgView.frame = CGRectMake(10, (height - 48)/2.0, 48, 48);
    _name.frame = CGRectMake(_headImgView.right + 10, (height - 2 * lableHeight)/2.0, 100, lableHeight);
    _duty.frame = CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight);
    _arrowImgView.frame = CGRectMake(290, (height - 12) / 2.0, 8, 12);

    _date.frame = CGRectMake(_name.right - 10, (height - 2 * lableHeight)/2.0, 100, lableHeight);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, UI_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellParamDict:(id)objt{
    NSDictionary *params = (NSDictionary *)objt;
    int sendType = [[params objectForKey:@"sendtype"] intValue];
    if (sendType == 3) {//3为加好友申请
        NSString *imageUrlString = [params objectForKey:@"senderphoto"];
        [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
        
        NSString *nameString = [params objectForKey:@"sendername"];
        self.name.text = nameString;
        NSString *descString = [params objectForKey:@"sign"];
        self.duty.text = descString;
        self.date.text = [params objectForKey:@"date"];//@"2014-05-19";
    }else if(sendType == 5){//5为加入部落申请
        NSString *imageUrlString = [params objectForKey:@"senderphoto"];
        [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
        
        NSString *nameString = [params objectForKey:@"sendername"];
        self.name.text = nameString;
        NSString *descString = [params objectForKey:@"sign"];
        self.duty.text = descString;
        self.date.text = [params objectForKey:@"date"];//@"2014-05-19";
    }else if(sendType == 0 || sendType == 4 || sendType == 6 || sendType == 7 || sendType == 12 || sendType == 13){//0为系统消息,4为处理请求好友申,6为处理部落加入申请,7为完全退出部落,12 @某人,13 @部落
        NSString *imageUrlString = [params objectForKey:@"senderphoto"];
        [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
        
        NSString *nameString = [params objectForKey:@"sendername"];
        self.name.text = nameString;
        NSString *descString = [params objectForKey:@"sign"];
        self.duty.text = descString;
        self.date.text = [params objectForKey:@"date"];//@"2014-05-19";
    }
//    NSString *imageUrlString = [params objectForKey:@"senderphoto"];
//    [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
//
//    NSString *nameString = [params objectForKey:@"sendername"];
//        self.name.text = nameString;
//    NSString *descString = [params objectForKey:@"sign"];
//        self.duty.text = descString;
//    self.date.text = [params objectForKey:@"date"];//@"2014-05-19";
}

@end

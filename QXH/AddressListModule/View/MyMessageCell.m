//
//  MyMessageCell.m
//  QXH
//
//  Created by XueYong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyMessageCell.h"
#import "UIImageView+WebCache.h"
#import "JSONKit.h"
#define KCounImageWidth 25

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
        
        _date = [[UILabel alloc] initWithFrame:CGRectMake(_name.right + 10, (height - 2 * lableHeight)/2.0, 130, lableHeight)];
        _date.textAlignment = NSTextAlignmentRight;
        _date.text = @"2014-05-19";
        _date.font = [UIFont fontWithName:KFontArial size:12];
        _date.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_date];
        
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 12) / 2.0, 8, 12)];
        //        _arrowImgView.backgroundColor = [UIColor redColor];
        _arrowImgView.image = [UIImage imageNamed:@"list_arrow_right_gray"];
        [self.contentView addSubview:_arrowImgView];
        
        /*左上角显示数字背景图片*/
        _countImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, (height - 48)/2.0+5, KCounImageWidth, KCounImageWidth)];
        [_countImage setBackgroundColor:[UIColor redColor]];
        [_countImage setRound:YES];
        [self.contentView addSubview:_countImage];
        
        /*左上角显示数字背景数字*/
        _countlabel = [[UILabel alloc]initWithFrame:CGRectMake(7, (height - 48)/2.0+5, KCounImageWidth, KCounImageWidth)];
        [_countlabel setBackgroundColor:[UIColor clearColor]];
        [_countlabel setRound:YES];
        _countlabel.font =[UIFont fontWithName:KFontArial size:12];
        _countlabel.textAlignment = NSTextAlignmentCenter;
        _countlabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_countlabel];
        
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

    _date.frame = CGRectMake(_name.right - 10, (height - 2 * lableHeight)/2.0, 120, lableHeight);
    
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
    NSDictionary *params = nil;
    if ([objt isKindOfClass:[NSMutableArray class]]) {
        /*如果传过来的是数组类型，
         就是私聊或者部落聊天数据
         */
        _countlabel.hidden = NO;
        _countImage.hidden = NO;
        NSMutableArray* tempArray = (NSMutableArray*)objt;
        params = [tempArray lastObject];
        NSNumber* acount = params[@"count"];
        int sendType = [[params objectForKey:@"sendtype"] intValue];
        if(sendType == 0 || sendType == 3 || sendType == 4 || sendType == 5 || sendType == 6 || sendType == 7 || sendType == 12 /*|| sendType == 13*/){
            int count = 0;
            for (int i = 0; i < [tempArray count]; i ++) {
                NSDictionary *newDict = [tempArray objectAtIndex:i];
                NSInteger newMessid = [[newDict objectForKey:@"messid"] integerValue];
                BOOL isNew = YES;
                for (int j = 0; j < [self.lastMessages count]; j ++) {
                    NSDictionary *oldDict = [self.lastMessages objectAtIndex:j];
                    NSInteger oldMessid = [[oldDict objectForKey:@"messid"] integerValue];
                    if (newMessid == oldMessid) {
                        isNew = NO;
                        break;
                    }
                }
                if (isNew) {
                    count ++;
                }
            }
            acount = [NSNumber numberWithInt:count];
        }
//        if (!acount) {
//            int count = 0;
//            for (int i = 0; i < [tempArray count]; i ++) {
//                NSDictionary *newDict = [tempArray objectAtIndex:i];
//                NSInteger newMessid = [[newDict objectForKey:@"messid"] integerValue];
//                BOOL isNew = YES;
//                for (int j = 0; j < [self.lastMessages count]; j ++) {
//                    NSDictionary *oldDict = [self.lastMessages objectAtIndex:j];
//                    NSInteger oldMessid = [[oldDict objectForKey:@"messid"] integerValue];
//                    if (newMessid == oldMessid) {
//                        isNew = NO;
//                        break;
//                    }
//                }
//                if (isNew) {
//                    count ++;
//                }
//            }
//            acount = [NSNumber numberWithInt:count];
//        }
        if (acount) {
            /*如果存在count值，
             则为离线消息，消息数按照count值显示*/
            NSInteger count = [acount integerValue];
            if (count >99) {
                 _countlabel.text = @"99+";
            }else
            {
                _countlabel.text = [NSString stringWithFormat:@"%d",count];
            }
            if (count == 0) {
                _countlabel.hidden = YES;
                _countImage.hidden = YES;
            }
        }
        
    }else {
      params = (NSDictionary *)objt;
        _countlabel.hidden = YES;
        _countImage.hidden = YES;
    }
    
    int sendType = [[params objectForKey:@"sendtype"] intValue];
    if(sendType == 0 || sendType == 3 || sendType == 4 || sendType == 5 || sendType == 6 || sendType == 7 || sendType == 12 ){//0为系统消息,4为处理请求好友申,6为处理部落加入申请,7为完全退出部落,12 @某人,13 @部落
        //        NSString *imageUrlString = [params objectForKey:@"senderphoto"];
        //        [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
        
        self.headImgView.image = [UIImage imageNamed:@"systemMessage"];
        self.name.text = @"系统消息";
        NSString *descString = [params objectForKey:@"mess"];
        if (sendType == 3 ) {
            descString = [NSString stringWithFormat:@"%@",[params objectForKey:@"sendername"]];
        }
        else if (sendType == 4){
            descString = [NSString stringWithFormat:@"%@",[params objectForKey:@"sendername"]];
        }
        else if (sendType == 12){//@某人
            self.name.text = [params objectForKey:@"sendername"];
            NSString *message = [params objectForKey:@"mess"];
            NSDictionary *messages = [message objectFromJSONString];
            descString = [NSString stringWithFormat:@"%@ 分享了动态“%@”",[params objectForKey:@"sendername"],[messages objectForKey:@"content"]];
        }
        else if (sendType == 13){//@
            self.name.text = [params objectForKey:@"tribename"];
            NSString *message = [params objectForKey:@"mess"];
            NSDictionary *messages = [message objectFromJSONString];
            descString = [NSString stringWithFormat:@"%@ 分享了活动“%@”",[params objectForKey:@"sendername"],[messages objectForKey:@"actname"]];
        }
        self.duty.text = descString;
        self.date.text = [params objectForKey:@"date"];
    }
    else if(sendType == 1){
        /*1,好友私聊，
         2，部落聊天*/
        NSString *imageUrlString = [params objectForKey:@"senderphoto"];
        [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
        
        NSString *nameString = [params objectForKey:@"sendername"];
        self.name.text = nameString;
        
        /*1为文本，2为json对象，3为图片，4为录音*/
        NSNumber* amesstype = [params objectForKey:@"messtype"];
        NSString* messtype = [NSString stringWithFormat:@"%d",[amesstype intValue]];
        if ([messtype isEqualToString:@"1"]) {
            NSString *descString = [params objectForKey:@"mess"];
            self.duty.text = descString;
        }else if([messtype isEqualToString:@"2"])
        {
//            NSString *descString = [params objectForKey:@"sign"];
            self.duty.text = @"图片信息";
        }else if([messtype isEqualToString:@"0"])
        {
            /*如果是0，则是以前接口，没有添加该字段造成*/
            NSString *descString = [params objectForKey:@"mess"];
            if ([descString length]) {
               self.duty.text = descString;
            }else{
               self.duty.text = @"图片信息"; 
            }
        }

        self.date.text = [params objectForKey:@"date"];//@"2014-05-19";
    }else if(sendType == 2)
    {
        NSString *imageUrlString = [params objectForKey:@"tribephoto"];
        [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
        
        NSString *nameString = [params objectForKey:@"tribename"];
        self.name.text = nameString;
        
        /*1为文本，2为json对象，3为图片，4为录音*/
        NSNumber* amesstype = [params objectForKey:@"messtype"];
        NSString* messtype = [NSString stringWithFormat:@"%d",[amesstype intValue]];
        if ([messtype isEqualToString:@"1"]) {
            NSString *descString = [params objectForKey:@"mess"];
            self.duty.text = descString;
        }else if([messtype isEqualToString:@"2"])
        {
            //            NSString *descString = [params objectForKey:@"sign"];
            self.duty.text = @"图片信息";
        }else if([messtype isEqualToString:@"0"])
        {
            /*如果是0，则是以前接口，没有添加该字段造成*/
            NSString *descString = [params objectForKey:@"mess"];
            if ([descString length]) {
                self.duty.text = descString;
            }else{
                self.duty.text = @"图片信息";
            }
        }
        
        self.date.text = [params objectForKey:@"date"];//@"2014-05-19";
    }
    else if(sendType == 13)
    {
        self.name.text = [params objectForKey:@"tribename"];
        NSString *message = [params objectForKey:@"mess"];
        NSDictionary *messages = [message objectFromJSONString];
        NSString *descString = [NSString stringWithFormat:@"%@ 分享了活动“%@”",[params objectForKey:@"sendername"],[messages objectForKey:@"actname"]];
        self.duty.text = descString;
        self.date.text = [params objectForKey:@"date"];
        NSString *imageUrlString = [params objectForKey:@"senderphoto"];
        [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
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

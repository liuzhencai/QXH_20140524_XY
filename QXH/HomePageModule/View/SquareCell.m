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
    NSInteger heightX = 0;
    InfoModel *tmpModel = (InfoModel *)model.content;
    _nameLabel.text = tmpModel.sname;
    [_portraitView setImageWithURL:IMGURL(tmpModel.sphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [_portraitView circular];
    if ([tmpModel.content length] < 50) {
        _contentLabel.text = tmpModel.content;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont* font = [UIFont systemFontOfSize:13.f];
        CGSize size = CGSizeMake(242,2000);
        CGSize labelsize = [tmpModel.content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        heightX= 50-labelsize.height;
        [_contentLabel setFrame:CGRectMake(70,35, 242, labelsize.height)];
    
    }else{
        _contentLabel.text = [[tmpModel.content substringToIndex:50] stringByAppendingString:@"..."];
        [_contentLabel setFrame:CGRectMake(70, 30, 242, 50)];
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 77, 60, 21)];
        detailLbl.font = [UIFont systemFontOfSize:13.f];
        detailLbl.text = @"查看详情";
        detailLbl.textColor = [UIColor colorWithRed:78/255.f green:199/255.f blue:60/255.f alpha:1.f];
        detailLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:detailLbl];
    }
    _dateLabel.text = [tmpModel.date substringToIndex:10];
    if (![tmpModel.artimgs isEqualToString:@""]) {
        if ([tmpModel.artimgs rangeOfString:@","].location != NSNotFound) {
            NSArray *imgs = [tmpModel.artimgs componentsSeparatedByString:@","];
            for (int i = 0; i < [imgs count]; i++) {
                UIImageView* imageview = (UIImageView*)[self viewWithTag:(111+i)] ;
                [imageview setHidden:NO];
                [imageview setImageWithURL:IMGURL(imgs[i])];
                [imageview setFrame:CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y-heightX, imageview.size.width, imageview.size.height)];
                
//                [(UIImageView *)[self viewWithTag:(111+i)] setHidden:NO];
//                [(UIImageView *)[self viewWithTag:(111+i)] setImageWithURL:IMGURL(imgs[i])];
            }
        }else{
            UIImageView* imageview = (UIImageView*)[self viewWithTag:111] ;
            [imageview setHidden:NO];
            [imageview setImageWithURL:IMGURL(tmpModel.artimgs)];
            [imageview setFrame:CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y-heightX, imageview.size.width, imageview.size.height)];
//            [imageview removeFromSuperview];
//            [self.contentView addSubview:imageview];
//            [(UIImageView *)[self viewWithTag:111] setHidden:NO];
//            [(UIImageView *)[self viewWithTag:111] setImageWithURL:IMGURL(tmpModel.artimgs)];
        }
    }
    

}

+ (float)height:(SquareInfo *)model
{
    float heightX = 0;
    InfoModel *tmpModel = (InfoModel *)model.content;

    if ([tmpModel.content length] < 50) {
        UILabel* temlabel = [[UILabel alloc]init];
        temlabel.text = tmpModel.content;
        temlabel.numberOfLines = 0;
        temlabel.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont* font = [UIFont systemFontOfSize:13.f];
        CGSize size = CGSizeMake(242,2000);
        CGSize labelsize = [tmpModel.content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        heightX= 50-labelsize.height;
 
        
    }
    return (162-heightX);
}


@end

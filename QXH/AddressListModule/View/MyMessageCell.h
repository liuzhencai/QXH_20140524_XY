//
//  MyMessageCell.h
//  QXH
//
//  Created by XueYong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *duty;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIImageView* countImage;
@property (nonatomic, strong) UILabel* countlabel;

@property (nonatomic, strong) NSMutableArray *lastMessages;

- (void)resetCellParamDict:(id)objt;
@end

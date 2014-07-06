//
//  InfluenceCell.h
//  QXH
//
//  Created by XueYong on 7/6/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfluenceCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *duty;
@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, strong) UILabel *comment;//评论
@property (nonatomic, assign) BOOL isFans;//

- (void)resetCellParamDict:(id)objt;

@end

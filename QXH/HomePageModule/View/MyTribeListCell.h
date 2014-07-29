//
//  MyTribeCell.h
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTribeListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;//头像
@property (nonatomic, strong) UIImageView *authflagView;//认证标志
@property (nonatomic, strong) UILabel *nowCount;//当前人数

@property (nonatomic, strong) UILabel *name;//名称
@property (nonatomic, strong) UILabel *dynamic;//动态
@property (nonatomic, strong) UILabel *creatMan;//创建人
@property (nonatomic, strong) UIImageView *arrowImgView;

- (void)resetCellParamDict:(id)objt;
@end

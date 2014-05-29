//
//  TribeQuestionCell.h
//  QXH
//
//  Created by XueYong on 5/23/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TribeQuestionCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImgView;//头像
@property (nonatomic, strong) UILabel *name;//姓名
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *speechContent;//发言内容

- (void)resetCellParamDict:(id)objt;
@end

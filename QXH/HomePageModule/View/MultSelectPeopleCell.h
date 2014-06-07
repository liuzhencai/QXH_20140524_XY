//
//  MultSelectPeopleCell.h
//  QXH
//
//  Created by XueYong on 6/7/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultSelectPeopleCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectBtn;//选择框
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *duty;
@property (nonatomic, strong) UIImageView *arrowImgView;

- (void)resetCellParamDict:(id)objt;
@end

//
//  CreatTribeCell.h
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreatTribeCellDelegate <NSObject>

- (void)didSelectWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface CreatTribeCell : UITableViewCell

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) UIButton *selectBtn;//选择框
@property (nonatomic, strong) UIImageView *headImgView;//头像
@property (nonatomic, strong) UILabel *name;//名称
@property (nonatomic, strong) UILabel *dynamic;//动态
@property (nonatomic, strong) UILabel *creatMan;//创建人
@property (nonatomic, strong) UIImageView *arrowImgView;

- (void)resetCellParamDict:(id)objt;
@end

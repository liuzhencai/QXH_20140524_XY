//
//  CustomSegmentView.h
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegmentView : UIView
{
    NSArray *items;//参数是字符串数组
    NSInteger selectIndex;//选择项
    id targetValue;
    SEL selector;
    BOOL hiddenWhenSigle;
    
@private
    NSInteger currentSelectIndex;//是否有初始选项
    BOOL isSetInitValue;//是否有初始选项
    NSMutableArray *btnArr;
}
//用法 跟系统的差不多
//初始化用- (id)initWithFrame:(CGRect)frame
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL hiddenWhenSigle;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) id targetValue;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, assign) BOOL isSetInitValue;

- (void)addTarget:(id)target action:(SEL)action;
- (void)setHiddenWhenSigle:(BOOL)hiden;

@end

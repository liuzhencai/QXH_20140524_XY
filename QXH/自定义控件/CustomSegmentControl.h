//
//  CustomSegmentControl.h
//  QXH
//
//  Created by ZhaoLilong on 5/21/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegmentControlDelegate <NSObject>

- (void)segmentClicked:(NSInteger)index;

@end

@interface CustomSegmentControl : UIView

- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;

@property (nonatomic, assign) id<CustomSegmentControlDelegate> delegate;

@end

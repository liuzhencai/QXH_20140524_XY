//
//  PortraitView.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-5.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PortraitViewDelegate <NSObject>

- (void)selectPortrait:(NSObject *)obj;
@optional
- (void)singUpPortrait:(id)obj;
@end

@interface PortraitView : UIView<UITableViewDelegate, UITableViewDataSource>

- (id)initWithFrame:(CGRect)frame title:(NSString *)title portraits:(NSArray *)images andDelegate:(id)del andShowBtn:(BOOL)isShowBtn;

@end

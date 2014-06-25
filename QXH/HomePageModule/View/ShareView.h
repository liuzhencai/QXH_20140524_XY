//
//  ShareView.h
//  First
//
//  Created by XUE on 14-5-22.
//  Copyright (c) 2014年 XUE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShareBlock) (id objct);

@interface ShareView : UIView
@property (nonatomic, copy) ShareBlock shareBlack;

- (id)initWithParam:(id)objt;
- (void)show;
-(void)shareHide;

@end

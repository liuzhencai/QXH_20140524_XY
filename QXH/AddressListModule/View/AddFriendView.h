//
//  AddFriendView.h
//  QXH
//
//  Created by XueYong on 6/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AddFriendViewBlock) (id objt);
@interface AddFriendView : UIView
@property (nonatomic, copy) AddFriendViewBlock addFriendBlack;

- (id)initWithParam:(id)objt;
- (void)show;
-(void)addFriendHide;
@end

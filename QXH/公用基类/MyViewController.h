//
//  MyViewController.h
//  SuZhouDemo
//
//  Created by liuzhencai on 13-6-17.
//  Copyright (c) 2013年 liuzhencai. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "KeyBoardTopBar.h"
//#import "CostomKeyboard.h"
//#import "Grand.h"


@interface MyViewController : UIViewController
{
    /*背景图*/
    UIImageView * backGroundImageView;
//    /*避免多次弹出*/
//    BOOL IsshowAlert;
    
}

-(void)popForwardBack;
- (void)showAlert:(NSString *)msg;
- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                         color:(UIColor *)color
                          font:(UIFont *)font;

- (NSString *)cityNameWithCode:(NSString *)code;
@end

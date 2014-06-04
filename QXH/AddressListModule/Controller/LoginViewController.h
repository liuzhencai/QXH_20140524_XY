//
//  LoginViewController.h
//  QXH
//
//  Created by XueYong on 5/15/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "config.h"

@interface LoginViewController : MyViewController<UITextFieldDelegate>

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *pwField;

@end

@protocol LoginDelegate <NSObject>

- (void)didLoginHandle:(LoginViewController *)loginViewController;

@end
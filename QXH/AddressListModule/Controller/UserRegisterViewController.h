//
//  UserRegisterViewController.h
//  QXH
//
//  Created by XueYong on 5/15/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^RegisterCallBack) (NSDictionary *dict) ;

@interface UserRegisterViewController : MyViewController
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *pwField;
@property (nonatomic, strong) UITextField *repeatPWField;
@property (nonatomic, copy) DictCallback registerCallBack;
@end

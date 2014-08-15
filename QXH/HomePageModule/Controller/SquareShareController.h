//
//  SquareShareController.h
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//  发布分享

#import <UIKit/UIKit.h>
#import "SNImagePickerNC.h"
#import "SquareViewController.h"

#define PORTRAIT_GAP 5

@interface SquareShareController : MyViewController<UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, SNImagePickerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *distributeBtn;
@property (nonatomic, assign) SquareViewController *controller;
@property (weak, nonatomic) IBOutlet UIScrollView *atPersonScroll;
- (IBAction)distribute:(id)sender;
- (IBAction)selectImage:(id)sender;
- (IBAction)selectPeople:(id)sender;

@end

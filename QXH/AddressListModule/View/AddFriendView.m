//
//  AddFriendView.m
//  QXH
//
//  Created by XueYong on 6/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "AddFriendView.h"

@interface AddFriendView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView  *bgView;//背景
@property (nonatomic, strong) UITextField *remarks;//备注
@property (nonatomic, strong) NSDictionary *memberDict;
@end
#define VIEW_WIDTH 260
#define VIEW_HEIGHT 140
@implementation AddFriendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithParam:(id)objt{
    self = [super initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT)];
    self.backgroundColor = [UIColor clearColor];
    self.memberDict = (NSDictionary *)objt;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
//    _bgView.center = self.center;
    _bgView.center = CGPointMake(self.center.x, self.center.y - 40);
    _bgView.layer.cornerRadius = 5.0;
    _bgView.layer.masksToBounds = YES;
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    return self;
}

- (void)layoutSubviews{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEW_WIDTH - 30, 35)];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    NSString *titleString = [NSString stringWithFormat:@"添加%@为好友",[self.memberDict objectForKey:@"displayname"]];
    title.text = titleString;
    [_bgView addSubview:title];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 80, 60)];
    imgView.image = [UIImage imageNamed:@"collect_img_share"];
    //    imgView.backgroundColor = [UIColor redColor];
//    [_bgView addSubview:imgView];
    
//    UILabel *activityDes = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 10, imgView.top, VIEW_WIDTH - imgView.width - 30 - 10, imgView.height)];
//    activityDes.text = @"活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍";
//    activityDes.numberOfLines = 0;
//    [_bgView addSubview:activityDes];
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, imgView.bottom + 10, VIEW_WIDTH - 30, 50)];
//    self.activityText = textView;
//    textView.text = @"分享留言";
//    textView.layer.borderWidth = 0.5;
//    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
////    textView.delegate = self;
//    [_bgView addSubview:textView];
    
    UILabel *remarksTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, title.bottom + 15, 70, 30)];
    remarksTitle.text = @"备注名称:";
    remarksTitle.backgroundColor = [UIColor clearColor];
    remarksTitle.textAlignment = NSTextAlignmentRight;
    remarksTitle.font = [UIFont systemFontOfSize:16];
    [_bgView addSubview:remarksTitle];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(remarksTitle.right, remarksTitle.top, 170, 30)];
    self.remarks = textField;
    textField.placeholder = @"(选填)";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    [_bgView addSubview:textField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 40.5, VIEW_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:lineView];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * 130, VIEW_HEIGHT - 40, 130, 40);
        btn.tag = i + 100;
        if (i == 0) {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            //            btn.backgroundColor = [UIColor redColor];
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(129.5, 0, 0.5, 45)];
            lineView2.backgroundColor = [UIColor lightGrayColor];
            [btn addSubview:lineView2];
        }else{
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            //            btn.backgroundColor = [UIColor greenColor];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
    }
}

- (void)show{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0f;
    }];
}

-(void)addFriendHide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    }completion:^(BOOL finished){
        if ([self superview])
        {
            [self removeFromSuperview];
        }
    }];
}

- (void)touchButton:(UIButton *)sender{
    NSLog(@"show action");
    if (sender.tag == 101) {
        if (self.addFriendBlack) {
            NSString *backString = @"";
            if ([self.remarks.text length]) {
                backString = self.remarks.text;
            }
            self.addFriendBlack(backString);
        }
    }
    [self addFriendHide];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - UITextfiledDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string length] > 20) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end

//
//  ShareView.m
//  First
//
//  Created by XUE on 14-5-22.
//  Copyright (c) 2014年 XUE. All rights reserved.
//

#import "ShareView.h"

#define VIEW_WIDTH 260
#define VIEW_HEIGHT 215

@interface ShareView ()<UITextViewDelegate>
@property (nonatomic, strong) UIView  *bgView;//背景
@property (nonatomic, strong) UITextView *activityText;
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation ShareView

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
    self.params = (NSDictionary *)objt;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    _bgView.center = self.center;
    _bgView.layer.cornerRadius = 5.0;
    _bgView.layer.masksToBounds = YES;
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    return self;
}


- (void)layoutSubviews{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEW_WIDTH - 30, 35)];
    title.backgroundColor = [UIColor clearColor];
    NSString *titleStr = [self.params objectForKey:@"actname"];
    title.text = titleStr;
    [_bgView addSubview:title];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 80, 60)];
    NSString *imageUrlString = [self.params objectForKey:@"actimgs"];
    [imgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"collect_img_share"]];
    [_bgView addSubview:imgView];
    
    UILabel *activityDes = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 10, imgView.top, VIEW_WIDTH - imgView.width - 30 - 10, imgView.height)];
    activityDes.text = [self.params objectForKey:@"desc"];
    activityDes.numberOfLines = 0;
    [_bgView addSubview:activityDes];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, imgView.bottom + 10, VIEW_WIDTH - 30, 50)];
    self.activityText = textView;
    textView.text = @"";//@"分享留言";
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.delegate = self;
    [_bgView addSubview:textView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 215 - 45.5, VIEW_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:lineView];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * 130, 215 - 45, 130, 45);
        btn.tag = i + 100;
        if (i == 0) {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
//            btn.backgroundColor = [UIColor redColor];
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(129.5, 0, 0.5, 45)];
            lineView2.backgroundColor = [UIColor lightGrayColor];
            [btn addSubview:lineView2];
        }else{
            [btn setTitle:@"发送" forState:UIControlStateNormal];
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

-(void)shareHide
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
        if (self.shareBlack) {
            NSString *activityStr = @"";
            activityStr = self.activityText.text;
            self.shareBlack(activityStr);
        }
    }
    [self shareHide];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>=100)
    {
        return  NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.activityText resignFirstResponder];
}

@end

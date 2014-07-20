//
//  EditUserInfoViewController.m
//  QXH
//
//  Created by xuey on 14-6-27.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "EditUserInfoViewController.h"

@interface EditUserInfoViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *placeHolders;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *submit;
@end

@implementation EditUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _titles = @[@"真实姓名",@"个性签名",@"工作单位",@"城市信息",@"单位职务",@"兴趣爱好",@"毕业院校",@"手机号码",@"曾获荣誉"];
        _placeHolders = @[@"输入真实姓名",@"输入个性签名",@"输入工作单位",@"输入城市信息",@"输入单位职务",@"输入兴趣爱好",@"输入毕业院校",@"输入手机号码",@"输入曾获荣誉"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [_titles objectAtIndex:self.type];
    UITextField *textField = [self addTextFieldWithFrame:CGRectMake(20, 20, 280, 30) placeHolder:[_placeHolders objectAtIndex:self.type]];
    self.textField = textField;
    self.textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:textField];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake((UI_SCREEN_WIDTH - 280)/2.0, textField.bottom + 30, 280, 40);
    self.submit = submit;
    [submit setTitle:@"保  存" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:18];
    [submit setBackgroundImage:[UIImage imageNamed:@"btn_submit_normal"] forState:UIControlStateNormal];
    [submit setBackgroundImage:[UIImage imageNamed:@"btn_submit_highlight"] forState:UIControlStateHighlighted];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    self.submit.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submit:(UIButton *)sender{
    NSLog(@"保存信息");
    if (self.editUserInfoCallBack) {
        self.editUserInfoCallBack(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTitles{
    //    EditUserInfoTypeName,//姓名
    //    EditUserInfoTypeSignature,//签名
    //    EditUserInfoTypeWorkUnit,//工作单位
    //    EditUserInfoTypeCity,//城市
    //    EditUserInfoTypeDuty,//单位职务
    //    EditUserInfoTypeInterest,//兴趣爱好
    //    EditUserInfoTypeSchool,//毕业院校
    //    EditUserInfoTypePhone,//手机号码
    //    EditUserInfoTypeHonor//曾获荣誉
    
    
    switch (self.type) {
        case EditUserInfoTypeName:{
            self.title = @"真实姓名";
        }
            break;
        case EditUserInfoTypeSignature:{
            self.title = @"个性签名";
        }
            break;
        case EditUserInfoTypeWorkUnit:{
            self.title = @"工作单位";
        }
            break;
        case EditUserInfoTypeCity:{
            self.title = @"城市信息";
        }
            break;
        case EditUserInfoTypeDuty:{
            self.title = @"单位职务";
        }
            break;
        case EditUserInfoTypeInterest:{
            self.title = @"兴趣爱好";
        }
            break;
        case EditUserInfoTypeSchool:{
            self.title = @"毕业院校";
        }
            break;
        case EditUserInfoTypePhone:{
            self.title = @"手机号码";
        }
            break;
        case EditUserInfoTypeHonor:{
            self.title = @"曾获荣誉";
        }
            break;
            
        default:
            break;
    }
}

- (UITextField *)addTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textField.placeholder = placeHolder;
    textField.textColor = UIColorFromRGB(0x000000);;
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    
    return textField;
}

#pragma mark - UITextFieldViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField.text length] > 0) {
        self.submit.enabled = YES;
    }else{
        self.submit.enabled = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

@end

//
//  UserRegisterViewController.m
//  QXH
//
//  Created by XueYong on 5/15/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "FillNameCardViewController.h"

#import "EditCardController.h"

@interface UserRegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isAgreeConvention;//是否同意公约
@property (nonatomic, strong) UIImageView *agreeImageView;
@end

#define HEIGHT_TO_TOP 20
#define WIDTH_TO_LEFT 20
#define LABEL_WIDTH 80
#define LABEL_HEIGHT 30
#define TEXT_FIELD_WIDTH (UI_SCREEN_WIDTH - WIDTH_TO_LEFT * 2 - LABEL_WIDTH - 20)

@implementation UserRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    NSArray *arrar = @[@"邮箱",@"密码",@"重复密码"];
    for (int i = 0; i < [arrar count]; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_TO_LEFT, HEIGHT_TO_TOP + i * (LABEL_HEIGHT + 10), LABEL_WIDTH, LABEL_HEIGHT)];
        label.text = [arrar objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top, 0.5, label.height)];
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:verticalLine];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label.right + 20, label.top, TEXT_FIELD_WIDTH, LABEL_HEIGHT)];
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = [UIColor blackColor];
        textField.delegate = self;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        textField.backgroundColor = [UIColor redColor];
        textField.secureTextEntry = YES;
        [self.view addSubview:textField];
        
        NSString *placeholderStr = nil;
        if (0 == i) {
            self.emailField = textField;
            placeholderStr = @"请输入邮箱";
        }else if(1 == i){
            self.pwField = textField;
            placeholderStr = @"请输入密码";
        }else{
            self.repeatPWField = textField;
            placeholderStr = @"请再次输入密码";
        }
        textField.placeholder = placeholderStr;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_TO_LEFT, textField.bottom + 4, UI_SCREEN_WIDTH - WIDTH_TO_LEFT * 2 , 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
    }
    
    UIButton *conventionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    conventionBtn.frame = CGRectMake((UI_SCREEN_WIDTH - 140)/2, HEIGHT_TO_TOP + 3 * (LABEL_HEIGHT + 10) + HEIGHT_TO_TOP, 140, 20);
    [conventionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [conventionBtn setTitle:@"我同意接受会员章程" forState:UIControlStateNormal];
    conventionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [conventionBtn addTarget:self action:@selector(agreeConvention:) forControlEvents:UIControlEventTouchUpInside];
//    conventionBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:conventionBtn];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 10, 10)];
    self.agreeImageView = imageView;
    imageView.image = [UIImage imageNamed:@"tribe_icon_establish_normal"];
//    imageView.backgroundColor = [UIColor greenColor];
    [conventionBtn addSubview:imageView];
    
    //查看按钮
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - WIDTH_TO_LEFT - 40, conventionBtn.top, 40, 20)];
    [checkBtn setTitle:@"查看" forState:UIControlStateNormal];
    [checkBtn setTitleColor:COLOR_WITH_ARGB(17, 120, 45, 1.0) forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [checkBtn addTarget:self action:@selector(checkConvention:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
    
    //注册
    UIButton *userRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    userRegister.frame = CGRectMake((UI_SCREEN_WIDTH - 220)/2.0, conventionBtn.bottom + 40, 220, 33);
    [userRegister setTitle:@"注册" forState:UIControlStateNormal];
    [userRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userRegister setBackgroundImage:[UIImage imageNamed:@"btn_submit_normal"] forState:UIControlStateNormal];
    [userRegister setBackgroundImage:[UIImage imageNamed:@"btn_submit_highlight"] forState:UIControlStateHighlighted];
    [userRegister addTarget:self action:@selector(userRegister:) forControlEvents:UIControlEventTouchUpInside];
    userRegister.titleLabel.font = [UIFont systemFontOfSize:18];
//    userRegister.backgroundColor = [UIColor greenColor];
    [self.view addSubview:userRegister];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)agreeConvention:(UIButton *)sender{
    NSLog(@"I agree convention or no");
    self.isAgreeConvention = !self.isAgreeConvention;
    if (self.isAgreeConvention) {
//        self.agreeImageView.backgroundColor = [UIColor yellowColor];
        self.agreeImageView.image = [UIImage imageNamed:@"tribe_icon_establish_highlight"];
    }else{
//        self.agreeImageView.backgroundColor = [UIColor greenColor];
        self.agreeImageView.image = [UIImage imageNamed:@"tribe_icon_establish_normal"];
    }
}

//查看会员公约
- (void)checkConvention:(UIButton *)sender{
    NSLog(@"查看");
    
}

//注册
- (void)userRegister:(UIButton *)sender{
    NSLog(@"注册");
//    FillNameCardViewController *nameCard = [[FillNameCardViewController alloc] init];
//    [self.navigationController pushViewController:nameCard animated:YES];
    EditCardController *editCard = [[EditCardController alloc] init];
    editCard.title = @"注册";
    [self.navigationController pushViewController:editCard animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _emailField) {
        [_pwField becomeFirstResponder];
    }else if(textField == _pwField){
        [_repeatPWField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_emailField resignFirstResponder];
    [_pwField resignFirstResponder];
    [_repeatPWField resignFirstResponder];
}

@end

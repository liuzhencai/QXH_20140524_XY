//
//  ConstitutionViewController.m
//  QXH
//
//  Created by XueYong on 7/13/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "ConstitutionViewController.h"
#import "CustomWebView.h"

@interface ConstitutionViewController ()

@end

@implementation ConstitutionViewController

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
    self.title = @"校长强学会会员章程";
    CustomWebView *_webview=[[CustomWebView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"qxh_rule" ofType:@"htm"];
     NSLog(@"文件路径：%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webview loadRequest:request];
    //    self.webView=_webview;
    _webview.scalesPageToFit = YES;
    [self.view addSubview:_webview];
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

@end

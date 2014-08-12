//
//  AdVIewController.m
//  QXH
//
//  Created by ZhaoLilong on 7/16/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "AdVIewController.h"

@interface AdVIewController ()

@end

@implementation AdVIewController

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
    // Do any additional setup after loading the view.
    self.title = self.title;
    
    CustomWebView *webView = [[CustomWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 44 - 20)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f]];
    [self.view addSubview:webView];
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

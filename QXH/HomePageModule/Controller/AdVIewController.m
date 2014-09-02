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

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = self.titleStr;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = kTextLineBreakByWordWrapping;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    view.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = titleLabel;

    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CustomWebView *webView = [[CustomWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 44 - 20)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f]];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

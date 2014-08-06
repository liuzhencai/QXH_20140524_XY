//
//  CustomWebView.m
//  QXH
//
//  Created by ZhaoLilong on 14-7-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "CustomWebView.h"

@interface CustomWebView ()
{
    BOOL isLoadingFinished;
}
@end

@implementation CustomWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //html是否加载完成
        isLoadingFinished = NO;
        
        //这里一定要设置为NO
        [self setScalesPageToFit:NO];
        
        //第一次加载先隐藏webview
        [self setHidden:YES];
        
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // hide the shadows at the top and bottom of the webview's frame
    for (UIView* shadowView in [self.scrollView subviews])
    {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
            [shadowView setHidden:YES];
        }
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //若已经加载完成，则显示webView并return
    if(isLoadingFinished)
    {
        [self setHidden:NO];
        return;
    }
    
    //js获取body宽度
    NSString *bodyWidth= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth "];
    
    int widthOfBody = [bodyWidth intValue];
    
    //获取实际要显示的html
    NSString *js = @"document.getElementsByTagName('html')[0].innerHTML";
    NSString *html = [self htmlAdjustWithPageWidth:widthOfBody
                                              html:[webView stringByEvaluatingJavaScriptFromString:js]
                                           webView:webView];
    
    //设置为已经加载完成
    isLoadingFinished = YES;
    //加载实际要现实的html
    [self loadHTMLString:html baseURL:nil];
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    CGFloat initialScale = webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
}

@end

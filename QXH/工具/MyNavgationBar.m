//
//  MyNavgationBar.m
//  NewBank
//
//  Created by zkjc on 10-8-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//推送信息

#import "MyNavgationBar.h"


@implementation UINavigationBar(CustomImage)


- (void)drawRect:(CGRect)rect {  
   
    UIImage *image = [UIImage imageNamed: @"NavgationBar.png"];  
    
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];  
    UILabel *alabel=[[UILabel alloc] initWithFrame:CGRectMake(85, 0, 150, 44)];
    alabel.textColor=[UIColor blackColor];
    alabel.font=[UIFont systemFontOfSize:19];
    alabel.backgroundColor=[UIColor clearColor];
    alabel.textAlignment=UITextAlignmentCenter;
    alabel.text=self.topItem.title;
    self.topItem.titleView=alabel;
//    [alabel release];
//	self.tintColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
} 
-(void) setNeedsDisplay1
{
    if([[[UIDevice currentDevice] systemVersion] intValue]<5.0){
  
        [self setNeedsDisplay];

    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:@"NavgationBar.png"] forBarMetrics:UIBarMetricsDefault];


        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19], UITextAttributeFont,[UIColor blackColor],UITextAttributeTextColor,nil];
        self.titleTextAttributes=dic;

    }
    
}

//- (void)setMyTittle:(NSString *)astring{
//    self.topItem.title=astring;
//    UILabel *alabel=[[UILabel alloc] initWithFrame:self.frame];
//    alabel.textColor=[UIColor blackColor];
//    alabel.font=[UIFont systemFontOfSize:22];
//    alabel.backgroundColor=[UIColor clearColor];
//    alabel.textAlignment=UITextAlignmentCenter;
//    alabel.text=astring;
//    self.topItem.titleView=alabel;
//}

@end

//
//  Tool.m
//  QXH
//
//  Created by liuzhencai on 14-7-23.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "Tool.h"

@implementation Tool

/*名片分享到部落显示的信息*/
+(NSString*)MingPianShowTex:(NSString*)mess
{
    NSRange range = [mess rangeOfString:@"sourcetype"];
    NSString* sourcetype = nil;
    if (range.location != NSNotFound) {
        NSRange range1 = NSMakeRange(range.location+12, 1);
        sourcetype = [mess substringWithRange:range1];
    }
    NSArray* mesageArray = [mess componentsSeparatedByString:@","];
 
    switch ([sourcetype integerValue]) {
        case 1:
        {
//            /*广场文章*/
//            NSString* aTitleString= nil;
//            for (int i=0; i<[mesageArray count]; i++) {
//                NSString* temp1 = [mesageArray objectAtIndex:i];
//                NSRange range2 = [temp1 rangeOfString:@"title"];
//                if (range2.location != NSNotFound) {
//                    
//                    NSRange range3 = NSMakeRange(range2.location+8, [temp1 length]-9-range2.location);
//                    aTitleString = [temp1 substringWithRange:range3];
//                    break;
//                }
//            }
//            NSString* result = [NSString stringWithFormat:@"*广场分享*\n\t%@",aTitleString];
//            return result;
            
        }
            break;
        case 2:
        {
//            /*智谷文章*/
//            NSString* aTitleString= nil;
//            for (int i=0; i<[mesageArray count]; i++) {
//                NSString* temp1 = [mesageArray objectAtIndex:i];
//                NSRange range2 = [temp1 rangeOfString:@"title"];
//                if (range2.location != NSNotFound) {
//                    
//                    NSRange range3 = NSMakeRange(range2.location+8, [temp1 length]-9-range2.location);
//                    aTitleString = [temp1 substringWithRange:range3];
//                    break;
//                }
//            }
//            NSString* result = [NSString stringWithFormat:@"*智谷分享*\n\t%@",aTitleString];
//            return result;
        }
            break;
        case 3:
        {
            /*活动分享*/
            NSString* aTitleString= nil;
//            NSString* aTimeString= nil;
//            NSString* aPlaceString = nil;
            for (int i=0; i<[mesageArray count]; i++) {
                NSString* temp1 = [mesageArray objectAtIndex:i];
                NSRange range2 = [temp1 rangeOfString:@"actname"];
//                NSRange range3 = [temp1 rangeOfString:@"begindate"];
//                NSRange range4 = [temp1 rangeOfString:@"actaddr"];
                if (range2.location != NSNotFound) {
                    
                    NSRange range23 = NSMakeRange(range2.location+10, [temp1 length]-10-1-range2.location);
                    aTitleString = [temp1 substringWithRange:range23];
                    break;
                   
                }
//                else if (range3.location != NSNotFound)
//                {
//                    NSRange range33 = NSMakeRange(range3.location+12, [temp1 length]-12-1-range2.location);
//                    aTimeString = [temp1 substringWithRange:range33];
//                }else if (range4.location != NSNotFound)
//                {
//                    NSRange range43 = NSMakeRange(range4.location+10, [temp1 length]-10-1-range2.location);
//                    aPlaceString = [temp1 substringWithRange:range43];
//                }
            }
            NSString* result = [NSString stringWithFormat:@"*活动分享*\n\t活动名称:%@",aTitleString];
            return result;
        }
            break;
        case 4:
        {
            /*名片分享*/
            NSString* aTitleString= nil;
            for (int i=0; i<[mesageArray count]; i++) {
                NSString* temp1 = [mesageArray objectAtIndex:i];
                NSRange range2 = [temp1 rangeOfString:@"displayname"];
                if (range2.location != NSNotFound) {
                    
                    NSRange range3 = NSMakeRange(range2.location+14, [temp1 length]-15-range2.location);
                    aTitleString = [temp1 substringWithRange:range3];
                    break;
                }
            }
            NSString* result = [NSString stringWithFormat:@"*名片分享*\n\t%@",aTitleString];
            return result;
        }
            break;
        default:
            break;
    }
    
    
  
    return nil;
}
@end

//
//  SqureInfo.h
//  
//
//  Created by ZhaoLilong on 14-6-22.
//  Copyright (c) 2014 suning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquareInfo : NSObject <NSCoding> {
    NSString *content;
    NSString *date;
    NSNumber *psid;
    NSString *refsign;
    NSNumber *type;
    NSString *uduty;
    NSNumber *uid;
    NSString *uname;
    NSString *uphoto;
    NSString *usign;
}

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSNumber *psid;
@property (nonatomic, copy) NSString *refsign;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSString *uduty;
@property (nonatomic, copy) NSNumber *uid;
@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *uphoto;
@property (nonatomic, copy) NSString *usign;

+ (SquareInfo *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end

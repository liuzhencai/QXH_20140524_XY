//
//  SqureInfo.m
//  
//
//  Created by ZhaoLilong on 14-6-22.
//  Copyright (c) 2014 suning. All rights reserved.
//

#import "SquareInfo.h"

@implementation SquareInfo

@synthesize content, date, psid, refsign, type, uduty, uid, uname, uphoto, usign;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.psid forKey:@"psid"];
    [encoder encodeObject:self.refsign forKey:@"refsign"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.uduty forKey:@"uduty"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.uname forKey:@"uname"];
    [encoder encodeObject:self.uphoto forKey:@"uphoto"];
    [encoder encodeObject:self.usign forKey:@"usign"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.content = [decoder decodeObjectForKey:@"content"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.psid = [decoder decodeObjectForKey:@"psid"];
        self.refsign = [decoder decodeObjectForKey:@"refsign"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.uduty = [decoder decodeObjectForKey:@"uduty"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.uname = [decoder decodeObjectForKey:@"uname"];
        self.uphoto = [decoder decodeObjectForKey:@"uphoto"];
        self.usign = [decoder decodeObjectForKey:@"usign"];
    }
    return self;
}

+ (SquareInfo *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    SquareInfo *instance = [[SquareInfo alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

@end

//
//  ModelGenerator.m
//  QXH
//
//  Created by ZhaoLilong on 5/26/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "ModelGenerator.h"

@implementation ModelGenerator

- (UserInfoModel *)json2UserInfo:(NSDictionary *)obj
{
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model.displayname = [obj objectForKey:@"displayname"];
    model.signature = [obj objectForKey:@"signature"];
    model.title = [obj objectForKey:@"title"];
    model.address = [obj objectForKey:@"address"];
    model.domicile = [obj objectForKey:@"domicile"];
    model.introduce = [obj objectForKey:@"introduce"];
    model.comname = [obj objectForKey:@"comname"];
    model.comdesc = [obj objectForKey:@"comdesc"];
    model.comaddress = [obj objectForKey:@"comaddress"];
    model.comurl = [obj objectForKey:@"comurl"];
    model.induname = [obj objectForKey:@"induname"];
    model.indudesc = [obj objectForKey:@"indudesc"];
    model.schoolname = [obj objectForKey:@"schoolname"];
    model.schooltype = [obj objectForKey:@"schooltype"];
    model.sex = [obj objectForKey:@"sex"];
    model.photo = [obj objectForKey:@"photo"];
    model.email = [obj objectForKey:@"email"];
    model.tags = [obj objectForKey:@"tags"];
    model.attentiontags = [obj objectForKey:@"attentiontags"];
    model.hobbies = [obj objectForKey:@"hobbies"];
    model.educations = [obj objectForKey:@"educations"];
    model.usertype = [obj objectForKey:@"usertype"];
    model.gold = [obj objectForKey:@"gold"];
    model.level = [obj objectForKey:@"level"];
    model.configure = [obj objectForKey:@"configure"];
    model.status = [obj objectForKey:@"status"];
    return model;
}

@end

//
//  ModelGenerator.m
//  QXH
//
//  Created by ZhaoLilong on 5/26/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "ModelGenerator.h"

@implementation ModelGenerator

+ (UserInfoModel *)json2UserInfo:(NSDictionary *)obj
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

+ (NSMutableArray *)json2InfoList:(NSDictionary *)obj
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *list = [obj objectForKey:@"list"];
    for (int i = 0; i < [list count]; i++) {
        InfoModel *model = [[InfoModel alloc] init];
        model.artid = [list[i] objectForKey:@"artid"];
        model.sid = [list[i] objectForKey:@"sid"];
        model.sname = [list[i] objectForKey:@"sname"];
        model.sphoto = [list[i] objectForKey:@"sphoto"];
        model.date = [list[i] objectForKey:@"date"];
        model.title = [list[i] objectForKey:@"title"];
        model.artimgs = [list[i] objectForKey:@"artimgs"];
        model.content = [list[i] objectForKey:@"content"];
        model.authflag = [list[i] objectForKey:@"authflag"];
        model.browsetime = [list[i] objectForKey:@"browsetime"];
        [array addObject:model];
    }
    return array;
}

+ (InfoDetailModel *)json2InfoDetail:(NSDictionary *)obj
{
    InfoDetailModel *model = [[InfoDetailModel alloc] init];
    model.sid = [obj objectForKey:@"sid"];
    model.sname = [obj objectForKey:@"sname"];
    model.sphoto = [obj objectForKey:@"sphoto"];
    model.date = [obj objectForKey:@"date"];
    model.title = [obj objectForKey:@"title"];
    model.tags = [obj objectForKey:@"tags"];
    model.authflag = [obj objectForKey:@"authflag"];
    model.artimages = [obj objectForKey:@"artimages"];
    model.content = [obj objectForKey:@"content"];
    model.refereesign = [obj objectForKey:@"refereesign"];
    model.author = [obj objectForKey:@"autbhor"];
    model.browsetime = [obj objectForKey:@"browsetime"];
    model.collecttime = [obj objectForKey:@"collecttime"];
    model.sharetime = [obj objectForKey:@"sharetime"];
    model.relaytime = [obj objectForKey:@"relaytime"];
    model.commenttime = [obj objectForKey:@"commenttime"];
    model.laud = [obj objectForKey:@"laud"];
    return model;
}

@end

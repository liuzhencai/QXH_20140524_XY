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

+ (NSMutableArray *)json2SquareInfoList:(NSDictionary *)obj
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *list = [obj objectForKey:@"list"];
    for (int i = 0; i < [list count]; i++) {
        SquareInfo *info = [[SquareInfo alloc] init];
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
        model.contentlength = [[list[i] objectForKey:@"contentlength"] integerValue];
        model.type = [list[i] objectForKey:@"type"];
        info.type = 1;
        info.content = model;
        [array addObject:info];
    }
    return array;
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
        model.contentlength = [[list[i] objectForKey:@"contentlength"] integerValue];
        model.type = [list[i] objectForKey:@"type"];
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
    model.authflag = [NSString stringWithFormat:@"%@",[obj objectForKey:@"authflag"]];
    model.artimages = [obj objectForKey:@"artimages"];
    model.content = [obj objectForKey:@"content"];
    model.refereesign = [obj objectForKey:@"refereesign"];
    model.author = [obj objectForKey:@"autbhor"];
    model.browsetime = [NSString stringWithFormat:@"%@",[obj objectForKey:@"browsetime"]];
    model.collecttime = [NSString stringWithFormat:@"%@",[obj objectForKey:@"collecttime"]];
    model.sharetime = [NSString stringWithFormat:@"%@",[obj objectForKey:@"sharetime"]];
    model.relaytime = [NSString stringWithFormat:@"%@",[obj objectForKey:@"relaytime"]];
    model.commenttime = [NSString stringWithFormat:@"%@",[obj objectForKey:@"commenttime"]];
    model.laud = [[obj objectForKey:@"laud"] integerValue];
    return model;
}


+ (NSMutableArray *)json2TribeList:(NSDictionary *)obj
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *list = [obj objectForKey:@"list"];
    for (int i = 0; i < [list count]; i++) {
        MyTribeModel *model = [[MyTribeModel alloc] init];
        model.tribeid =  [list[i] objectForKey:@"tribeid"];
        model.tribename = [list[i] objectForKey:@"tribename"];
        model.photo = [list[i] objectForKey:@"photo"];
        model.signature = [list[i] objectForKey:@"signature"];
        model.creater = [list[i] objectForKey:@"creater"];
        model.creatername = [list[i] objectForKey:@"creatername"];
        model.authflag = [list[i] objectForKey:@"authflag"];
        model.maxcount = [list[i] objectForKey:@"maxcount"];
        model.nowcount = [list[i] objectForKey:@"nowcount"];
        model.address = [list[i] objectForKey:@"address"];
        model.startdate = [list[i] objectForKey:@"startdate"];
        model.enddate = [list[i] objectForKey:@"enddate"];
        [array addObject:model];
    }
    return array;
}

+ (NSMutableArray *)json2VistorList:(NSDictionary *)obj
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *list = [obj objectForKey:@"list"];
    for (int i = 0; i < [list count]; i++) {
        VistorModel *model = [[VistorModel alloc] init];
        model.userid =  [list[i] objectForKey:@"userid"];
        model.username =  [list[i] objectForKey:@"username"];
        model.photo =  [list[i] objectForKey:@"photo"];
        model.displayname =  [list[i] objectForKey:@"displayname"];
        model.signature =  [list[i] objectForKey:@"signature"];
        model.remark =  [list[i] objectForKey:@"remark"];
        model.usertype =  [list[i] objectForKey:@"usertype"];
        model.level =  [list[i] objectForKey:@"level"];
        model.date = [list[i] objectForKey:@"date"];
        [array addObject:model];
    }
    return array;
}

+ (NSMutableArray *)json2CommentList:(NSDictionary *)obj
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *list = [obj objectForKey:@"list"];
    for (int i = 0; i < [list count]; i++) {
        InfoCommentModel *model = [[InfoCommentModel alloc] init];
        model.comment =  [list[i] objectForKey:@"comment"];
        model.ctid =  [[list[i] objectForKey:@"ctid"] integerValue];
        model.sid =  [[list[i] objectForKey:@"sid"] integerValue];
        model.date = [list[i] objectForKey:@"date"];
        model.sname =  [list[i] objectForKey:@"sname"];
        model.sphoto =  [list[i] objectForKey:@"sphoto"];
        [array addObject:model];
    }
    return array;
}

+ (NSMutableArray *)json2SquareList:(NSDictionary *)obj
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *list = [obj objectForKey:@"list"];
    for (int i = 0; i < [list count]; i++) {
        SquareInfo *info = [[SquareInfo alloc] init];
        NSDictionary *subDict = [list[i] objectForKey:@"content"];
        if (subDict) {
            /*
             有时服务器返回这样数据
             {
             date = "2014-08-15 23:51:47";
             psid = 315;
             refsign = "";
             type = 1;
             uduty = "";
             uid = 29;
             uname = "";
             uphoto = "";
             usign = "";
             }
             */
            
            switch ([[list[i] objectForKey:@"type"] integerValue]) {
                case 0:
                case 1:
                case 2:
                case 4:
                case 5:
                {
                    InfoModel *model = [[InfoModel alloc] init];
                    model.artid = [subDict objectForKey:@"artid"];
                    model.sid = [subDict objectForKey:@"sid"];
                    model.sname = [subDict objectForKey:@"sname"];
                    model.sphoto = [subDict objectForKey:@"sphoto"];
                    model.date = [subDict objectForKey:@"date"];
                    model.title = [subDict objectForKey:@"title"];
                    model.artimgs = [subDict objectForKey:@"artimgs"];
                    model.content = [subDict objectForKey:@"content"];
                    model.authflag = [subDict objectForKey:@"authflag"];
                    model.browsetime = [subDict objectForKey:@"browsetime"];
                    model.contentlength = [[subDict objectForKey:@"contentlength"] integerValue];
                    info.content = model;
                }
                    break;
                case 3:
                {
                    SquareActInfo *model = [[SquareActInfo alloc] init];
                    model.actid = [subDict objectForKey:@"actid"];
                    model.actname = [subDict objectForKey:@"actname"];
                    model.photos = [subDict objectForKey:@"photos"];
                    model.signupbegindate = [subDict objectForKey:@"signupbegindate"];
                    model.signupenddate = [subDict objectForKey:@"signupenddate"];
                    model.begindate = [subDict objectForKey:@"begindate"];
                    model.enddate = [subDict objectForKey:@"enddate"];
                    model.actaddr = [subDict objectForKey:@"actaddr"];
                    model.maxcount = [subDict objectForKey:@"maxcount"];
                    model.nowcount =  [subDict objectForKey:@"nowcount"];
                    model.folcount = [subDict objectForKey:@"focount"];
                    model.comefrom = [subDict objectForKey:@"comefrom"];
                    model.creatername = [subDict objectForKey:@"creatername"];
                    model.tags = [subDict objectForKey:@"tags"];
                    model.desc = [subDict objectForKey:@"desc"];
                    model.acttype = [subDict objectForKey:@"acttype"];
                    info.content = model;
                }
                    break;
                default:
                    break;
            }
            info.date = [list[i] objectForKey:@"date"];
            info.psid = [[list[i] objectForKey:@"psid"] integerValue];
            info.refsign = [list[i] objectForKey:@"refsign"];
            info.type = [[list[i] objectForKey:@"type"] integerValue];
            info.uid = [[list[i] objectForKey:@"uid"] integerValue];
            info.uname = [list[i] objectForKey:@"uname"];
            info.uphoto = [list[i] objectForKey:@"uphoto"];
            info.usign = [list[i] objectForKey:@"usign"];
            info.uduty = [list[i] objectForKey:@"uduty"];
            [array addObject:info];
        }
<<<<<<< HEAD
        info.date = [list[i] objectForKey:@"date"];
        info.psid = [[list[i] objectForKey:@"psid"] integerValue];
        info.refsign = [list[i] objectForKey:@"refsign"];
        info.type = [[list[i] objectForKey:@"type"] integerValue];
        info.uid = [[list[i] objectForKey:@"uid"] integerValue];
        info.uname = [list[i] objectForKey:@"uname"];
        info.uphoto = [list[i] objectForKey:@"uphoto"];
        info.usign = [list[i] objectForKey:@"usign"];
        info.uduty = [list[i] objectForKey:@"uduty"];
        if ([[list[i] objectForKey:@"type"] integerValue] == 5) {
            if (![subDict objectForKey:@"artid"]) {
                break;
            }
        }
        [array addObject:info];
=======
        
>>>>>>> e76c02ab949cd0b10273bbf427d4f58937a9dc56
    }
    return array;
}

+ (NSMutableArray *)json2CodeSheet:(NSDictionary *)obj
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *list = [obj objectForKey:@"list"];
    for (int i = 0; i < [list count]; i++) {
        CodeSheetObject *model = [[CodeSheetObject alloc] init];
        model.name =  [list[i] objectForKey:@"name"];
        model.code =  [list[i] objectForKey:@"code"];
        [array addObject:model];
    }
    return array;
}

+ (NSMutableArray *)json2AskInfo:(NSDictionary *)obj
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *list = [obj objectForKey:@"list"];
    for (int i = 0; i < [list count]; i++) {
        AskInfoModel *model = [[AskInfoModel alloc] init];
        model.artid =  [list[i] objectForKey:@"artid"];
        model.artimgs =  [list[i] objectForKey:@"artimgs"];
        model.authflag = [list[i] objectForKey:@"authflag"];
        model.browsetime = [list[i] objectForKey:@"browsetime"];
        model.content = [list[i] objectForKey:@"content"];
        model.contentlength = [list[i] objectForKey:@"contentlength"];
        model.date = [list[i] objectForKey:@"date"];
        model.sid = [list[i] objectForKey:@"sid"];
        model.sname = [list[i] objectForKey:@"sname"];
        model.sphoto = [list[i] objectForKey:@"sphoto"];
        model.title = [list[i] objectForKey:@"title"];
        [array addObject:model];
    }
    return array;
}

@end

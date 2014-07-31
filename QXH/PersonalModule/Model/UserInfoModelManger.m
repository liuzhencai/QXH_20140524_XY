//
//  UserInfoModelManger.m
//  QXH
//
//  Created by liuzhencai on 14-6-10.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  管理用户信息

#import "UserInfoModelManger.h"
#import "UserInfoModel.h"

@implementation UserInfoModelManger
@synthesize userInfo,uerArrayDic;
@synthesize Iconimage,MeUserId;


static   UserInfoModelManger* instance;

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+(UserInfoModelManger*)sharUserInfoModelManger
{
    if (!instance) {
        instance = [[UserInfoModelManger alloc]init];
    }
    
    return instance;
}

- (void)getUserInfo:(void (^)(UserInfoModel* Userinfo))backUserInfo
{
    if (!userInfo) {
        //        userInfo = [[UserInfoModel alloc]init];
        
        if (!uerArrayDic)
        {
           uerArrayDic = [[NSMutableDictionary alloc]init];
        }
        
        NSNumber* auserid = [defaults objectForKey:@"userid"] ;
        NSString* userid = [NSString stringWithFormat:@"%d",[auserid intValue]];
        self.MeUserId = userid;
        [DataInterface getUserInfo:userid withCompletionHandler:^(NSMutableDictionary *dict) {
            
            [self ByDictonary:dict addUserIn:^(UserInfoModel* buserinfo)
             {
 
//                 if (!buserinfo.iconImageview) {
//                   self.userInfo = nil;
//                 }else{
                   self.userInfo = buserinfo;
                    /*添加进入本地缓存数组*/
                    [uerArrayDic setObject:buserinfo forKey:userid];
//                 }
                 
                 backUserInfo(self.userInfo);
                 
             }];
        }];
    }else
    {
     backUserInfo(self.userInfo);   
    }
    
}

- (UserInfoModel*)getMe
{
    return self.userInfo;
}


- (void)getOtherUserInfo:(NSString *)userid withCompletionHandler:(UserInfoModel* (^) (UserInfoModel*))backUserinfo
{
    UserInfoModel* auerinfo = nil;
    if (!uerArrayDic) {
        uerArrayDic = [[NSMutableDictionary alloc]init];
    }else{
        auerinfo = (UserInfoModel*)[uerArrayDic valueForKey:userid];
    }
    
    if (!auerinfo) {
        /*如果没有则创建一个*/
//        auerinfo = [[UserInfoModel alloc]init];
        
        [DataInterface getUserInfo:userid withCompletionHandler:^(NSMutableDictionary *dict) {
           UserInfoModel* TempUerinfo = (UserInfoModel*)[uerArrayDic valueForKey:userid];
            if (TempUerinfo) {
                backUserinfo(auerinfo);
            }

            [self ByDictonary:dict addUserIn:^(UserInfoModel* buserinfo)
             {
                 /*添加进入本地缓存数组*/
                 [uerArrayDic setObject:buserinfo forKey:userid];
                 backUserinfo(buserinfo);
             }];

        }];
//        return nil;
    }else{
      backUserinfo(auerinfo);
    }
    
//    return auerinfo;
}

/*添加联系人资料*/
- (void)ByDictonary:(NSMutableDictionary*)dict addUserIn:(void (^)(UserInfoModel*))backUserInfo
{
    /*
     opercode:"0105",		//operCode为0105，客户端通过该字段确定事件
     statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
     info:"获取成功",		//获取成功/失败!
     displayname:"张三",		//昵称
     phone:"1234",			//电话号码
     signature:"这个是签名...",	//签名
     title:"头衔",			//头衔职称
     degree:"教授",			//学位
     address:"籍贯编码",		//籍贯编码
     domicile:"居住地编码",		//居住地编码
     introduce:"自我介绍",		//自我介绍
     comname:"公司名称",		//公司名称
     comdesc:"公司描述",		//公司描述
     comaddress:"公司地址",		//公司地址
     comurl:"http://wz.com",		//公司网址
     induname:"行业名称",		//行业名称
     indudesc:"行业描述",		//行业描述
     schoolname:"学校名称",		//学校名称
     schooltype:"学校类型",		//学校类型
     sex:"0"	,			//0为保密，1为男，2为女
     photo:"1.jpg",			//头像
     email:"123@qq.com",		//用户邮箱
     tags:"标签1，标签2",		//用户标签
     attentiontags:"标签1，标签2",	//关注标签
     hobbies:"爱好1，爱好2",		//爱好
     educations:"经历1，经历2",	//教育经历
     honours:"荣誉1，荣誉2",		//荣誉
     enterprises:"企业信息1，信息2",	//企业信息
     usertype:"0",			//0为普通用户
     gold:"1000",			//金币数量
     level:"1",			//用户级别
     configure:"a:0;b:1,c:2",	//客户端配置相关信息（需客户端人员协定之后定义公共设置信息）
     status:2			//0为正常用户，1为禁用用户，2为临时用户
     */
    /*先获取头像,获取自己和获取部落中聊天的其他人头像参数不一样*/
//    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minimumHeight, minimumHeight)];
//    //            [iconImage circular];
//    
//    iconImage.image = [self getIcon:dict[@"photo"]];
//    [iconImage setImageWithURL:IMGURL(dict[@"photo"]) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
//     {
//         if (!error || image) {
    
//            UIImageView *aconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minimumHeight, minimumHeight)];
//            auserInfo.iconImageview = aconImage;
//            NSURL *url = IMGURL(dict[@"photo"]);
//            [auserInfo.iconImageview setImageWithURL:url placeholderImage:nil];
//             aconImage.image = [self getIcon:dict[@"photo"]];
//             auserInfo.iconImageview = aconImage;
            UserInfoModel* auserInfo = [[UserInfoModel alloc]init];
             auserInfo.displayname = [dict valueForKey:@"displayname"];
             auserInfo.signature = [dict valueForKey:@"signature"];
             auserInfo.phone = [dict valueForKey:@"phone"];
             auserInfo.title = [dict valueForKey:@"title"];
             auserInfo.degree = [dict valueForKey:@"degree"];
             auserInfo.address = [dict valueForKey:@"address"];
             auserInfo.domicile = [dict valueForKey:@"domicile"];
             auserInfo.introduce = [dict valueForKey:@"introduce"];
             auserInfo.comname = [dict valueForKey:@"comname"];
             auserInfo.comdesc = [dict valueForKey:@"comdesc"];
             auserInfo.comaddress = [dict valueForKey:@"comaddress"];
             auserInfo.comurl = [dict valueForKey:@"comurl"];
             auserInfo.induname = [dict valueForKey:@"induname"];
             auserInfo.indudesc = [dict valueForKey:@"indudesc"];
             auserInfo.schoolname = [dict valueForKey:@"schoolname"];
             auserInfo.schooltype = [dict valueForKey:@"schooltype"];
             auserInfo.sex = [dict valueForKey:@"sex"];
             auserInfo.photo = [dict valueForKey:@"photo"];
             auserInfo.email = [dict valueForKey:@"email"];
             auserInfo.tags = [dict valueForKey:@"tags"];
             auserInfo.attentiontags = [dict valueForKey:@"attentiontags"];
             auserInfo.hobbies = [dict valueForKey:@"hobbies"];
             auserInfo.educations = [dict valueForKey:@"educations"];
             auserInfo.honours = [dict valueForKey:@"honours"];
            NSNumber* ausertayp = (NSNumber*)[dict valueForKey:@"usertype"];
             auserInfo.usertype = [NSString stringWithFormat:@"%d",[ausertayp integerValue]];
             auserInfo.gold = [dict valueForKey:@"gold"];
             auserInfo.level = [dict valueForKey:@"level"];
             auserInfo.configure = [dict valueForKey:@"configure"];
             auserInfo.status = [dict valueForKey:@"status"];
             
             backUserInfo(auserInfo);
//         }
//      
//     }];


    
  
    
//    return auserInfo;
}


//- (UIImage*)getIcon:(NSString*)photo
//{
//    // 组合一个搜索字符串
////      NSMutableData* adata = [[NSMutableData alloc] init];
////    self.Icondata = adata;
//    NSURL *url = IMGURL(photo);
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    // 發送同步請求, 這裡得returnData就是返回得數據楽
//    // 發送同步請求, 這裡得returnData就是返回得數據楽
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
//                                               returningResponse:nil error:nil];
//    self.Iconimage = [UIImage imageWithData:returnData];
//    return self.Iconimage;
////    //发起请求，定义代理
////    [NSURLConnection connectionWithRequest:request delegate:self];
//}
//
//// 分批返回数据
//- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
//    [Icondata appendData:data];
////    NSLog(@"分批返回=%@", _data);
//}
//// 数据完全返回完毕
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
////    NSString *dataString =  [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
//    NSLog(@"接收完毕=%@");
//    UIImage* aimage = [UIImage imageWithData:self.Icondata];
//    
//}

//// 网络错误时触发
- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
    DebugLog(@"获取图片错误==%@",error);
}

- (void)cleanUser
{
    userInfo = nil;
    MeUserId = nil;
}
@end

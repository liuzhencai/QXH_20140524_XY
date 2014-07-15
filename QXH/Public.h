//
//  Public.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#ifndef QXH_Public_h
#define QXH_Public_h

/*******************************************
 Network Connection Config 网络信息配置
 ********************************************/

#define HOST_URL @"180.97.46.40:8070"

#define SERVICE_URL @"qxh/mobile/qxhService.action"

#define SOCKET_SERVER @"180.97.46.40"

#define SOCKET_PORT 9002

#define HEART_BEAT 30

#define IMG_URL @"http://"HOST_URL@"/qxh/fileupload/images/"

#define IMGURL(x) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_URL,x]]

#define INF_URL @"http://"HOST_URL@"/qxh/articleAction_artilce.action?artid="

#define INF_SHARE_URL(x) [NSString stringWithFormat:@"%@%@",INF_URL,x]

#define INFURL(x) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",INF_URL,x]]

/*******************************************
 Custom Block Callback 自定义block回调
 ********************************************/
typedef void (^FinishLoadBlock)(NSData *data);

typedef void (^DescriptionBlock)(NSString *desc);

typedef void (^Completion)(id data);

typedef void (^ListCallback)(NSMutableArray *list);

typedef void (^DictCallback) (NSMutableDictionary *dict);

/*******************************************
 File Cached Directory 文件缓存目录
 ********************************************/

#define MR_CACHE_PATH [kDocuments stringByAppendingPathComponent:CACHE_PATH]

#define kDocuments [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define CACHE_PATH @"com.mrsource.cache"

#define APP_VER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define ORIGIN_VAL @"------"

/*******************************************
 Square Module Constant 广场模块常量定义
 ********************************************/
#define SQUARE_LIST_PIC_SIZE 48.f

#define SQUARE_DETAIL_CONTENT_FONT 13.f

#define SQUARE_DETAIL_CONTENT_WIDTH 300.f

#define SQUARE_DETAIL_PIC_SIZE 67.5

#define SQUARE_DETAIL_PICINF_SIZE 50

/*******************************************
 Umeng Statistics Constant 友盟统计常量
 *******************************************/
#define TYPE_LOOK_BANNER  @"type_look_banner" // 看广告条

#define TYPE_LOOK_NEWS    @"type_look_news"   // 看资讯

#define TYPE_LOOK_SEARCH_USER @"type_look_search_user"  // 看人

#define TYPE_LOOK_GROUP @"type_look_group" // 看部落

#define TYPE_LOOK_ACTIVITY @"type_look_activity" // 看活动

#define TYPE_LOOK_PUBLIC @"type_look_public" // 看广场

#define TYPE_LOOK_STUDIO @"type_look_studio"  // 看直播间

#define TYPE_LOOK__DAY_QUES @"type_look__day_ques" // 看问道

#define TYPE_LOOK_INFLUENCE @"type_look_studio" // 看影响力

#define TYPE_LOOK_NEWS_TIME @"type_look_news_time" // 看咨询时间

#define TYPE_LOOK_USER @"type_look_user" // 看人

#endif

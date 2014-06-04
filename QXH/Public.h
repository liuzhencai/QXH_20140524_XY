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

#define IMAGE_UPLOAD_URL @""

#define SOCKET_SERVER @"180.97.46.40"

#define SOCKET_PORT 9002

#define HEART_BEAT 60


/*******************************************
 Custom Block Callback 自定义block回调
 ********************************************/
typedef void(^FinishLoadBlock)(NSData *);

typedef void(^Completion)(id data);

typedef void (^ListCallback)(NSMutableArray *list);

typedef void (^DictCallback) (NSMutableDictionary *dict);

/*******************************************
 File Cached Directory 文件缓存目录
 ********************************************/

#define MR_CACHE_PATH [kDocuments stringByAppendingPathComponent:CACHE_PATH]

#define kDocuments [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define CACHE_PATH @"com.mrsource.cache"

#define APP_VER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#endif

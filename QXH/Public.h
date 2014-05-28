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


// 自定义回调函数快

typedef void (^ListCallback)(NSMutableArray *list);

typedef void (^DictCallback) (NSMutableDictionary *dict);

/*******************************************
 File Cached Directory 文件缓存目录
 ********************************************/

#define MR_CACHE_PATH [kDocuments stringByAppendingPathComponent:CACHE_PATH]

#define kDocuments [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define CACHE_PATH @"com.mrsource.cache"

#endif

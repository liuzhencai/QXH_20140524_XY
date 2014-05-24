//
//  HttpRequest.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpServiceEngine.h"

@implementation HttpRequest

+ (void)requestLatestVersionNoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_LATEST_VER_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestUserInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_USR_INF_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)modifyUserInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_MOD_INF_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)getFriendWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_FRI_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestAddFriendWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_FRI_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)addFriendConfirmWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_FRI_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestCityCodeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_CITY_CODE_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestTribeListWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_TRIBE_CODE_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)createTribeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_CREATE_TRIBE_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)modifyTribeInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_MOD_TRIBE_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestTribeInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_TRIBE_INF_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestJoinTribeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_JOIN_TRIBE_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)dealJoinTribeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_DEAL_JOIN_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestTribeMemberWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_TRIBE_MEMEBER_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)quitTribeWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_QUIT_TRIBE_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)querySquareWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_QUERY_SQUA_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestSquareInfoWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_SQUA_INFO_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestSquareDetailWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_SQUA_DETAIL_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestSquareRemarkWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_SQUA_REMA_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestRemarkListWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_REMA_LIST_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestSquareCollectionWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_SQUA_COLL_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestActivityListWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_ACT_LIST_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)createActivityWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_ACT_CREATE_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestActivityDetailWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_ACT_DETAIL_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)joinActivityWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_JOIN_ACT_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)quitActivityWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_QUIT_ACT_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)requestChatHistoryWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_CHAT_HIST_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}

+ (void)shareContentWithParams:(NSMutableDictionary *)params andCompletionHandler:(DictCallback)callback;
{
    [[HttpServiceEngine sharedEngine] sendDataWithUrl:REQ_SHARE_COM_URL andMethod:nil andData:params completionHandler:^(NSInteger statusCode, id object) {
        if ([object objectForKey:@"0200"]) {
            callback(object);
        }else{
            callback(nil);
        }
    } errorHandler:^(NSError *error) {
        callback(nil);
    }];
}


@end

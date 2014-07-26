//
//  DBManager.m
//  QXH
//
//  Created by ZhaoLilong on 14-7-22.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "DBManager.h"

static DBManager *dbManager;

@interface DBManager ()
{
    FMDatabase *db;
}
@end

@implementation DBManager

+ (instancetype)sharedManager
{
    @synchronized(self){
        if (dbManager == nil) {
            dbManager = [[self alloc] init];
        }
    }
    return dbManager;
}

- (void)initDb:(NSString *)path
{
    db = [[FMDatabase alloc] initWithPath:path];
}

- (id)init
{
    if (self == [super init]) {
        NSString *dbFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"qxh.sqlite"];
        
        // 判断当前沙盒中是否存在数据库文件
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbFilePath]) {
            // 如果不存在数据库文件，则将bundle中的数据库文件拷贝至沙盒中
            NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:@"qxh" ofType:@"sqlite"];
            NSError *error;
            if([[NSFileManager defaultManager] copyItemAtPath:dbBundlePath toPath:dbFilePath error:&error]){
                [self initDb:dbFilePath];
            }
        }else{
            // 如果存在数据库文件，则直接读取数据库文件
            [self initDb:dbFilePath];
        }
    }
    return self;
}

- (void)saveChatMess:(ChatMess *)mess
{
    NSString *sql = @"merge into chat_mess_tbl a using (select ? as cid, ? as uid, ? as msgid, ? as sid, ? as type, ? as fromid, ? as fromname, ? as fromphotoid, ? as dttime, ? as dtdate, ? as contenttext, ? as contentres, ? as state, ? as targetid, ? as targetname, ? as targetphoto, ? as targettype) b on (a.msgid = b.msgid) when matched then update set a.cid = b.cid; a.uid = b.uid, a.msgid = b.msgid, a.sid = b.sid, a.type = b.type, a.fromid = b.fromid, a.fromname = b.fromname, a.fromphotoid = b.fromphotoid, a.dttime = b.dttime, a.dtdate = b.dtdate, a.contenttext = b.contenttext, a.contentres = b.contentres, a.state = b.state, a.targetid = b.targetid, a.targetname = b.targetname, a.targetphoto = b.targetphoto, a.targettype = b.targettype when not matched then insert (a.cid, a.uid, a.msgid, a.sid, a.type, a.fromid, a.fromname, a.fromphotoid, a.dttime, a.dtdate, a.contenttext, a.contentres, a.state, a.targetid, a.targetname, a.targetphoto, a.targettype) values (b.cid, b.uid, b.msgid, b.sid, b.type, b.fromid, b.fromname, b.fromphotoid, b.dttime, b.dtdate, b.contenttext, b.contentres, b.state, b.targetid, b.targetname, b.targetphoto, b.targettype)";
    [db executeUpdate:sql];
}

- (NSMutableArray *)getChatMess:(NSString *)start maxCount:(NSString *)count lastMessId:(NSString *)messid
{
    NSMutableArray *result  = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select *from chat_mess_tbl where msgid = %@ limit %@, %@", messid, start, count];
    FMResultSet *rs = [db executeQuery:sql];
    while (rs.next) {
        ChatMess *obj = [[ChatMess alloc] init];
        obj.cid= [rs objectForColumnName:@"cid"];
        obj.uid= [rs objectForColumnName:@"uid"];
        obj.msgid= [rs objectForColumnName:@"msgid"];
        obj.sessionid = [rs objectForColumnName:@"sid"];
        obj.type= [rs objectForColumnName:@"type"];
        obj.fromid= [rs objectForColumnName:@"fromid"];
        obj.fromname= [rs objectForColumnName:@"fromname"];
        obj.fromphotoid= [rs objectForColumnName:@"fromphotoid"];
        obj.dttime= [rs objectForColumnName:@"dttime"];
        obj.dtdate= [rs objectForColumnName:@"dtdate"];
        obj.contenttext = [rs objectForColumnName:@"contenttext"];
        obj.contentres= [rs objectForColumnName:@"contentres"];
        obj.state = [rs objectForColumnName:@"state"];
        obj.targetid = [rs objectForColumnName:@"targetid"];
        obj.targetname = [rs objectForColumnName:@"targetname"];
        obj.targetphoto = [rs objectForColumnName:@"targetphoto"];
        obj.targettype = [rs objectForColumnName:@"targettype"];
        [result addObject:obj];
    }
    return result;
}

- (BOOL)clearAllUserData
{
    NSString *sql = @"delete from chat_mess_tbl";
    return [db executeUpdate:sql];
}

@end

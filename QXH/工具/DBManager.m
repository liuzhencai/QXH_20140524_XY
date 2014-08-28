//
//  DBManager.m
//  QXH
//
//  Created by ZhaoLilong on 14-7-22.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "DBManager.h"



#define KListName  @"chat_mess_tbl"
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
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        //dbPath： 数据库路径，在Document中。
        NSString *dbFilePath = [documentDirectory stringByAppendingPathComponent:@"qxhChat.db"];
        
        // 判断当前沙盒中是否存在数据库文件
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbFilePath]) {
            // 如果不存在数据库文件，则将bundle中的数据库文件拷贝至沙盒中
//            [self initDb:dbFilePath];
             db = [[FMDatabase alloc] initWithPath:dbFilePath];
            BOOL res1 =  [db open] ;
            if (!res1) {
                NSLog(@"error when open db table");
            
            } else {
                NSLog(@"success to open db table");
            }
          BOOL resu  =  [db executeUpdate:@"CREATE TABLE chat_mess_tbl (msgid long,type int,fromid long,fromname text,fromphotoid long,dtdate text,contenttext text,targetid long,targetname text,targetphoto text,messagetype int)"];
            if (!resu) {
                NSLog(@"创建数据库表失败");
            }
            
        }else{
            // 如果存在数据库文件，则直接读取数据库文件
             db = [[FMDatabase alloc] initWithPath:dbFilePath];
//            [self initDb:dbFilePath];
        }
        
        BOOL res1 =  [db open] ;
        if (!res1) {
            NSLog(@"error when open db table");
            
        } else {
            NSLog(@"success to open db table");
            
        }
    }
    return self;
}

- (void)saveChatMess:(ChatMess *)mess
{
   
//    BOOL res1 =  [db open] ;
//    if (!res1) {
//        NSLog(@"error when open db table");
//          return ;
//    } else {
//        NSLog(@"success to open db table");
//    }
    

      NSString *sql = @"insert into chat_mess_tbl (msgid,type,fromid,fromname,fromphotoid,dtdate,contenttext,targetid,targetname,targetphoto,messagetype) values (?,?,?,?,?,?,?,?,?,?,?)";



      BOOL res =  [db executeUpdate:sql,mess.msgid,mess.type,mess.fromid,mess.fromname,mess.fromphotoid,mess.dtdate,mess.contenttext,mess.targetid,mess.targetname,mess.targetphoto,mess.messagetype];


    if (!res) {
        NSLog(@"error when insert db table");
          return ;
    } else {
        NSLog(@"success to insert db table");
    }
//    [db close];
}

- (NSMutableArray *)getChatMessStart:(NSString *)start maxCount:(NSString *)count Andtargetid:(NSString *)targetid
{
//    BOOL res1 =  [db open] ;
//    if (!res1) {
//        NSLog(@"error when open db table");
//        return nil;
//    } else {
//        NSLog(@"success to open db table");
//      
//    }
    
    NSMutableArray *result  = [[NSMutableArray alloc] init];

     NSString *sql = [NSString stringWithFormat:@"select * from  chat_mess_tbl  where targetid = %@ order by dtdate desc limit %@, %@", targetid, start, count];
    FMResultSet *rs = [db executeQuery:sql];
    
    
    while (rs.next) {
      
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        // 消息唯一标示
        dic[@"messid"] = [rs objectForColumnName:@"msgid"];
        // 消息类型
        dic[@"sendtype"] = [rs objectForColumnName:@"type"];
        
        // 来自id标示
        dic[@"senderid"] = [rs objectForColumnName:@"fromid"];
        
        // 来自name标示
        dic[@"sendername"] = [rs objectForColumnName:@"fromname"];
        
        // 来自图片标示
        dic[@"senderphoto"] = [rs objectForColumnName:@"fromphotoid"];
        
        
        // 消息日期
        dic[@"date"] = [rs objectForColumnName:@"dtdate"];
        
        // 内容文本
        dic[@"mess"] = [rs objectForColumnName:@"contenttext"];
        
        // 目标id标示
        dic[@"tribeid"] = [rs objectForColumnName:@"targetid"];
        
        // 目标name标示
        dic[@"tribename"] = [rs objectForColumnName:@"targetname"];
        
        // 目标图片
        dic[@"tribephoto"]= [rs objectForColumnName:@"targetphoto"];
        //消息类型
        dic[@"messtype"] = [rs objectForColumnName:@"messagetype"];
        
        
        [result addObject:dic];
    }
//    [db close];
    return result;
}

- (BOOL)clearAllUserData
{
    /*没有打开时无法删除*/
//    BOOL res1 =  [db open] ;
//    if (!res1) {
//        NSLog(@"error when open db table");
//        
//    } else {
//        NSLog(@"success to open db table");
//        
//    }
    NSString *sql = @"delete from chat_mess_tbl";
    return [db executeUpdate:sql];
}

- (void)changeByDate:(NSString*)adate andMessid:(NSNumber*)messid
{
//    BOOL res1 =  [db open] ;
//    if (!res1) {
//        NSLog(@"error when open db table");
//        return ;
//    } else {
//        NSLog(@"success to open db table");
//        
//    }
    
   BOOL result =  [db executeUpdate:@"UPDATE chat_mess_tbl SET msgid = ? WHERE dtdate = ? ",messid,adate];
    if (!result) {
     NSLog(@"修改数据库失败");
    }else{
     NSLog(@"修改数据库成功");
    }
    
//    [db close];
}

/*查找*/
- (BOOL)Search:(NSString*)data
{
//    BOOL res1 =  [db open] ;
//    if (!res1) {
//        NSLog(@"error when open db table");
//       
//    } else {
//        NSLog(@"success to open db table");
//        
//    }
//    data = @"20140818123";
    
   FMResultSet* rs=[db executeQuery:@"SELECT * FROM chat_mess_tbl WHERE dtdate = ?",data];
    while ([rs next]){
//        [db close];
        return YES;
    }
    
    
    
   
    
//    [db close];
    return NO;
}
@end

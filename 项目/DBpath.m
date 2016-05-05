//
//  DBpath.m
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

#import "DBpath.h"
#import "FMDatabase.h"
#define sqlite @"UserInformation.sqlite"//宏定义文件名


@implementation DBpath

- (BOOL)Case:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    if([scan scanInt:&val] && [scan isAtEnd])
    {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)judge:(NSString *)judge
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Name FROM ProductInformation WHERE Name = ?",judge];
    while ([rs next]) {
        [d close];
        return YES;
    }
    [d close];
    return NO;
}

- (void)openn:(FMDatabase *)d
{
    
    if (![d open]) {
        NSLog(@"打开数据库出错");
    }
}

- (NSString *)UserInformationPath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",sqlite];
}

- (NSString *)UserMoneyPath:(NSString *)name
{
    return  [NSHomeDirectory() stringByAppendingFormat:@"/Documents/(%@)UserMoney.TEXT",name];
}

- (void)CreateTable
{
    FMDatabase *DB1 = [FMDatabase databaseWithPath:self.UserInformationPath];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserMoney.plist" ofType:nil];//这2句拿来判断文件是否存在
//    NSLog(@"%@",path);
//    if (path == NULL) {
//        NSFileManager *f = [NSFileManager defaultManager];
//        [f createFileAtPath:path contents:nil attributes:nil];
//    }
//    NSFileManager *f = [NSFileManager defaultManager];
    
//    if (![f fileExistsAtPath:self.UserMoneyPath]) {//这是拿来存储用户资金消费情况的文件
//        [f createFileAtPath:self.UserMoneyPath contents:nil attributes:nil];
//    }
//    打开数据库
    if (![DB1 open]) {
        NSLog(@"初始化打开数据库失败");
        return;
    }
//    执行executeUpdata sql语句，创建用户表
    [DB1 executeUpdate:@"CREATE TABLE IF NOT EXISTS UserInformation(userName TEXT primary key, passWord TEXT, Money Integer,Product TEXT)"];
    [DB1 executeUpdate:@"CREATE TABLE IF NOT EXISTS AdministratorInformation(UserName TEXT primary key, passWord TEXT)"];
    [DB1 executeUpdate:@"CREATE TABLE IF NOT EXISTS ProductInformation(Name TEXT primary Key, Information TXET, Price Integer, Number Integer, Classify TEXT)"];
//    [self adminPassWord];
//    关闭数据库
    [DB1 close];
}
/*
- (void)adminPassWord
{
    FMDatabase *DB1 = [FMDatabase databaseWithPath:self.UserInformationPath];
    if (![DB1 open]) {
        NSLog(@"初始化打开数据库失败");
        return;
    }
    
    FMResultSet *rs = nil;//当我们想要查询放返回多条数据怎么办呢?不用愁，之前我就提到了FMDB中的另外一个主要的类，FMResultSet，这是一个结果集!返回多条数据时FMDB会将数据放在这个结果集中，然后我们在对这个结果集进行查询操作!很简单。
    rs = [DB1 executeQuery:@"SELECT UserName FROM AdministratorInformation"];
    NSString *str = [rs stringForColumn:@"UserName"];
    while ([rs next]) {//必须加入这个next才能查询里面的数据，不写这个就没办法查询里面的数据
        NSLog(@"%@",str);
        if (str == nil) {
            [DB1 executeUpdate:@"INSERT INTO AdministratorInformation(UserName, passWord) VALUES(?,?)",AdministratorUserName,AdministratorPassWord];
        }
    }

}
 */

- (void)notes:(NSInteger)money andOther:(NSString *)other andmoney1:(NSInteger)money1 andName:(NSString *)name
{
    NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:[self UserMoneyPath:name]];
    [h seekToEndOfFile];
    NSDateFormatter *d = [[NSDateFormatter alloc] init];
    [d setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *c = [d stringFromDate:[NSDate date]];
    c = [c stringByAppendingFormat:@"  您%@%ld元,余额为%ld元!\n",other,money,money1];
    NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
    [h writeData:data];
    [h closeFile];
    return;
    
}
//像外转账记录函数
- (void)notes1:(NSInteger)money andOther:(NSString *)other andmoney1:(NSInteger)money1 andName:(NSString *)name
{
    NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:[self UserMoneyPath:name]];
    [h seekToEndOfFile];
    NSDateFormatter *d = [[NSDateFormatter alloc] init];
    [d setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *c = [d stringFromDate:[NSDate date]];
    c = [c stringByAppendingFormat:@"  您给账户为%@的用户转账%ld元,余额为%ld元!\n",other,money,money1];
    NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
    [h writeData:data];
    [h closeFile];
    return;
}
//向内收帐函数
- (void)notes4:(NSInteger)money andOther:(NSString *)other andmoney1:(NSInteger)money1 andName:(NSString *)name
{
    NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:[self UserMoneyPath:name]];
    [h seekToEndOfFile];
    NSDateFormatter *d = [[NSDateFormatter alloc] init];
    [d setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *c = [d stringFromDate:[NSDate date]];
    c = [c stringByAppendingFormat:@"  用户名为%@的用户向您转账%ld元,余额为%ld元!\n",other,money,money1];
    NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
    [h writeData:data];
    [h closeFile];
    return;
}

- (void)notes2:(NSInteger)money andName:(NSString *)name
{
    NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:[self UserMoneyPath:name]];
    [h seekToEndOfFile];
    NSDateFormatter *d = [[NSDateFormatter alloc] init];
    [d setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *c = [d stringFromDate:[NSDate date]];
    c = [c stringByAppendingFormat:@"  管理员Admin修改了您的资金,余额为%ld元!\n",money];
    NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
    [h writeData:data];
    [h closeFile];
    return;
}

@end

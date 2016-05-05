//
//  DBpath.h
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#define AdministratorUserName @"admin"
#define AdministratorPassWord @"admin"

@interface DBpath : NSObject



/**
 正则表达式判断是否有大小写字母*/
- (BOOL)Case:(NSString *)string;

- (void)openn:(FMDatabase *)d;

- (NSString *)UserMoneyPath:(NSString *)name;

/**
 用来判断输入的商品是否存在*/
- (BOOL)judge:(NSString *)judge;

/**
 操作保存函数*/
- (void)notes:(NSInteger)money andOther:(NSString *)other andmoney1:(NSInteger)money1 andName:(NSString *)name;
- (void)notes1:(NSInteger)money andOther:(NSString *)other andmoney1:(NSInteger)money1 andName:(NSString *)name;
- (void)notes2:(NSInteger)money andName:(NSString *)name;
- (void)notes4:(NSInteger)money andOther:(NSString *)other andmoney1:(NSInteger)money1 andName:(NSString *)name;

/**
 数据库路径*/
- (NSString *)UserInformationPath;

/**
 建立用户表,在初始化的时候使用，在main函数里调用一次*/
- (void)CreateTable;

/**
 初始化管理员密码*/
- (void)adminPassWord:(NSString *)KeyName andTableName:(NSString *)TableName;
@end

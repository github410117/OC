//
//  Register.h
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "DBpath.h"

@interface Register : DBpath


- (NSString *)ceshi:(NSString *)a;
/**
 给数据库注册新用户
 */
- (BOOL)RegisterUser:(NSString *)name andPassWord:(NSString *)password;

/**
 注册用户*/
- (void)RegisterUser;

/**
 查找用户，用来判断是否已注册*/
- (BOOL)findUser:(NSString *)name;
/**
 查看订单*/
- (void)LookDespatching;

/**
 发货*/
- (void)Despatching;

@end

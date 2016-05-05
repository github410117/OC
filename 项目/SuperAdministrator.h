//
//  SuperAdministrator.h
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import "DBpath.h"
#import "Register.h"

@interface SuperAdministrator : Register
/**
 管理员管理订单*/
- (void)AdminlookOrder;
- (BOOL)findShoppingCart:(NSString *)name;
/**
 查看用户信息外函数*/
- (void)UserInformation;
/**
 查看用户信息内函数*/
- (BOOL)UserInformation:(NSString *)name;


/**
 修改用户名字外函数*/
- (void)ChangeUserName;
/**
 修改用户名字内函数*/
- (BOOL)ChangeUserName:(NSString *)OldName andNewname:(NSString *)NewName;

/**
 删除用户信息外函数*/
- (void)RemoveUserInformation;

/**
 删除用户信息内函数*/
- (BOOL)RemoveUserInformation:(NSString *)name;

/**
 用户资金操作*/
- (void)UserMoneyChange;

/**
 用户资金操作内函数*/
//- (void)UserMoneyChange:(NSString *)name andMoney:(NSInteger)money;

/**
 添加商品*/
- (void)LookGoods;

/**
 添加新商品*/
- (void)AddNewGood;

- (void)RemoveGood;
- (void)RemoveGood:(NSString *)name;

- (void)ChangeGoods;

- (NSString *)Price:(NSString *)name;

- (NSInteger)Number:(NSString *)name;

- (NSString *)Information:(NSString *)name;


@end

//
//  UserAction.h
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

//#import "menu1.h"
#import "SuperAdministrator.h"

@interface UserAction : SuperAdministrator
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *UserPWD;
/**
 用户存款外函数*/
- (void)UserDeposit;

- (BOOL)OrderNumberfindState1:(NSInteger)order andName:(NSString *)name;

/**
 用户存款内函数*/
- (BOOL)UserDeposit:(NSInteger)money;

/**
 用户取款外函数*/
- (void)UserWithDrawals;

/**
 用户取款内函数*/
- (BOOL)UserWithDrawals:(NSInteger)money;


- (NSInteger)UserTransfer1:(NSString *)name;
/**
 用户转账外函数*/
- (void)UserTransfer;

/**
 用户转账内函数*/
- (BOOL)UserTransfer:(NSString *)name andMoney:(NSInteger)money;

/**
 查看用户资金外函数*/
- (void)ViewUserMoney;

/**
 查看用户自己内函数*/
- (void)ViewUserMoney:(NSString *)name andPwd:(NSString *)pwd;

/**
 监测资金，保存记录函数*/
- (void)notes;

/**
 修改密码外层函数*/
- (void)ChangePassWord;

/**
 修改密码内层函数*/
- (void)ChangePassWord:(NSString *)NewPwd;

/**
 购买商品*/
- (void)BuyGoods;

/**
 商品列表*/
- (void)LookGoodslist;


/**
 加入购物车*/
- (void)ShoppingCart:(NSString *)Product andRowid:(NSInteger)rowid;

/**
 查看订单信息*/
- (void)lookOrderInformation;

/**
 关闭订单*/
- (void)CloseOrder;


/**
 结算*/
- (void)OneSettlement;

/**
 查看购物车*/
- (void)lookShoppingCart;

/**
 全部结算*/
- (void)allSettlement;

- (NSInteger)allSettlement1;


- (NSInteger)money;


@end

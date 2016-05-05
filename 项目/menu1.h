//
//  menu1.h
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "UserAction.h"


@interface menu1 : UserAction
{
    char chose[1024];
}

/**
 登录欢迎界面*/
- (void)welcomeMenu1;

/**
 超级管理员界面*/
- (void)SuperAdministratorLogin;

/**
 用户操作界面*/
- (void)UserAction;

/**
 找回遗忘密码*/
//- (void)FindPassWord;

/**
 商品信息操作*/
- (void)Goods;


@end

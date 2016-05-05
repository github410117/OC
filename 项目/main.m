//
//  main.m
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "menu1.h"
#import "FMDatabase.h"
#import "DBpath.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        创建一个用户表，用来存储注册信息
        DBpath *path = [[DBpath alloc] init];
        [path CreateTable];
//        打开欢迎界面
        menu1 *menu = [[menu1 alloc] init];
        [menu welcomeMenu1];
 
        
        
        
        
        

        
        
        
    }
    return 0;
}

//
//  Register.m
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

#import "Register.h"
#import "FMDatabase.h"
//#import "DBpath.h"
#import "menu1.h"


@implementation Register

- (NSString *)ceshi:(NSString *)a
{
    NSString *dianxin = @"^1(3[3]|4[9]|5[3]|7[7]|8[019])[0-9]{8}$";
    NSString *liantong = @"^1(3[012]|4[5]|5[56]|7[156]|8[56])[0-9]{8}$";
    NSString *yidong = @"^1(3[456789]|4[7]|5[012789]|7[8]|8[23478])[0-9]{8}$";
    NSPredicate *dx = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",dianxin];
    NSPredicate *yd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",yidong];
    NSPredicate *lt = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",liantong];
    if ([dx evaluateWithObject:a]) {
        
        return @"尊敬的电信用户";
    }else if ([yd evaluateWithObject:a]) {
        
        return @"尊敬的移动用户";
    }else if([lt evaluateWithObject:a]) {
        
        return @"尊敬的联通用户";
    }
    return @"未知号码";
}


- (BOOL)RegisterUser:(NSString *)name andPassWord:(NSString *)password
{
    FMDatabase *UserInformation = [FMDatabase databaseWithPath:[self UserInformationPath]];
//    打开数据库准备操作
    if (![UserInformation open]) {
        NSLog(@"用户数据库打开失败");
        return NO;
    }
    if([self findUser:name])
    {
        
        NSLog(@"该账户已存在，请直接登录！");
        return NO;
        
    }else{
        //    执行executeUpdate语句添加用户
        BOOL insertUserInformationSuccess = [UserInformation executeUpdate:@"INSERT INTO UserInformation(userName, passWord) VALUES(?,?)", name, password];
        [UserInformation close];
        NSFileManager *f = [NSFileManager defaultManager];
        if (![f fileExistsAtPath:[self UserMoneyPath:name]]) {//这是拿来存储用户资金消费情况的文件
            [f createFileAtPath:[self UserMoneyPath:name] contents:nil attributes:nil];
        }
        
        return insertUserInformationSuccess;
    }

    
}

- (void)RegisterUser
{
    char name[20];
    char pwd[20];
loop:printf("请输入手机号:");
    scanf("%s",name);
    
    NSString *k = @"^1[34578][0-9]{9}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",k];
    NSString *name1 = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    if (![p evaluateWithObject:name1]) {
        printf("请输入正确的手机号!\n");
        goto loop;
        
    }
    printf("请输入密码:");
    scanf("%s",pwd);
    NSString *pwd1 = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
    
    if ([self RegisterUser:name1 andPassWord:pwd1]) {
//        const char *s = [[self ceshi:name1] UTF8String];
        NSRange r = {0,7};
        NSString *i = [name1 substringWithRange:r];
        NSInteger lf = [i integerValue];

        FMDatabase *d = [FMDatabase databaseWithPath:@"/Users/etcxm/Documents/Data.sqlite"];
        [d open];
        FMResultSet *rs = [d executeQuery:@"SELECT * FROM Dm_Mobile WHERE MobileNumber = ?",[NSNumber numberWithInteger:lf]];
        while ([rs next]) {
            NSString *a = [rs stringForColumn:@"MobileNumber"];
            NSString *b = [rs stringForColumn:@"MobileArea"];
            NSString *c = [rs stringForColumn:@"MobileType"];
//            NSHost* myhost =[NSHost currentHost];
//            NSString *adr = [myhost address];
//            const char *ade1 = [adr UTF8String];
            const char *a1 = [a UTF8String];
            const char *b1 = [b UTF8String];
            const char *c1 = [c UTF8String];
            printf("              \n");
//            printf("您的IP地址为:%s\n",ade1);
            printf("来自 %s %s的用户\n恭喜您注册成功!\n",b1,c1);
            printf("              \n");
        }
        [d close];

//        printf("          \n");
//        printf(",账号注册成功\n",);
//        printf("          \n");
    }else
    {
        NSLog(@"注册账号失败");
    }
}

- (BOOL)findUser:(NSString *)name
{
    NSMutableArray *allArry = [NSMutableArray array];
    FMDatabase *findUser = [FMDatabase databaseWithPath:self.UserInformationPath];
    if (![findUser open]) {
        NSLog(@"查询用户时，打开数据库失败！");
        return NO;
    }
    FMResultSet *rs = nil;//当我们想要查询放返回多条数据怎么办呢?不用愁，之前我就提到了FMDB中的另外一个主要的类，FMResultSet，这是一个结果集!返回多条数据时FMDB会将数据放在这个结果集中，然后我们在对这个结果集进行查询操作!很简单。
    rs = [findUser executeQuery:@"SELECT userName FROM UserInformation "];
    while ([rs next]) {//如果表中完全没有数据，那么就不会进入这个while循环
        NSString *str = [rs stringForColumn:@"userName"];

        
    
        [allArry addObject:str];
    }
    
    for (NSString *str1 in allArry) {
        if ([str1 isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}


@end

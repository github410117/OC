//
//  menu1.m
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

#import "menu1.h"
#import "FMDatabase.h"
#define AdministratorUserName @"admin"
#define AdministratorPassWord @"admin"




@implementation menu1

- (void)welcomeMenu1
{
    while (1) {
        printf("-----------------------------\n");
        printf("       在线销售系统欢迎您        \n");
        printf("-----------------------------\n");
        printf("|      |1.超级管理登录|       |\n");
        printf("|      |2.普通用户登录|       |\n");
        printf("|      |3.注册新的用户|       |\n");
        printf("|      |4.退出销售系统|       |\n");
//        printf("|      |4.找回遗忘密码|       |\n");
//        printf("|      |5.返回欢迎页面|       |\n");
    loop: printf("请输入选项:");
        scanf("%s",chose);
        NSString *aa = [NSString stringWithCString:chose encoding:NSUTF8StringEncoding];
        NSInteger avd = aa.length;
        if (avd > 1) {
            printf("输入错误，请重新输入!\n");
            goto loop;
            
        }
        
            switch (chose[0]) {
                case '1':
                    [self SuperAdministratorLogin];
                    break;
                case '2':
                    [self UserAction];
                    break;
                case '3':
                    [self RegisterUser];
                    break;
                case '4':
                    exit(0);
                    break;
                default:
                    printf("您的输入有误，请重新输入\n");
                    break;
            }
     
        }
    

    
    }

- (void)SuperAdministratorLogin
{
    while (1) {
        char name[20],pwd[20];
        printf("请输入管理员账号:");
        scanf("%s",name);
        printf("请输入管理员密码:");
        scanf("%s",pwd);
        NSString *newname = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSString *newpwd = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
        if ([newpwd isEqualToString:AdministratorPassWord] && [newname isEqualToString:AdministratorUserName]){
            while (1){
                printf("-----------------------------\n");
                printf("-----------超级管理员----------\n");
                printf("|      |1.查看用户信息|       |\n");
                printf("|      |2.修改用户密码|       |\n");
                printf("|      |3.删除用户信息|       |\n");
                printf("|      |4.用户资金操作|       |\n");
                printf("|      |5.商品信息操作|       |\n");
                printf("|      |6.订单信息操作|       |\n");
                printf("|      |7.返回登录界面|       |\n");
                char i[1024];
            loop:printf("请输入选项:");
                scanf("%s",i);
                NSString *da = [NSString stringWithCString:i encoding:NSUTF8StringEncoding];
                if ([self Case:da]) {
                    printf("输入有误，请重新输入\n");
                    goto loop;
                }
                NSInteger idd = [da integerValue];
                switch (idd) {
                    case 1:
                        [self UserInformation];
                        break;
                    case 2:
                        [self ChangeUserName];
                        break;
                    case 3:
                        [self RemoveUserInformation];
                        break;
                    case 4:
                        [self UserMoneyChange];
                        break;
                    case 5:
                        [self Goods];
                        break;
                    case 6:
                        [self AdminlookOrder];
                        break;
                    case 7:
                        [self welcomeMenu1];
                        break;
                        
                    default:
                        printf("您的输入有误，请重新输入!\n");
                        break;
                }
                
            }
        
        }
        
        printf("账号或密码不正确，请重新输入！\n");
        printf("                         \n");
    }
    
}


- (void)UserAction
{
    int aa = 0;
    while (1) {
        char name[20],pwd[20];
        printf("请输入您的用户账号:");
        scanf("%s",name);
        printf("请输入您的用户密码:");
        scanf("%s",pwd);
        NSString *newname = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSString *newpwd = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
        FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
        [d open];
        FMResultSet *rs = [d executeQuery:@"SELECT * FROM UserInformation WHERE userName = ? and passWord = ?",newname,newpwd];
        while ([rs next]) {
            self.UserName = newname;
            self.UserPWD = newpwd;

            while (1) {
                printf("--------您的余额为%ld元!--------\n",[self money3]);
                printf("-----------用户操作-----------\n");
                printf("|      |1.用户存款        \n");
                printf("|      |2.用户取款        \n");
                printf("|      |3.用户转账        \n");
                printf("|      |4.修改密码        \n");
                printf("|      |5.购买商品        \n");
                printf("|      |6.订单操作        \n");
                printf("|      |7.购物车          \n");
                printf("|      |8.查看账户资金流向  \n");
                printf("|      |9.查看物流        \n");
                printf("|      |10.返回登录界面    \n");
                [d close];
                char ddd[1024];
            loop3:printf("请输入选项:");
                scanf("%s",ddd);
                NSString *sa = [NSString stringWithCString:ddd encoding:NSUTF8StringEncoding];
                if ([self Case:sa]) {
                    printf("选项输入错误，请重新输入!\n");
                    goto loop3;
                }
                NSInteger i = [sa integerValue];
                
                    switch (i) {
                        case 1:
                            [self UserDeposit];
                            break;
                        case 2:
                            [self UserWithDrawals];
                            break;
                        case 3:
                            [self UserTransfer];
                            break;
                        case 4:
                            [self ChangePassWord];
                            break;
                        case 5:
                            [self BuyGoods];
                            break;
                        case 6:
                            [self lookOrderInformation];
                            break;
                        case 7:
                            [self lookShoppingCart];
                            break;
                        case 8:
                            [self ViewUserMoney];
                            break;
                        case 9:
                            [self findwuliu];
                            break;
                        case 10:
                            [self welcomeMenu1];
                            break;
                 
                            
                        default:
                            printf("没有该选项，请重新输入!\n");
                            break;
                    }

            }
            
        }
        aa++;
        printf("您的用户名或密码错误，请重新输入,超过3次自动退出！\n");
        if (aa == 3) {
            printf("您输入用户名或密码错误超过3次，自动退出!\n");
            return;
        }
    }
    
    
    
}



/*
- (void)test
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    if (![d open]) {
        NSLog(@"打开数据库失败");
        return;
    }
    FMResultSet *rs = [d executeQuery:@"SELECT userName, passWord FROM UserInformation "];
    while ([rs next]) {
        NSString *row1 = rs stringForColumn:<#(NSString *)#>
    }
    
}
 */


- (void)findwuliu
{
    
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",@"Despatching.txt"];
    NSFileManager *f = [NSFileManager defaultManager];
    if (![f fileExistsAtPath:path]) {
        printf("\n");
        printf("没有物流信息\n");
        printf("\n");
        return;
    }
    NSFileHandle *h = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [h readDataToEndOfFile];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //            NSLog(@"%@",str);
    const char *inf = [str UTF8String];//NSString转char
    printf("%s",inf);
    int hg = 0;
    printf("1、确认收货\n");
    printf("2、返回\n");
loop78:printf("请输入选项:");
    char u[1024];
    scanf("%s",u);
    NSString *uu = [NSString stringWithCString:u encoding:NSUTF8StringEncoding];
    if ([self Case:uu]) {
        printf("请输入正确的选项!\n");
        hg++;
        if (hg == 3) {
            printf("您已输入错误3次，自动退出!\n");
            return;
        }
        goto loop78;
    }
    NSInteger hf = [uu integerValue];
    switch (hf) {
        case 1:
            [self removeOrder];
            break;
        case 2:
            return;
            break;
        default:
            printf("输入错误，请重新输入!\n");
            hg++;
            if (hg == 3) {
                printf("您已输入错误3次，自动退出!\n");
                return;
            }
            goto loop78;
            break;
    }
}

- (void)removeOrder
{
    NSFileManager *f = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",@"Despatching.txt"];
    if (![f fileExistsAtPath:path]) {
        printf("确认收货失败!\n");
        return;
    }
    if ([f removeItemAtPath:path error:nil]) {
        printf("确认收货成功!\n");
        return;
    }
    printf("确认收货失败!\n");
}

- (NSInteger)money3
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Money FROM UserInformation WHERE userName = ?",self.UserName];
    while ([rs next]) {
        NSInteger a = [rs intForColumn:@"Money"];
        [d close];
        return a;
    }
    [d close];
    return 0;
}



- (void)Goods
{
    while (1)
    {
        printf("-----------------------------\n");
        printf("----------商品信息操作---------\n");
        printf("|      |1.查看库存信息|       |\n");
        printf("|      |2.添加新的商品|       |\n");
        printf("|      |3.删除商品信息|       |\n");
        printf("|      |4.更改商品信息|       |\n");
        printf("|      |5.返回上一界面|       |\n");
        char p[1024];
    loop:printf("请输入选项:");
        scanf("%s",p);
        NSString *dd = [NSString stringWithCString:p encoding:NSUTF8StringEncoding];
        if ([self Case:dd]) {
            printf("请输入正确的选项!\n");
            goto loop;
        }
        NSInteger i = [dd integerValue];
            switch (i) {
                case 1:
                    [self LookGoods];
                    break;
                case 2:
                    [self AddNewGood];
                    break;
                case 3:
                    [self RemoveGood];
                    break;
                case 4:
                    [self ChangeGoods];
                    break;
                case 5:
                    return;
                    break;
                    
                default:
                    printf("您的输入有误，请重新输入!\n");
                    break;
            }
  
    }
    
    }
    
    

@end

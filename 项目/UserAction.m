//
//  UserAction.m
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

#import "UserAction.h"
#import "FMDatabase.h"
#import "OrderInformation.h"
#define class1 @"手机类"
#define class2 @"电脑类"

@implementation UserAction

- (void)UserDeposit
{
    int e = 0;
loop:printf("请输入需要存款的金额:");
    char i[1024];
    scanf("%s",i);
    NSString *aa = [NSString stringWithCString:i encoding:NSUTF8StringEncoding];
    if ([self Case:aa]) {
        printf("您输入的存款金额应为纯数字!请重新输入!\n");
        e++;
        if (e == 3) {
            printf("您输入错误3次，请重新输入!\n");
            return;
        }
        goto loop;
    }

    NSInteger k = [aa integerValue];
    if (k < 1) {
        printf("存款金额不能等于或小于0元!\n");
        e++;
        if (e == 3) {
            printf("您输入错误3次，请重新输入!\n");
            return;
        }
        goto loop;
    }
    if (k > 5000) {
        printf("出于安全考虑，一次存款金额不能超过5000元!\n");
        e++;
        if (e == 3) {
            printf("您输入错误3次，请重新输入!\n");
            return;
        }
        goto loop;
    }
    
    [self UserDeposit:k];
}

- (BOOL)UserDeposit:(NSInteger)money
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    if (![d open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
//    NSInteger a = 0;
    printf("              \n");
    FMResultSet *rs = [d executeQuery:@"SELECT Money FROM UserInformation WHERE userName = ?",self.UserName];
    
    while ([rs next]) {
        NSInteger a = [rs intForColumn:@"Money"];
        a += money;
        [self notes:money andOther:@"存款" andmoney1:a andName:self.UserName];
        [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:a],self.UserName];
        printf("存款成功，余额为:%ld元\n",a);
        printf("                   \n");
        [d close];
        return YES;
    }
    NSLog(@"存款失败");
    [d close];
    return NO;
//    if([d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:money],name])
//    {
//        NSLog(@"存款成功，存款金额为%ld",money);
//        [d close];
//        return YES;
//    }else
//    {
//        NSLog(@"存款失败");
//        [d close];
//        return NO;
//    }
}

- (void)UserWithDrawals
{
    int y = 0;
loop:printf("请输入取款金额:");
    char i[1024];
    scanf("%s",i);
    NSString *aa = [NSString stringWithCString:i encoding:NSUTF8StringEncoding];
    if ([self Case:aa]) {
        printf("取款金额应为纯数字，请重新输入!\n");
        y++;
        if (y == 3) {
            printf("输入错误3次，自动退出!\n");
            return;
        }
        goto loop;
    }

    NSInteger ab = [aa integerValue];
    if (ab < 1) {
        printf("取款金额应大于0!\n");
        y++;
        if (y == 3) {
            printf("输入错误3次，自动退出!\n");
            return;
        }
        goto loop;
    }
    
    if (ab > [self money]) {
        printf("取款失败，余额不足!\n");
        return;
    }
    
    [self UserWithDrawals:ab];
}

- (NSInteger)money
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

- (BOOL)UserWithDrawals:(NSInteger)money
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Money FROM UserInformation WHERE userName = ?",self.UserName];
    
    while ([rs next]) {
        NSInteger a = [rs intForColumn:@"Money"];
        a -= money;
        [self notes:money andOther:@"取款" andmoney1:a andName:self.UserName];
        [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:a],self.UserName];
        printf("取款%ld元成功，余额为:%ld元\n",money,a);
        [d close];
        return YES;
    }
    NSLog(@"取款失败");
    [d close];
    return NO;
}




- (NSInteger)UserTransfer1:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs1 = [d executeQuery:@"SELECT Money FROM UserInformation WHERE userName = ?",name];
    while ([rs1 next]) {
        NSInteger temp = [rs1 intForColumn:@"Money"];
        [d close];
        return temp;
    }
    [d close];
    return 0;
}

- (void)UserTransfer
{
    int i = 0;
    int sd = 0;
    while (1) {
        char name1[20],name2[20];
    loop2:printf("请输入对方的账号:");
        scanf("%s",name1);
        NSString *newname1 = [NSString stringWithCString:name1 encoding:NSUTF8StringEncoding];
        if ([newname1 isEqualToString:self.UserName]) {
            printf("不能向自己的账号转账，请重新输入!\n");
            i++;
            if (i == 3) {
                printf("输错三次，自动退出!\n");
                return;
            }
            goto loop2;
        }
        printf("请再次输入对方账号:");
        scanf("%s",name2);
        NSString *newname2 = [NSString stringWithCString:name2 encoding:NSUTF8StringEncoding];
        if ([newname1 isEqualToString:newname2]) {
            NSString *newname3 = [NSString stringWithFormat:@"%@",newname2];
            if (![self findUser:newname3]) {
                printf("您输入的转账对象不存在，请重新输入!\n");
                i++;
                if (i == 3) {
                    printf("输错三次，自动退出!\n");
                    return;
                }
                goto loop2;
            }
            char mo[1024];
//            NSInteger money;
            char pwd[20];
        loop1:printf("请输入需要转账的金额:");
            scanf("%s",mo);
            NSString *as = [NSString stringWithCString:mo encoding:NSUTF8StringEncoding];
            if ([self Case:as]) {
                printf("金额应该为纯数字，请重新输入!\n");
                sd++;
                if (sd == 3) {
                    printf("输错3次，请重新输入!\n");
                    return;
                }
                goto loop1;
            }
            NSInteger money = [as integerValue];
            if (money < 1) {
                printf("转账金额应该大于0元!\n");
                sd++;
                if (sd == 3) {
                    printf("输错3次，请重新输入!\n");
                    return;
                }
                goto loop1;
            }
        loop:printf("请输入您的密码确定此笔交易:");
            scanf("%s",pwd);
            NSString *newpwd = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
            if ([newpwd isEqualToString:self.UserPWD]) {
                FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
//                [d open];
                NSInteger temp1 = [self UserTransfer1:self.UserName];
                if (temp1 < money) {
                    printf("您卡上余额不足!\n");
                    goto loop1;
                }else{
                    temp1 -= money;
                    [self openn:d];
                    [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:temp1],self.UserName];
                    [d close];
                }
                NSInteger temp2 = [self UserTransfer1:newname3];
                temp2 += money;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    //        [self performSelector:@selector(user1) withObject:nil afterDelay:5];
                    [NSThread sleepForTimeInterval:15];
                    [self openn:d];
                    if (![self findUser:newname3]) {
                        NSInteger temp9 = [self UserTransfer1:self.UserName];
                        temp9 += money;
                        [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:temp9],self.UserName];
                        [d close];
                        [self notes6:money andmoney1:temp9 andName:self.UserName];
                    }
                    [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:temp2],newname3];
                    [d close];
                    [self notes4:money andOther:self.UserName andmoney1:temp2 andName:newname3];
                    
                });
                [self openn:d];
                [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:temp2],newname3];
                [d close];
                [self notes1:money andOther:newname3 andmoney1:temp1 andName:self.UserName];
//                [self notes4:money andOther:self.UserName andmoney1:temp2 andName:newname3];
                printf("转账成功，15秒后对方将会收到您的款项!\n");
                return;
                //               FMResultSet *rs = [d executeQuery:@"SELECT Money FROM UserInformation WHERE userName = ?",self.UserName];
//                [d close];
//               NSInteger new = [self UserTransfer1:newname3];
//                [d open];
//                while ([rs next]) {
//                    NSInteger temp = [rs intForColumn:@"Money"];
//                    return;
//                    temp -= money;
//                    if (temp < 0) {
//                        printf("您卡上的余额不足！");
//                        goto loop1;
//                    }
//                    [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:temp],self.UserName];
////                    [d close];
////                    [d open];
////                    [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",new,newname3];
//                    printf("恭喜您转账成功，款项将及时打入对方账户！");
//                    [d close];
////                    return;
//                }
//                NSInteger new = [self UserTransfer1:newname3];
//                NSLog(@"%ld",new);
//                NSInteger temp;
//                temp += new;
//                [self openn:d];
//                [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",temp,newname3];
//                [d close];
//                return;
//            }else{
//                printf("您的密码输入不正确，请重新输入");
//                goto loop;
            }
            printf("您输入的密码不正确，请重新输入!\n");
            goto loop;
            
        }
        printf("您2次输入的账号不一致，请重新输入!\n");
    }
}


- (void)notes6:(NSInteger)money andmoney1:(NSInteger)money1 andName:(NSString *)name
{
    NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:[self UserMoneyPath:name]];
    [h seekToEndOfFile];
    NSDateFormatter *d = [[NSDateFormatter alloc] init];
    [d setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *c = [d stringFromDate:[NSDate date]];
    c = [c stringByAppendingFormat:@"  由于对方账户出现错误，您的转款%ld元已经返回到您的账户中,余额为%ld元!\n",money,money1];
    NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
    [h writeData:data];
    [h closeFile];
    return;
    
}




//- (void)yanchi//延迟到账的函数
//{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        //        [self performSelector:@selector(user1) withObject:nil afterDelay:5];
//        [NSThread sleepForTimeInterval:10];
//        [self ui];
//        
//    });
//    dispatch_async(queue, ^{
//        while (1) {
//            char n[20];
//            printf("请输入:");
//            scanf("%s",n);
//            printf("%s",n);
//        }
//    });
    
//}

- (void)ViewUserMoney
{   int a = 0;
    while (1) {
        char pwd[20];
        printf("请输入您的密码:");
        scanf("%s",pwd);
        NSString *newpwd = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
        if ([newpwd isEqualToString:self.UserPWD]) {
            NSFileHandle *h = [NSFileHandle fileHandleForReadingAtPath:[self UserMoneyPath:self.UserName]];
            NSData *data = [h readDataToEndOfFile];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",str);
            const char *inf = [str UTF8String];//NSString转char
            printf("%s",inf);
            return;
            
        }
        a++;
        printf("密码输入错误，请重新输入!\n");
        if (a == 3) {
            printf("您已输错3次密码，自动退出!");
            return;
        }
    }
}



- (void)ChangePassWord
{
    int a = 0;
    while (1) {
        char old[20],new[20];
        printf("请输入您的旧密码:");
        scanf("%s",old);
        NSString *old1 = [NSString stringWithCString:old encoding:NSUTF8StringEncoding];
        if ([old1 isEqualToString:self.UserPWD]) {
            printf("请输入新密码:");
            scanf("%s",new);
            NSString *new1 = [NSString stringWithCString:new encoding:NSUTF8StringEncoding];
            [self ChangePassWord:new1];
            return;
        }
        a++;
        printf("旧密码输入不正确，请重新输入");
        if (a == 3) {
            printf("您密码输入错误3次，自动退出!");
            return;
        }
    }
    
}

- (void)ChangePassWord:(NSString *)NewPwd
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    [d executeUpdate:@"UPDATE UserInformation SET passWord = ? WHERE userName = ?",NewPwd,self.UserName];
    [d close];
    printf("密码修改成功!\n");
    return;
}

NSInteger qq ;
- (void)BuyGoods
{
    printf("1、手机产品\n");
    printf("2、电脑产品\n");
    printf("3、返回\n");
loop98:printf("请输入选项:");
    char numb[1024];
    scanf("%s",numb);
    NSString *fdf = [NSString stringWithCString:numb encoding:NSUTF8StringEncoding];
    if ([self Case:fdf]) {
        printf("选项不正确，请重新输入!\n");
        goto loop98;
    }
    NSString *eee = @"";
    NSInteger hn = [fdf integerValue];
    switch (hn) {
        case 1:
            eee = class1;
            break;
        case 2:
            eee = class2;
            break;
        case 3:
            return;
            break;
            
        default:
            printf("选项不正确，请重新输入!\n");
            goto loop98;
            break;
    }
//    NSInteger jf = [fdf integerValue];
    printf("以下是目前还有货的商品名称列表!\n");
    [self LookGoodslist:eee];
    printf("1、购买\n");
    printf("2、返回\n");
loop7:printf("请输入选项:");
    char h[1024];
    scanf("%s",h);
    NSString *jd = [NSString stringWithCString:h encoding:NSUTF8StringEncoding];
    if ([self Case:jd]) {
        printf("请输入正确的选项!\n");
        goto loop7;
    }
    NSInteger ads = [jd integerValue];
    switch (ads) {
        case 1:
            break;
        case 2:
            return;
            break;
        default:
            printf("请输入正确的选项!\n");
            goto loop7;
            break;
    }
    int jh = 0;
loop:printf("请输入您需要购买的产品编号:");
    char p[1024] ;
    scanf("%s",p);
    NSString *aa = [NSString stringWithCString:p encoding:NSUTF8StringEncoding];
    if ([self Case:aa]) {
        printf("请输入正确的产品编号!\n");
        jh++;
        if (jh == 3) {
            printf("输入错误3次，请重新输入!\n");
            return;
        }
        goto loop;
    }
    NSInteger k = [aa integerValue];
//    NSInteger ac = aa.length;
//    if (ac >= 2) {
//        printf("您输入的产品编号有误，请重新输入!\n");
//        goto loop;
//    }
//    int k = (int)i - 48;
    if (![self Rowid1:k]) {
        printf("您输入的产品编号有误，请重新输入!\n");
        jh++;
        if (jh == 3) {
            printf("输入错误3次，请重新输入!\n");
            return;
        }
        goto loop;
    }
    NSString *Name = [self Rowid2:k];
    const char *name = [Name UTF8String];
    const char *info = [[self Information:Name] UTF8String];
    const char *price = [[self Price:Name] UTF8String];
     qq = [self Number:Name];
    printf("您选择的产品是:\n型号:%s\n版本:%s\n单价:%s\n库存:%ld台\n",name,info,price,qq);
    printf("            \n");
    printf("请问您是直接购买还是暂时添加到购物车!\n");
    printf("-----------\n");
    printf("1、直接购买\n");
    printf("2、加入购物车\n");
    printf("3、返回\n");
    printf("-----------\n");
loop3:printf("请输入选项:");
    char re[1024];
    scanf("%s",re);
    NSString *as = [NSString stringWithCString:re encoding:NSUTF8StringEncoding];
    if ([self Case:as]) {
        printf("您输入的选项错误!请重新输入!\n");
        goto loop3;
    }
    NSInteger r = [as integerValue];
    
        switch (r) {
            case 1:
                break;
            case 2:
                if (qq < 1) {
                    printf("该商品库存不足，请重新选择\n");
                    goto loop;
                }
                [self ShoppingCart:Name andRowid:k];
                return;
                break;
            case 3:
                return;
                break;
                
            default:
                printf("您的输入有误，请重新输入!\n");
                goto loop3;
                break;
        }
    
        
    
loop1:printf("请输入您的密码确认购买:");
    char pwd[20];
    scanf("%s",pwd);
    NSString *pwd1 = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
    if (![pwd1 isEqualToString:self.UserPWD]) {
        printf("您输入的密码不正确，请重新输入!\n");
        goto loop1;
    }
    NSInteger money = [self lookUserMoney:self.UserName];
    if (money < [self price:k]) {
        printf("您卡上余额不足，无法完成交易!\n");
        return;
    }
    if (qq < 1) {
        printf("很抱歉，%s的库存不足，请选择其他产品\n",name);
        goto loop;
    }
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *s = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ShoppingCart%@(Product TEXT ,OrderNumber TEXT primary key,State TEXT)",self.UserName];
    [d executeUpdate:s];
    
    NSDateFormatter *ddd = [[NSDateFormatter alloc] init];
    [ddd setDateFormat:@"yyyymmss"];
    NSString *c = [ddd stringFromDate:[NSDate date]];
    //    NSInteger df = [c integerValue];
    NSString *s2 = [NSString stringWithFormat:@"INSERT INTO ShoppingCart%@(Product, OrderNumber, State) VALUES('%@','%@','%@')",self.UserName,Name,c,@"已付款"];
    [d executeUpdate:s2];
    NSString *ui = [self findProductUserName];
//    NSLog(@"%@",ui);
    if (ui == nil) {
        ui = @"";
    }
    NSString *uii = [NSString stringWithFormat:@"%@ %@",ui,Name];
    [d executeUpdate:@"UPDATE UserInformation SET Product = ? WHERE userName = ?",uii,self.UserName];
    NSInteger o = qq - 1;
    [d executeUpdate:@"UPDATE ProductInformation SET Number = ? WHERE rowid = ?",[NSNumber numberWithInteger:o],[NSNumber numberWithInteger:k]];
    [d close];
    [self Buy:[self price:k] andName:Name];
    printf("根据GPS定位您处于:福建省-厦门市-思明区-软件园二期观日路2号楼(中软海晟)\n\t立马发货!\n");
    [self Despatching];
    printf("       恭喜您！\n交易成功，欢迎下次购买!\n");
    

}

- (void)Buy:(NSInteger)money andName:(NSString *)name//购买商品后结算金额并且写入文件
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Money FROM UserInformation WHERE userName = ?",self.UserName];
    
    while ([rs next]) {
        NSInteger a = [rs intForColumn:@"Money"];
        a -= money;
        NSString *ss = [NSString stringWithFormat:@"购买了一台%@ 消费了",name];
        [self notes:money andOther:ss andmoney1:a andName:self.UserName];
        [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:a],self.UserName];
        [d close];
        return;
    }
    [d close];
    return;
}

- (NSInteger)lookUserMoney:(NSString *)name//拿来查看用户余额
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Money FROM UserInformation WHERE userName = ?",name];
    while ([rs next]) {
        NSInteger i = [rs intForColumn:@"Money"];
        [d close];
        return i;
    }
    [d close];
    return 0;
    
}


- (void)LookGoodslist:(NSString *)classify
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    
    //    [d executeUpdate:@"CREATE TABLE ProductImformation(Name TEXT primary Key, Information TXET, Price Integer, Number Integer)"];
    NSString *fdas = [NSString stringWithFormat:@"SELECT Name FROM ProductInformation WHERE Classify = '%@'",classify];
    FMResultSet *rs = [d executeQuery:fdas];
//    int i =0;
    //    NSMutableArray *allarry = [NSMutableArray array];
    NSMutableArray *allarry1 = [NSMutableArray array];
    while ([rs next]) {
        //        NSString *temp = [rs stringForColumn:@"Information"];
        NSString *temp1 = [rs stringForColumn:@"Name"];
        
        [allarry1 addObject:temp1];
        //        [allarry addObject:temp];
    }
    [d close];
    

    for (NSString *str in allarry1) {
//        i++;
        NSInteger z = [self Rowid:str];
        NSInteger j = [self Number:str];
        NSString *a = [self Information:str];
        NSString *b = [self Price:str];
        const char *a1 = [a UTF8String];
        const char *str1 = [str UTF8String];
        const char *b1 = [b UTF8String];
        printf("产品编号:%ld\t  型号:%s\t 版本:%s\t 单价:%s\t 剩余%ld台!\n",z,str1,a1,b1,j);
    }
    return;
}


- (NSInteger)Rowid:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT rowid FROM ProductInformation WHERE Name = ?",name];
    while ([rs next]) {
        NSInteger i = [rs intForColumn:@"rowid"];
        [d close];
        return i;
    }
    [d close];
    return 0;
}

- (BOOL)Rowid1:(NSInteger)rowid
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT rowid FROM ProductInformation WHERE rowid = ?",[NSNumber numberWithInteger:rowid]];
    while ([rs next]) {
        
        [d close];
        return YES;
    }
    [d close];
    return NO;
}

- (NSString *)Rowid2:(NSInteger)rowid
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Name FROM ProductInformation WHERE rowid = ?",[NSNumber numberWithInteger:rowid]];
    while ([rs next]) {
        NSString *a = [rs stringForColumn:@"Name"];
        [d close];
        return a;
    }
    [d close];
    return @"没有这款商品";
}

- (NSInteger)price:(NSInteger)rowid
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Price FROM ProductInformation WHERE rowid = ?",[NSNumber numberWithInteger:rowid]];
    while ([rs next]) {
        NSInteger a = [rs intForColumn:@"Price"];
        [d close];
        return a;
    }
    [d close];
    return 0;
}



- (void)ShoppingCart:(NSString *)Product andRowid:(NSInteger)rowid
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *s = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ShoppingCart%@(Product TEXT ,OrderNumber TEXT primary key,State TEXT)",self.UserName];
    [d executeUpdate:s];
    
    NSDateFormatter *ddd = [[NSDateFormatter alloc] init];
    [ddd setDateFormat:@"yyyymmss"];
    NSString *c = [ddd stringFromDate:[NSDate date]];
//    NSInteger df = [c integerValue];
    NSString *s2 = [NSString stringWithFormat:@"INSERT INTO ShoppingCart%@(Product, OrderNumber, State) VALUES('%@','%@','%@')",self.UserName,Product,c,@"未付款"];
    [d executeUpdate:s2];
//    NSInteger o = [self Number:Product] - 1;
//    [d executeUpdate:@"UPDATE ProductInformation SET Number = ? WHERE rowid = ?",[NSNumber numberWithInteger:o],[NSNumber numberWithInteger:rowid]];
    
    [d close];
    
    printf("加入购物车成功\n");
}

- (void)lookOrderInformation
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    if (![self lookOrderInformation1]) {
        printf("您暂时没有任何的订单\n");
        return;
    }
    NSMutableArray *allarry = [NSMutableArray array];
    NSString *s = [NSString stringWithFormat:@"SELECT * FROM ShoppingCart%@",self.UserName];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        NSString *s1 = [rs stringForColumn:@"Product"];
        NSString *s2 = [rs stringForColumn:@"OrderNumber"];
        NSString *s3 = [rs stringForColumn:@"State"];
        OrderInformation *o = [[OrderInformation alloc] init];
        o.Product = s1;
        o.OrderNumber = s2;
        o.State = s3;
        [allarry addObject:o];
    }
    [d close];
    printf("您所有的订单信息如下:\n");
    for (OrderInformation *oo in allarry) {
        const char *s = [oo.Product UTF8String];
        const char *s1 = [oo.OrderNumber UTF8String];
        const char *s2 = [oo.State UTF8String];
        printf("订单编号:%s\t产品型号:%s\t\t付款状态:%s\n",s1,s,s2);
    }
loop9:printf("请选择操作:\n");
    printf("1、关闭订单\n");
    printf("2、去购物车结算\n");
    printf("3、返回上级菜单\n");
    char i[1024];
loop:printf("请输入选项:");
    scanf("%s",i);
    NSString *a = [NSString stringWithCString:i encoding:NSUTF8StringEncoding];
    if ([self Case:a]) {
        printf("您的输入有误，请重新输入!\n");
        goto loop9;
    }
    NSInteger aa = a.length;
    if (aa >= 2) {
        printf("您的输入有误，请重新输入!\n");
        goto loop9;
    }
    NSInteger ad = [a integerValue];
        switch (ad) {
            case 1:
                [self CloseOrder];
                return;
                break;
            case 2:
                [self lookShoppingCart];
                break;
                return;
            case 3:
                return;
                break;
                
            default:
                printf("没有这个选项，请重新输入!\n");
                goto loop;

                break;
        }
    
    
    

}

- (BOOL)lookOrderInformation1
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *s = [NSString stringWithFormat:@"SELECT rowid FROM ShoppingCart%@",self.UserName];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        [d close];
        return YES;
    }
    [d close];
    return NO;
}

- (BOOL)OrderNumberfindState:(NSInteger)order//根据订单号来查询有没有对应的没付款的订单
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *s = [NSString stringWithFormat:@"SELECT OrderNumber FROM ShoppingCart%@ WHERE State = '%@' and OrderNumber = '%ld'",self.UserName,@"未付款",order];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        [d close];
        return YES;
    }
    [d close];
    return NO;
}




- (void)CloseOrder
{
    int h = 0;
//    printf("请输入需要查看的用户名");
loop33:printf("请输入需要关闭的订单号:");
    char j[1024];
    scanf("%s",j);
    NSString *jj = [NSString stringWithCString:j encoding:NSUTF8StringEncoding];
    if ([self Case:jj]) {
        printf("订单号为纯数字，请重新输入!\n");
        h++;
        if (h == 3) {
            printf("您输入的次数超过3次，自动退出!\n");
            return;
        }
        goto loop33;
    }
    NSInteger i = [jj integerValue];
    if (i == 0) {
        printf("您输入的订单号有误,请重新输入!\n");
        h++;
        if (h == 3) {
            printf("您输入的次数超过3次，自动退出!\n");
            return;
        }
        goto loop33;
    }
    if (![self OrderNumberfindState:i]) {
        printf("您输入的订单号有误,请重新输入!\n");
        h++;
        if (h == 3) {
            printf("您输入的次数超过3次，自动退出!\n");
            return;
        }
        goto loop33;
    }
    
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
//    NSString *s = [NSString stringWithFormat:@"DELETE FROM ShoppingCart%@ WHERE OrderNumber = '%d'",self.UserName,i];
//    [d executeUpdate:s];
    NSString *ss = [NSString stringWithFormat:@"SELECT Product FROM ShoppingCart%@ WHERE OrderNumber = '%ld'",self.UserName,i];
    FMResultSet *rs = [d executeQuery:ss];
    NSMutableArray *arry = [NSMutableArray array];
    while ([rs next]) {
        NSString *a = [rs stringForColumn:@"Product"];
        [arry addObject:a];
    }
//    for (NSString *aa in arry) {
//        NSInteger j = [self Number:aa];
//        [d executeUpdate:@"UPDATE ProductInformation SET Number = ? WHERE Name = ?",[NSNumber numberWithInteger:j + 1],aa];
//    }
    NSString *s4 = [NSString stringWithFormat:@"UPDATE ShoppingCart%@ SET State = '%@' WHERE OrderNumber = '%ld'",self.UserName,@"已关闭",i];
    [d executeUpdate:s4];
    [d close];
    printf("订单%ld已经关闭成功!\n",i);
}

- (void)lookShoppingCart
{
    if (![self findShoppingCart:self.UserName]) {
        printf("您的购物为空\n");
        return;
    }    printf("您的购物车中有以下商品!\n");
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    if (![self lookShoppingCart1]) {
        printf("您的购物车为空!\n");
        return;
    }
    NSString *s = [NSString stringWithFormat:@"SELECT * FROM ShoppingCart%@ WHERE State = '%@'",self.UserName,@"未付款"];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        const char *s = [[rs stringForColumn:@"Product"] UTF8String];
        const char *s1 = [[rs stringForColumn:@"OrderNumber"] UTF8String];
        const char *s2 = [[rs stringForColumn:@"State"] UTF8String];
        printf("订单号:%s\t\t  产品型号:%s\t\t付款状态:%s\n",s1,s,s2);
    }
    printf("           ");
loop:printf("请选择操作!\n");
    printf("1、全部结算\n");
    printf("2、单个结算\n");
    printf("3、返回上级菜单\n");
    printf("请输入选项:");
    char i[1024] ;
    scanf("%s",i);
    NSString *a = [NSString stringWithCString:i encoding:NSUTF8StringEncoding];
    if ([self Case:a]) {
        printf("您的输入有误，请重新输入!\n");
        goto loop;
    }
    NSInteger aa = a.length;
    if (aa >= 2) {
        printf("您的输入有误，请重新输入!\n");
        goto loop;
    }
    
    NSInteger es = [a integerValue];
//    if (i == 1 || i == 2 || i ==3) {
        switch (es) {
            case 1:
                [self allSettlement];
                break;
            case 2:
                [self OneSettlement];
                break;
            case 3:
                return;
                break;
                
            default:
                printf("没有这个选项，请重新输入!\n");
                goto loop;
                break;
        }
//    }
    
    
    
    
    
}

- (BOOL)lookShoppingCart1
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *s = [NSString stringWithFormat:@"SELECT * FROM ShoppingCart%@ WHERE State = '%@'",self.UserName,@"未付款"];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        [d close];
        return YES;
    }
    [d close];
    return NO;
}

- (void)OneSettlement
{
    int h = 0;
loop:printf("请输入您要结算的订单号:");
    
    char y[1024];
    scanf("%s",y);
    NSString *jj = [NSString stringWithCString:y encoding:NSUTF8StringEncoding];
    NSInteger i = [jj integerValue];
    if (i == 0) {
        printf("请输入正确的订单号,请重新输入!\n");
        h++;
        if (h == 3) {
            printf("输错3次，自动退出!\n");
            return;
        }
        goto loop;
    }
    
    
//    NSInteger i;
//    scanf("%ld",&i);
    if (![self lookOrderInformation2:i]) {
        printf("您输入的订单号码不存在，请重新输入!\n");
        h++;
        if (h == 3) {
            printf("输错3次，自动退出!\n");
            return;
        }
        goto loop;
    }
    if (![self test:i]) {
        printf("该单号已经关闭或已完成交易，请重新输入!\n");
        h++;
        if (h == 3) {
            printf("输错3次，自动退出!\n");
            return;
        }
    }
    int p = 0;
loop1:printf("请输入您的密码确认购买:");
    
    

    
    
//    
    NSString *Name = [self OrderNumberfindProduct:i];
//    const char *info = [[self Information:Name] UTF8String];
//    const char *price = [[self Price:Name] UTF8String];
    NSInteger qq = [self Number:Name];
    const char *name = [Name UTF8String];
    NSInteger j = [self Rowid:Name];

    char pwd[20];
    scanf("%s",pwd);
    NSString *pwd1 = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
    if (![pwd1 isEqualToString:self.UserPWD]) {
        printf("您输入的密码不正确，请重新输入!\n");
        p++;
        if (p == 3) {
            printf("输错3次，自动退出!\n");
            return;
        }
        goto loop1;
    }
    NSInteger money = [self lookUserMoney:self.UserName];
    if (money < [self price:j]) {
        printf("您卡上余额不足，无法完成交易!\n");
        return;
    }
    if (qq < 1) {
        printf("很抱歉，%s的库存不足，请选择其他产品\n",name);
        goto loop;
    }
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    [d executeUpdate:@"UPDATE UserInformation SET Product = ? WHERE userName = ?",Name,self.UserName];
    [d close];
    
    NSInteger o = qq - 1;
    [d open];
    [d executeUpdate:@"UPDATE ProductInformation SET Number = ? WHERE rowid = ?",[NSNumber numberWithInteger:o],[NSNumber numberWithInteger:j]];
    [d close];
    NSString *a = [NSString stringWithFormat:@"UPDATE ShoppingCart%@ SET State = '%@' WHERE OrderNumber = '%ld'",self.UserName,@"已付款",i];
    [d open];
    [d executeUpdate:a];
    [d close];
    [self Buy:[self price:j] andName:Name];
    printf("根据GPS定位您处于:福建省-厦门市-思明区-软件园二期观日路2号楼(中软海晟)\n\t立马发货!\n");
    [self Despatching];
    printf("       恭喜您！\n交易成功，欢迎下次购买!\n");
    
}

- (BOOL)test:(NSUInteger)test
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
//    NSMutableArray *array = [NSMutableArray array];
    NSString *s = [NSString stringWithFormat:@"SELECT OrderNumber FROM ShoppingCart%@ WHERE State = '%@'",self.UserName,@"未付款"];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        [d close];
        return YES;
    }
    [d close];
    return NO;

}

- (BOOL)lookOrderInformation2:(NSInteger)Number//判断订单号是否存在
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *s = [NSString stringWithFormat:@"SELECT OrderNumber FROM ShoppingCart%@",self.UserName];
    NSMutableArray *allarry = [NSMutableArray array];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        NSString *s = [rs stringForColumn:@"OrderNumber"];
        OrderInformation *o = [[OrderInformation alloc] init];
        o.OrderNumber = s;
        [allarry addObject:o];
        
    }
    NSString *sasa = [NSString stringWithFormat:@"%ld",Number];
    for (OrderInformation *oo in allarry) {
        NSString *sa = oo.OrderNumber;
        if ([sa isEqualToString:sasa]) {
            [d close];
            return YES;
        }
    }
    [d close];
    return NO;
}

- (NSString *)OrderNumberfindProduct:(NSInteger)i
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *ss = [NSString stringWithFormat:@"SELECT Product FROM ShoppingCart%@ WHERE OrderNumber = '%ld'",self.UserName,i];
    FMResultSet *rs = [d executeQuery:ss];
    NSMutableArray *arry = [NSMutableArray array];
    while ([rs next]) {
        NSString *a = [rs stringForColumn:@"Product"];
        [arry addObject:a];
    }
    for (NSString *aa in arry) {
        [d close];
        return aa;
    }
    [d close];
    return @"";
}


- (void)allSettlement
{
    char pwd[20];
    int i = 0;
loop:printf("请输入您的密码确认支付:");
    scanf("%s",pwd);
    NSString *pwd1 = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
    if (![pwd1 isEqualToString:self.UserPWD]) {
        printf("您输入的密码不正确,请重新输入!\n");
        i++;
        if (i == 3) {
            printf("您输入密码已错误三次，退出\n");
            return;
        }
        goto loop;
    }
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSMutableArray *array = [NSMutableArray array];
    NSString *s = [NSString stringWithFormat:@"SELECT OrderNumber FROM ShoppingCart%@ WHERE State = '%@'",self.UserName,@"未付款"];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        NSString *num = [rs stringForColumn:@"OrderNumber"];
        [array addObject:num];
    }
    NSInteger iu = [self allSettlement1];
    for (int i = 0; i < iu ;i++) {
        NSString *al = array[i];
        NSInteger i = [al integerValue];
        
        
        
        NSString *Name = [self OrderNumberfindProduct:i];
            const char *info = [[self Information:Name] UTF8String];
            const char *price = [[self Price:Name] UTF8String];
        NSInteger qq = [self Number:Name];
        const char *name = [Name UTF8String];
        NSInteger j = [self Rowid:Name];
        
        NSInteger money = [self lookUserMoney:self.UserName];
        if (money < [self price:j]) {
            printf("您卡上余额不足，无法完成交易!\n");
            return;
        }
        if (qq < 1) {
            printf("很抱歉，%s的库存不足，请选择其他产品\n",name);
            return;
        }
        NSString *dad = [self findProductUserName];
        FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
        [d open];
        NSString *dnk = [NSString stringWithFormat:@"%@、%@",dad,Name];
        [d executeUpdate:@"UPDATE UserInformation SET Product = ? WHERE userName = ?",dnk,self.UserName];
        [d close];
        
        NSInteger o = qq - 1;
        [d open];
        [d executeUpdate:@"UPDATE ProductInformation SET Number = ? WHERE rowid = ?",[NSNumber numberWithInteger:o],[NSNumber numberWithInteger:j]];
        [d close];
        NSString *a = [NSString stringWithFormat:@"UPDATE ShoppingCart%@ SET State = '%@' WHERE OrderNumber = '%ld'",self.UserName,@"已付款",i];
        [d open];
        [d executeUpdate:a];
        [d close];
        [self Buy:[self price:j] andName:Name];
        printf("订单%ld 产品:%s 已经结算成功!\n",i,name);
    }
    printf("根据GPS定位您处于:福建省-厦门市-思明区-软件园二期观日路2号楼(中软海晟)\n\t立马发货!\n");
    [self Despatching];
    printf("       恭喜您！\n交易成功，欢迎下次购买!\n");
    
    
}

- (NSString *)findProductUserName
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Product FROM UserInformation WHERE UserName = ?",self.UserName];
    while ([rs next]) {
        NSString *s = [rs stringForColumn:@"Product"];
        [d close];
        return s;
    }
    [d close];
    return @"";
}

- (NSInteger)allSettlement1//用来判断一共有几个订单
{
    
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSInteger i = 0;
    NSString *s = [NSString stringWithFormat:@"SELECT OrderNumber FROM ShoppingCart%@ WHERE State = '%@'",self.UserName,@"未付款"];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        i++;
        
    }
    [d close];
    return i;
}

@end

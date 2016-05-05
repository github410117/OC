//
//  SuperAdministrator.m
//  项目
//
//  Created by etcxm on 16/4/21.
//  Copyright © 2016年 etcxm. All rights reserved.
//

#import "SuperAdministrator.h"
#import "FMDatabase.h"
#import "Userif.h"
#import "OrderInformation.h"
#define class1 @"手机类"
#define class2 @"电脑类"


@implementation SuperAdministrator


- (void)UserInformation
{
    char n[20];
    printf("请输入需要查看的用户名:");
    scanf("%s",n);
    NSString *name = [NSString stringWithCString:n encoding:NSUTF8StringEncoding];
    [self UserInformation:name];
    
        
}

//- (BOOL)panduan:(NSString *)name
//{
//    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
//    if (![d open]) {
//        NSLog(@"打开数据库失败");
//        return NO;
//    }
//    FMResultSet *rs = [d executeQuery:@"SELECT * FROM UserInformation WHERE userName = ?",name];
//    while ([rs next]) {
//        return YES;
//    }
////    NSLog(@"%@",rs);
////    if (rs != NULL) {
////        return YES;
////    }
////    [d close];
//    return NO;
//    
//}

- (BOOL)UserInformation:(NSString *)name
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.UserInformationPath];
    if (![db open]) {
        NSLog(@"查看用户信息时，打开数据库失败");
        return NO;
    }
    NSMutableArray *allarry = [NSMutableArray array];
    FMResultSet *rs = nil;
//    rs = [db executeQuery:@"SELECT UserName,PassWord, FROM UserInformation"];
    rs = [db executeQuery:@"SELECT * FROM UserInformation"];
    while ([rs next]) {
        NSString *str = [rs stringForColumn:@"userName"];
//        NSString *str1 = [rs stringForColumn:@"passWord"];
        NSInteger str2 = [rs intForColumn:@"Money"];
        NSString *str3 = [rs stringForColumn:@"Product"];
        Userif *u = [[Userif alloc] init];
        u.userName = str;
//        u.passWord = str1;
        u.Money = str2;
        u.Product = str3;
        
        
        
        [allarry addObject:u];
    }

//
//    if (allarry == nil) {
//        NSLog(@"没有该用户!");
//        return NO;
//    }else{
    
//    for (Userif *a in allarry) {
//        for (int r = 0; r <= allarry.count; r++) {
//            if (a.userName != name) {
//                NSLog(@"没有该用户");
//                return NO;
//            }
//        }
//    }
//    int j = 0;
////    for (int i = 0 ; i <= allarry.count; i++)
////    {
//    Userif *temp=nil;
//    
//        for (Userif *ue in allarry) {
//            NSString *str = ue.userName;
//            if (str != name) {
//                NSLog(@"还没找到该用户");
//                j++;
//                //continue;
//                
//            }
//            else if(str == name)
//            {
//                temp = ue;
//                NSLog(@"找到该用户");
//                continue;
//            }
//            
//            if(j == allarry.count){
//                NSLog(@"没有该用户");
//                return NO;
//            }
//        }
////    }
//    NSLog(@"")
//    else if(uu.userName != name)
//    {
//        NSLog(@"没有此用户");
//        return NO;
//    }
//
    int i=0;
    for (i=0;i<allarry.count;i++) {
        Userif *uu = allarry[i];
            if ([uu.userName isEqualToString: name]) {
                printf("用户名:%s\n余额:%ld元\n拥有的产品:%s\n",[uu.userName UTF8String],uu.Money,[uu.Product UTF8String]);
                break;
            }
        }
    if (i == allarry.count) {
        NSLog(@"该用户不存在");
    }
    
//        NSLog(@"%@",allarry);
        [db close];
        return YES;
    }
    
//}

- (void)ChangeUserName
{
    printf("请输入需要修改的用户名:");
    char old[20],new[20];
    scanf("%s",old);
    NSString *oldname = [NSString stringWithCString:old encoding:NSUTF8StringEncoding];
    if (![self findUser:oldname]) {
        printf("没有该用户\n");
        return;
    }
    printf("请输入新密码:");
    scanf("%s",new);

    NSString *newname = [NSString stringWithCString:new encoding:NSUTF8StringEncoding];

    
    [self ChangeUserName:oldname andNewname:newname];
}

- (BOOL)ChangeUserName:(NSString *)OldName andNewname:(NSString *)NewName
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    if (![d open]) {
        NSLog(@"更改用户名的时候，打开数据库失败");
        return NO;
    }
//    if([self panduan:OldName]){
    if([d executeUpdate:@"UPDATE UserInformation SET passWord = ? WHERE userName = ?",NewName,OldName])//第一个？是新值，第二个问号是旧值
    {
        printf("密码修改成功!\n");
    }else
    {
        printf("密码修改失败!\n");
        return NO;
    }
    [d close];
    return YES;
//    }
//    NSLog(@"没有这个用户");
    return NO;
    
}

- (void)RemoveUserInformation
{
    printf("请输入需要删除信息的用户名:");
    char a[20];
    scanf("%s",a);
    NSString *name = [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
    if (![self findUser:name]) {
        printf("没有该用户，删除失败!\n");
        return;
    }

    [self RemoveUserInformation:name];
}

- (BOOL)RemoveUserInformation:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    if (![d open]) {
        NSLog(@"删除用户信息时，打开数据库失败");
        return NO;
    }
    if([d executeUpdate:@"DELETE FROM UserInformation WHERE userName = ?",name])
    {
        NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/(%@)UserMoney.TEXT",name];
        NSFileManager *f = [NSFileManager defaultManager];
        if (![f fileExistsAtPath:path]) {
            printf("删除用户资金列表文件失败!\n");
            return NO;
        }
        [f removeItemAtPath:path error:nil];
        if ([self findShoppingCart:name]) {
            [d open];
            NSString *a = [NSString stringWithFormat:@"DROP TABLE ShoppingCart%@",name];
            [d executeUpdate:a];
             [d close];
        }
        
        printf("用户删除成功\n");
       
        return YES;
    }else
    {
        printf("用户删除失败\n");
        [d close];
        return NO;
    }
}


- (BOOL)findShoppingCart:(NSString *)name
{
    NSString *a = [NSHomeDirectory() stringByAppendingString:@"/Documents/UserInformation.sqlite"];
    FMDatabase *d = [FMDatabase databaseWithPath:a];
    [d open];
    NSMutableArray *arry = [NSMutableArray array];
    FMResultSet *rs = [d executeQuery:@"select * from sqlite_master where type='table'"];
    while ([rs next]) {
        NSString *a = [rs stringForColumnIndex:1];
        
        [arry addObject:a];
    }
    NSString *h = [NSString stringWithFormat:@"ShoppingCart%@",name];
    for (NSString *str1 in arry) {
        if ([str1 isEqualToString:h]) {
            [d close];
            return YES;
        }
    }
    [d close];
    return NO;
}

- (void)UserMoneyChange
{
    char name[20];
    printf("请输入需要修改资金的账号:");
    scanf("%s",name);
    NSString *name1 = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    if ([self findUser:name1]) {
        FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
        if (![d open]) {
            NSLog(@"打开数据库失败");
            return;
        }
        FMResultSet *rs = [d executeQuery:@"SELECT Money FROM UserInformation WHERE userName = ?",name1];
        int i = 0;
        while ([rs next]) {
            NSInteger a = [rs intForColumn:@"Money"];
            printf("                 \n");
            printf("该用户目前余额为%ld元!\n",a);
            printf("                 \n");
        loop89:printf("请输入新的余额:");
            char Money;
            scanf("%s",&Money);
            NSString *aa = [NSString stringWithCString:&Money encoding:NSUTF8StringEncoding];
            NSInteger money = [aa integerValue];
            if (money < 0) {
                printf("金额不能为负数!\n");
                i++;
                if (i == 3) {
                    printf("输错三次自动退出!\n");
                    return;
                }
                goto loop89;
            }
            if (money == 0) {
                printf("请输入数字!\n");
                i++;
                if (i == 3) {
                    printf("输错三次自动退出!\n");
                    return;
                }
                goto loop89;
            }
            
//            a += money;
//            [self notes:money andOther:@"存款" andmoney1:a];
            [d executeUpdate:@"UPDATE UserInformation SET Money = ? WHERE userName = ?",[NSNumber numberWithInteger:money],name1];
            [self notes2:money andName:name1];
            printf("修改成功，该账号的余额为:%ld元\n",money);
            [d close];
            return;
        }
        printf("修改失败\n");
        [d close];
        return;
    }
    printf("没有该用户!\n");
    return;
    
    
}

- (void)LookGoods
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    
    //    [d executeUpdate:@"CREATE TABLE ProductImformation(Name TEXT primary Key, Information TXET, Price Integer, Number Integer)"];
    FMResultSet *rs = [d executeQuery:@"SELECT Name FROM ProductInformation"];
    int i =0;
    //    NSMutableArray *allarry = [NSMutableArray array];
    NSMutableArray *allarry1 = [NSMutableArray array];
    while ([rs next]) {
        //        NSString *temp = [rs stringForColumn:@"Information"];
        NSString *temp1 = [rs stringForColumn:@"Name"];
        i++;
        [allarry1 addObject:temp1];
        //        [allarry addObject:temp];
    }
    [d close];
    
    printf("                      \n");
    printf("库房中目前还有%d款商品\n",i);
    for (NSString *str in allarry1) {
        NSInteger j = [self Number:str];
        NSString *a = [self Information:str];
        NSString *b = [self Price:str];
        const char *a1 = [a UTF8String];
        const char *str1 = [str UTF8String];
        const char *b1 = [b UTF8String];
        const char *d1 = [[self Classify:str] UTF8String];
        printf("产品:%s 版本:%s 价格:%s 剩余%ld台! 分类:%s\n",str1,a1,b1,j,d1);
        
    }
    printf("                      \n");
    return;
}

- (NSString *)Classify:(NSString *)name//查分类
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Classify FROM ProductInformation WHERE Name = ?",name];
    while ([rs next]) {
        NSString *i = [rs stringForColumn:@"Classify"];
        [d close];
        return i;
    }
    [d close];
    return @"";
}

- (NSInteger)Number:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Number FROM ProductInformation WHERE Name = ?",name];
    while ([rs next]) {
        NSInteger i = [rs intForColumn:@"Number"];
        [d close];
        return i;
    }
    [d close];
    return 0;
}

- (NSString *)Price:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Price FROM ProductInformation WHERE Name = ?",name];
    while ([rs next]) {
        NSInteger i = [rs intForColumn:@"Price"];
        NSString *t = [NSString stringWithFormat:@"%ld元/台",i];
        [d close];
        return t;
    }
    [d close];
    return @"该商品单价不知";
}

- (NSString *)Information:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Information FROM ProductInformation WHERE Name = ?",name];
    while ([rs next]) {
        NSString *i = [rs stringForColumn:@"Information"];
        [d close];
        return i;
    }
    [d close];
    return @"该商品没有信息!";
}


NSString *information1;
- (void)AddNewGood
{
    int gh = 0;
    char name[1024];
    char information[1024];
    NSInteger price,number;
loop65:printf("请输入需要添加的商品名称:");
    scanf("%s",name);
    NSString *name1 = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    if ([self judge:name1]) {
        printf("该商品已经存在!请重新输入!\n");
        goto loop65;
        }
    printf("请输入该商品的参数:");
    scanf("%s",information);
    information1 = [NSString stringWithCString:information encoding:NSUTF8StringEncoding];
loop66:printf("请输入该商品的售价:");
    char fd[1024];
    scanf("%s",fd);
    NSString *ab = [NSString stringWithCString:fd encoding:NSUTF8StringEncoding];
    if ([self Case:ab]) {
        printf("售价为纯数字，请重新输入!\n");
        gh++;
        if (gh == 3) {
            printf("输入错误3次，添加失败!\n");
            return;
        }
        goto loop66;
    }
    price = [ab integerValue];
    if (price < 0) {
        printf("售价不能为负数!\n");
        gh++;
        if (gh == 3) {
            printf("输入错误3次，添加失败!\n");
            return;
        }
        goto loop66;
    }
    if (price == 0) {
        printf("售价不能为0，我们不做亏本的买卖，请重新输入!\n");
        gh++;
        if (gh == 3) {
            printf("输入错误3次，添加失败!\n");
            return;
        }
        goto loop66;
    }
//    scanf("%ld",&price);
    int nf = 0;
loop67:printf("添加数量:");
    char das[1024];
    scanf("%s",das);
    NSString *abc = [NSString stringWithCString:das encoding:NSUTF8StringEncoding];
    if ([self Case:abc]) {
        printf("数量为纯数字，请重新输入!\n");
        nf++;
        if (nf == 3) {
            printf("输入错误3次，添加失败!\n");
            return;
        }
        goto loop67;
    }
    number = [abc integerValue];
    if (number < 0) {
        printf("数量不能小于0");
        nf++;
        if (nf == 3) {
            printf("输入错误3次，添加失败!\n");
            return;
        }
        goto loop67;
    }
    if (number == 0) {
        printf("数量为纯数字且不为0，请重新输入!\n");
        nf++;
        if (nf == 3) {
            printf("输入错误3次，添加失败!\n");
            return;
        }
        goto loop67;
    }
loop87:printf("请选择分类(1、手机类 2、电脑类):");
    char kd[1024];
    scanf("%s",kd);
    NSString *ij = [NSString stringWithCString:kd encoding:NSUTF8StringEncoding];
    if ([self Case:ij]) {
        printf("请选择正确的分类\n");
        goto loop87;
    }
    NSString *uuu = @"";
    NSInteger jk = [ij integerValue];
    switch (jk) {
        case 1:
            uuu = class1;
            break;
            case 2:
            uuu = class2;
            break;
            
        default:
            printf("请选择正确的分类\n");
            goto loop87;
            break;
    }
    
//    NSLog(@"%@",information1);
    [self Name:name1 Information:information1 Price:price Number:number Classify:uuu];
    
}

- (void)Name:(NSString *)name Information:(NSString *)information Price:(NSInteger)price Number:(NSInteger)number Classify:(NSString *)classify
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    [d executeUpdate:@"INSERT INTO ProductInformation(Name, Information, Price, Number, Classify) VALUES(?,?,?,?,?)",name,information,[NSNumber numberWithInteger:price],[NSNumber numberWithInteger:number],classify];
    [d close];
    printf("恭喜!商品添加成功\n");
    [self AddGoods11:name];
    
}


- (void)AddGoods11:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    FMResultSet *rs = [d executeQuery:@"SELECT Name FROM ProductInformation"];
    NSMutableArray *allarry1 = [NSMutableArray array];
    while ([rs next]) {
        NSString *temp1 = [rs stringForColumn:@"Name"];
        [allarry1 addObject:temp1];
    }
    [d close];
    for (NSString *str in allarry1) {
        if ([str isEqualToString:name]) {
            NSInteger j = [self Number:str];
            NSString *a = [self Information:str];
            NSString *b = [self Price:str];
            const char *a1 = [a UTF8String];
            const char *str1 = [str UTF8String];
            const char *b1 = [b UTF8String];
            printf("%s %s %s 剩余%ld台!\n",str1,a1,b1,j);
            
        }
    }
}

- (void)RemoveGood
{
    char name[20],pwd[20];
loop1:printf("请输入需要删除的商品的名称:");
    scanf("%s",name);
    NSString *name1 = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
loop:printf("请输入管理员密码确认:");
    scanf("%s",pwd);
    if ([self judge:name1]) {
        NSString *pwd1 = [NSString stringWithCString:pwd encoding:NSUTF8StringEncoding];
        if ([pwd1 isEqualToString:AdministratorPassWord]) {
            [self RemoveGood:name1];
        }else
        {
            printf("管理员密码不正确!\n");
            goto loop;
        }
    }else
    {
        printf("经查询，没有该商品，请重新输入!\n");
        goto loop1;
    }
    
}

- (void)RemoveGood:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    [d executeUpdate:@"DELETE FROM ProductInformation WHERE Name = ?",name];
    [d close];
    const char *name1 = [name UTF8String];
    printf("%s 商品删除成功\n",name1);
}

- (void)ChangeGoods
{
    char name[20];
loop:printf("请输入需要修改的商品名称:");
    scanf("%s",name);
    NSString *name1 = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    if (![self judge:name1]) {
        printf("库存中没有该商品!,请重新输入!\n");
        goto loop;
    }
    printf("商品信息如下!\n");
    [self AddGoods11:name1];
    while (1) {
    loop1:printf("请问需要修改商品的什么信息\n");
        printf("1、商品参数\n");
        printf("2、商品价格\n");
        printf("3、商品数量\n");
        printf("4、返回上级菜单\n");
    loop4:printf("请输入:");
        char rr[1024];
        scanf("%s",rr);
        NSString *ar = [NSString stringWithCString:rr encoding:NSUTF8StringEncoding];
        if ([self Case:ar]) {
            printf("输入错误，请重新输入!\n");
            goto loop4;
        }
        NSInteger i = ar.length;
        if (i > 1) {
            printf("输入错误，请重新输入!\n");
            goto loop4;
            
        }
        NSInteger ra = [ar integerValue];

            switch (ra) {
                case 1:
                    [self ChangeGoodsInformation:name1];
                    break;
                case 2:
                    [self ChangeGoodsPrice:name1];
                    break;
                case 3:
                    [self ChangeGoodsNumber:name1];
                case 4:
                    return;
                    break;
                default:
                    printf("没有这个选项，请重新输入!\n");
                    goto loop1;
                    break;
            }
        }
    }



- (void)ChangeGoodsInformation:(NSString *)name
{
    char info[1024];
    printf("请输入新的参数:");
    scanf("%s",info);
    NSString *info1 = [NSString stringWithCString:info encoding:NSUTF8StringEncoding];
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    [d executeUpdate:@"UPDATE ProductInformation SET Information = ? WHERE Name = ?",info1,name];
    [d close];
    printf("修改成功，修改后该商品的信息如下!\n");
    [self AddGoods11:name];
}

- (void)ChangeGoodsPrice:(NSString *)name
{
    int t = 0;
loop:printf("请输入该商品的新价格:");
    char de[1024];
    scanf("%s",de);
    NSString *du = [NSString stringWithCString:de encoding:NSUTF8StringEncoding];
    if ([self Case:du]) {
        printf("请输入正确的价格，价格为纯数字!\n");
        t++;
        if (t == 3) {
            printf("添加失败，自动退出!\n");
            return;
        }
        goto loop;
    }
    NSInteger i = [du integerValue];
    if (i < 1) {
        printf("价格不能为0或0以下的数!会亏本的!\n");
        t++;
        if (t == 3) {
            printf("添加失败，自动退出!\n");
            return;
        }
        goto loop;
    }
    if (i == 0) {
        printf("请输入正确的价格，价格为纯数字!\n");
        t++;
        if (t == 3) {
            printf("添加失败，自动退出!\n");
            return;
        }
        goto loop;
    }
    
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    [d executeUpdate:@"UPDATE ProductInformation SET Price = ? WHERE Name = ?",[NSNumber numberWithInteger:i],name];
    [d close];
    printf("修改成功，修改后该商品的信息如下!\n");
    [self AddGoods11:name];
}

- (void)ChangeGoodsNumber:(NSString *)name
{
    int u = 0;
loop:printf("请输入该商品的新数量:");
    char de[1024];
    scanf("%s",de);
    NSString *du = [NSString stringWithCString:de encoding:NSUTF8StringEncoding];
    if ([self Case:du]) {
        printf("请输入正确的数量，数量为纯数字!\n");
        u++;
        if (u == 3) {
            printf("添加失败,自动退出!\n");
            return;
        }
        goto loop;
    }
    NSInteger i = [du integerValue];
    if (i < 0) {
        printf("请输入正确的数量，数量为正数!\n");
        u++;
        if (u == 3) {
            printf("添加失败,自动退出!\n");
            return;
        }
        goto loop;
    }
    
    
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    [d executeUpdate:@"UPDATE ProductInformation SET Number = ? WHERE Name = ?",[NSNumber numberWithInteger:i],name];
    [d close];
    printf("修改成功，修改后该商品的信息如下!\n");
    [self AddGoods11:name];
}

- (void)AdminlookOrder
{
    char name[1024];
loop:printf("请输入您要查看的用户账户:");
    scanf("%s",name);
    NSString *a = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    if (![self findUser:a]) {
        printf("没有该用户!请重新输入!\n");
        goto loop;
    }
    printf("            \n");
    [self Orderlook:a];
    printf("             \n");
    printf("1、关闭订单\n");
    printf("2、返回\n");
    char i[1024];
    printf("            \n");
loop1:printf("请输入选项:");
    scanf("%s",i);
    NSString *ss = [NSString stringWithCString:i encoding:NSUTF8StringEncoding];
    if ([self Case:ss]) {
        printf("请输入正确的选项\n");
        goto loop1;
    }
    NSInteger df = [ss integerValue];
    switch (df) {
        case 1:
            [self adminCloseOrder:a];
            break;
        case 2:
            return;
            break;
            
        default:
            printf("没有这个选项!请重新输入!\n");
            goto loop1;
            break;
    }
}

- (void)adminCloseOrder:(NSString *)name//管理员关闭订单
{
    int e = 0;
    //    printf("请输入需要查看的用户名");
loop33:printf("请输入需要关闭的订单号:");
    char j[1024];
    scanf("%s",j);
    NSString *jj = [NSString stringWithCString:j encoding:NSUTF8StringEncoding];
    if ([self Case:jj]) {
        printf("订单号为纯数字，请重新输入!\n");
        e++;
        if (e == 3) {
            printf("输入错误3次,自动退出!\n");
            return;
        }
        goto loop33;
    }
    NSInteger i = [jj integerValue];
    if (i == 0) {
        printf("您输入的订单号有误,请重新输入!\n");
        e++;
        if (e == 3) {
            printf("输入错误3次,自动退出!\n");
            return;
        }
        goto loop33;
    }
    if (![self OrderNumberfindState3:i andName:name]) {
        printf("您输入的订单已经完成了交易,请重新输入!\n");
        e++;
        if (e == 3) {
            printf("输入错误3次,自动退出!\n");
            return;
        }
        goto loop33;
    }
    
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    //    NSString *s = [NSString stringWithFormat:@"DELETE FROM ShoppingCart%@ WHERE OrderNumber = '%d'",self.UserName,i];
    //    [d executeUpdate:s];
    NSString *ss = [NSString stringWithFormat:@"SELECT Product FROM ShoppingCart%@ WHERE OrderNumber = '%ld'",name,i];
    FMResultSet *rs = [d executeQuery:ss];
    NSMutableArray *arry = [NSMutableArray array];
    while ([rs next]) {
        NSString *a = [rs stringForColumn:@"Product"];
        [arry addObject:a];
    }
    for (NSString *aa in arry) {
        NSInteger j = [self Number:aa];
        [d executeUpdate:@"UPDATE ProductInformation SET Number = ? WHERE Name = ?",[NSNumber numberWithInteger:j + 1],aa];
    }
    NSString *s4 = [NSString stringWithFormat:@"UPDATE ShoppingCart%@ SET State = '%@' WHERE OrderNumber = '%ld'",name,@"已关闭",i];
    [d executeUpdate:s4];
    [d close];
    printf("订单%ld已经关闭成功!\n",i);
}

- (BOOL)OrderNumberfindState3:(NSInteger)order andName:(NSString *)name//管理员根据订单号来查询有没有对应的没付款的订单
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *s = [NSString stringWithFormat:@"SELECT OrderNumber FROM ShoppingCart%@ WHERE State = '%@' and OrderNumber = '%ld'",name,@"未付款",order];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        [d close];
        return YES;
    }
    [d close];
    return NO;
}

- (void)Orderlook:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    if (![self lookOrderInformation3:name]) {
        printf("该用户暂时没有任何的订单\n");
        return;
    }
    NSMutableArray *allarry = [NSMutableArray array];
    NSString *s = [NSString stringWithFormat:@"SELECT * FROM ShoppingCart%@",name];
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
    printf("该用户所有的订单信息如下:\n");
    for (OrderInformation *oo in allarry) {
        const char *s = [oo.Product UTF8String];
        const char *s1 = [oo.OrderNumber UTF8String];
        const char *s2 = [oo.State UTF8String];
        printf("订单编号:%s\t产品型号:%s\t\t付款状态:%s\n",s1,s,s2);
    }
}

- (BOOL)lookOrderInformation3:(NSString *)name
{
    FMDatabase *d = [FMDatabase databaseWithPath:self.UserInformationPath];
    [d open];
    NSString *s = [NSString stringWithFormat:@"SELECT rowid FROM ShoppingCart%@",name];
    FMResultSet *rs = [d executeQuery:s];
    while ([rs next]) {
        [d close];
        return YES;
    }
    [d close];
    return NO;
}


- (void)Despatching;//发货
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",@"Despatching.txt"];
    //    NSLog(@"%@",path);
    NSFileManager *f = [NSFileManager defaultManager];
    if (![f fileExistsAtPath:path]) {
        [f createFileAtPath:path contents:nil attributes:nil];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:path];
        NSInteger num =(arc4random() % 100000000) + 999999999;
        NSInteger u = 98392893289;
        [h seekToEndOfFile];
        NSDateFormatter *d = [[NSDateFormatter alloc] init];
        [d setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *c = [d stringFromDate:[NSDate date]];
        c = [c stringByAppendingString:@"  已收件\n"];
        //        NSLog(@"%@",c);
        //        NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
        NSString *g = [NSString stringWithFormat:@"订单状态:已发货\n物流编号:%ld\n运单编号:%ld\n物流公司:顺丰速运\n物流动态:\n%@",num,u,c];
        NSData *data = [g dataUsingEncoding:NSUTF8StringEncoding];
        [h writeData:data];
        [h closeFile];
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:8];
        NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:path];
        [h seekToEndOfFile];
        NSDateFormatter *d = [[NSDateFormatter alloc] init];
        [d setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *c = [d stringFromDate:[NSDate date]];
        c = [c stringByAppendingString:@"  快件在 北京,准备送往下一站 北京集散中心\n"];
        NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
        [h writeData:data];
        [h closeFile];
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:13];
        NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:path];
        [h seekToEndOfFile];
        NSDateFormatter *d = [[NSDateFormatter alloc] init];
        [d setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *c = [d stringFromDate:[NSDate date]];
        c = [c stringByAppendingFormat:@"  快件在 北京集散中心,准备送往下一站 厦门集散中心\n"];
        //        c = [c stringByAppendingString:@"  快件在 北京集散中心,准备送往下一站 厦门集散中心\n"];
        NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
        [h writeData:data];
        [h closeFile];
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:19];
        NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:path];
        [h seekToEndOfFile];
        NSDateFormatter *d = [[NSDateFormatter alloc] init];
        [d setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *c = [d stringFromDate:[NSDate date]];
        c = [c stringByAppendingFormat:@"  快件在 厦门集散中心,准备送往下一站 思明区集散点\n"];
        //        c = [c stringByAppendingString:@"  快件在 厦门集散中心,准备送往下一站 思明区派件点\n"];
        NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
        [h writeData:data];
        [h closeFile];
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:26];
        NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:path];
        [h seekToEndOfFile];
        NSDateFormatter *d = [[NSDateFormatter alloc] init];
        [d setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *c = [d stringFromDate:[NSDate date]];
        c = [c stringByAppendingString:@"  快递员:XXX 已经从送货点出发，请您保持电话畅通!\n"];
        NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
        [h writeData:data];
        [h closeFile];
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:32];
        NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:path];
        [h seekToEndOfFile];
        NSDateFormatter *d = [[NSDateFormatter alloc] init];
        [d setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *c = [d stringFromDate:[NSDate date]];
        c = [c stringByAppendingString:@"  签收成功:签收人为本人\n"];
        NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
        [h writeData:data];
        [h closeFile];
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:33];
        NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:path];
        [h seekToEndOfFile];
        NSDateFormatter *d = [[NSDateFormatter alloc] init];
        [d setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *c = [d stringFromDate:[NSDate date]];
        c = [c stringByAppendingString:@"  感谢您选择顺丰速运!\n"];
        NSData *data = [c dataUsingEncoding:NSUTF8StringEncoding];
        [h writeData:data];
        [h closeFile];
        
    });
    
}



- (void)LookDespatching
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",@"Despatching.txt"];
    NSFileHandle *h = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [h readDataToEndOfFile];
    const char *d = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] UTF8String];
    printf("%s",d);
    [h closeFile];
}

@end

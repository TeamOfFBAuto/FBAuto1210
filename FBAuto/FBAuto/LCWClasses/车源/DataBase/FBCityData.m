//
//  FBCityData.m
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCityData.h"
#import "DataBase.h"
#import "FBCity.h"

#import "PeizhiModel.h"

#import "CarClass.h"
#import "XMPPMessageModel.h"

@implementation FBCityData

+ (NSArray *)getSubCityWithProvinceId:(int)privinceId
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where provinceId = ? and isProvince = 0", -1, &stmt, nil);
    NSLog(@"All subcities result = %d",result);
    NSMutableArray *subCityArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, privinceId);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            int cityId = sqlite3_column_int(stmt, 1);
            int provinceId = sqlite3_column_int(stmt, 3);
            
            FBCity *province = [[FBCity alloc]initSubcityWithName:[NSString stringWithUTF8String:(const char *)cityName] cityId:cityId provinceId:provinceId];
            [subCityArray addObject:province];
        }
    }
    sqlite3_finalize(stmt);
    return subCityArray;
    
}


+ (NSArray *)getAllProvince
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where isProvince = 1", -1, &stmt, nil);
    NSLog(@"All subcities result = %d",result);
    NSMutableArray *subCityArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            int cityId = sqlite3_column_int(stmt, 1);
            FBCity *province = [[FBCity alloc]initProvinceWithName:[NSString stringWithUTF8String:(const char *)cityName] provinceId:cityId];
            [subCityArray addObject:province];
        }
    }
    sqlite3_finalize(stmt);
    return subCityArray;
    
}

+ (NSString *)cityNameForId:(int)cityId
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where id = ?", -1, &stmt, nil);
    
    NSLog(@"All subcities result = %d %d",result,cityId);

    if (result == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, cityId);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            
            return [NSString stringWithUTF8String:(const char *)cityName];
        }
    }
    sqlite3_finalize(stmt);
    return @"";
}

+ (int)cityIdForName:(NSString *)cityName//根据城市名获取id
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where name = ?", -1, &stmt, nil);
    
    NSLog(@"All subcities result = %d %@",result,cityName);
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [cityName UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            
            int cityId = sqlite3_column_int(stmt, 1);
            
            return cityId;
        }
    }
    sqlite3_finalize(stmt);
    return 0;
}


#pragma - mark 车型数据保存

//品牌
+ (void)insertCarBrandId:(NSString *)brandId brandName:(NSString *)name firstLetter:(NSString *)firstLetter
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, "insert into carBrand(id,name,firstLetter) values(?,?,?)", -1, &stmt, nil);//?相当于%@格式
    
    sqlite3_bind_text(stmt, 1, [brandId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [firstLetter UTF8String], -1, NULL);
    
    result = sqlite3_step(stmt);
    
    NSLog(@"save brand %@ brandResult:%d",name,result);
    
    sqlite3_finalize(stmt);
}
//车型
+ (void)insertCarTypeId:(NSString *)typeId parentId:(NSString *)parentId typeName:(NSString *)name firstLetter:(NSString *)firstLetter
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    NSString *codeId = [NSString stringWithFormat:@"%@%@",parentId,typeId];
    int result = sqlite3_prepare(db, "insert into carType(id,parentId,name,firstLetter,codeId) values(?,?,?,?,?)", -1, &stmt, nil);//?相当于%@格式
    
    sqlite3_bind_text(stmt, 1, [typeId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [parentId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [firstLetter UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [codeId UTF8String], -1, NULL);
    
    result = sqlite3_step(stmt);
    NSLog(@"save type %@ typeResult:%d",name,result);
    
    sqlite3_finalize(stmt);
}
//车款
+ (void)insertCarStyleId:(NSString *)StyleId parentId:(NSString *)parentId StyleName:(NSString *)name
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    NSString *codeId = [NSString stringWithFormat:@"%@%@",parentId,StyleId];
    
    NSLog(@"codeId---------> %@",codeId);
    
    int result = sqlite3_prepare(db, "insert into carStyle(id,parentId,name,codeId) values(?,?,?,?)", -1, &stmt, nil);//?相当于%@格式
    
    sqlite3_bind_text(stmt, 1, [StyleId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [parentId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [codeId UTF8String], -1, NULL);
    result = sqlite3_step(stmt);
    
    NSLog(@"save style %@ result:%d",name,result);
    
    
    
    sqlite3_finalize(stmt);
}

#pragma mark - 车型数据判断是否存在

//是否存在
+ (BOOL)existCarBrandId:(NSString *)brandId//品牌是否存在
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, "select count(*) from carBrand where id = ?", -1, &stmt, nil);
    
    NSLog(@"existCarBrandId %d %@",result,brandId);
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [brandId UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int count = sqlite3_column_int(stmt, 0);
            
            if (count > 0) {
                return YES;
            }
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}


+ (BOOL)existCarTypeId:(NSString *)codeId//车型
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, "select count(*) from carType where codeId = ?", -1, &stmt, nil);
    
    NSLog(@"existCarTypeId series %d %@",result,codeId);
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [codeId UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int count = sqlite3_column_int(stmt, 0);
            
            if (count > 0) {
                return YES;
            }
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

+ (BOOL)existCarStyleId:(NSString *)codeId//车款
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, "select count(*) from carStyle where codeId = ?", -1, &stmt, nil);
    
    NSLog(@"existCarStyleId %d %@",result,codeId);
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [codeId UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int count = sqlite3_column_int(stmt, 0);
            
            if (count > 0) {
                return YES;
            }
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

#pragma mark - 车型数据更新

+ (void)updateCarBrandId:(NSString *)brandId
               brandName:(NSString *)name
             firstLetter:(NSString *)firstLetter//品牌
{
    if (brandId == nil || name.length == 0 || firstLetter.length == 0) {
        return;
    }
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, "update carBrand set name = ?,firstLetter = ? where id = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [firstLetter UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [brandId UTF8String], -1, nil);
    
    if (result == SQLITE_OK) {

       result = sqlite3_step(stmt);
        
    }
    
    if (result == SQLITE_DONE) {
        NSLog(@"updateCarBrandId %@ success name %@",brandId,name);
    }
    sqlite3_finalize(stmt);
}

+ (void)updateCarTypeId:(NSString *)codeId
               typeName:(NSString *)name
            firstLetter:(NSString *)firstLetter//车型
{
    NSLog(@"---->codId:%@ name:%@ firstLetter:%@",codeId,name,firstLetter);
    
    if (codeId == nil || firstLetter.length == 0 || name.length == 0) {
        return;
    }
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, "update carType set name = ?,firstLetter = ? where codeId = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [firstLetter UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [codeId UTF8String], -1, nil);
    
    if (result == SQLITE_OK) {
        
        result = sqlite3_step(stmt);
        
    }
    
    if (result == SQLITE_DONE) {
        NSLog(@"updateCarTypeId %@ success %@",codeId,name);
    }
    
    sqlite3_finalize(stmt);

}

+ (void)updateCarStyleId:(NSString *)codeId
               StyleName:(NSString *)name//车款
{
    if (codeId == nil || name.length == 0) {
        return;
    }
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, "update carStyle set name = ? where codeId = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [codeId UTF8String], -1, nil);
    
    if (result == SQLITE_OK) {
        
        result = sqlite3_step(stmt);
        
    }
    
    if (result == SQLITE_DONE) {
        NSLog(@"updateCarStyleId %@ success",codeId);
    }
    
    sqlite3_finalize(stmt);
}


#pragma - mark 车型数据查询


+ (NSArray *)queryAllCarBrand
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carBrand", -1, &stmt, nil);
    NSLog(@"All carBrand result = %d",result);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *brandId = sqlite3_column_text(stmt, 0);
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            const unsigned char *firstLetter = sqlite3_column_text(stmt, 2);
            
            CarClass *aObjcet = [[CarClass alloc]initWithBrandId:[NSString stringWithUTF8String:(const char *)brandId] brandName:[NSString stringWithUTF8String:(const char *)name] brandFirstName:[NSString stringWithUTF8String:(const char *)firstLetter]];
            
            [resultArray addObject:aObjcet];
        }
    }
    sqlite3_finalize(stmt);
    return resultArray;
}
+ (NSArray *)queryCarTypeWithParentId:(NSString *)superId
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carType where parentId = ? order by codeId desc", -1, &stmt, nil);
    NSLog(@"All carType result = %d",result);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [superId UTF8String], -1, Nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *id = sqlite3_column_text(stmt, 0);
            const unsigned char *parentId = sqlite3_column_text(stmt, 1);
            const unsigned char *name = sqlite3_column_text(stmt, 2);
            const unsigned char *firstLetter = sqlite3_column_text(stmt, 3);
            
            CarClass *aObjcet = [[CarClass alloc]initWithParentId:
                                 [NSString stringWithUTF8String:(const char *)parentId] typeId:[NSString stringWithUTF8String:(const char *)id] typeName:[NSString stringWithUTF8String:(const char *)name] firstLetter:[NSString stringWithUTF8String:(const char *)firstLetter]];
            
            [resultArray addObject:aObjcet];
        }
    }
    sqlite3_finalize(stmt);
    return resultArray;
}

//车款

+ (NSArray *)queryCarStyleWithParentId:(NSString *)superId
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carStyle where parentId = ? order by codeId desc", -1, &stmt, nil);
    NSLog(@"All carType result = %d",result);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [superId UTF8String], -1, Nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *id = sqlite3_column_text(stmt, 0);
            const unsigned char *parentId = sqlite3_column_text(stmt, 1);
            const unsigned char *name = sqlite3_column_text(stmt, 2);
            
            CarClass *aObjcet = [[CarClass alloc]initWithParentId:[NSString stringWithUTF8String:(const char *)parentId] styleId:[NSString stringWithUTF8String:(const char *)id] styleName:[NSString stringWithUTF8String:(const char *)name]];
            
            [resultArray addObject:aObjcet];
        }
    }
    sqlite3_finalize(stmt);
    return resultArray;
}

#pragma - mark 清空车型数据

+ (BOOL)deleteAllCarData
{
    
    return [DataBase removeDb];
}


#pragma - mark 保存消息

/**
 *  判断是否存在 当前用户、from用户的数据，有的话返回条数，没有返回 -1
 */
+ (int)numberOfExist:(NSString *)currentUser fromUser:(NSString *)fromUser
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    //先查询未读数, -1
    int result1= sqlite3_prepare_v2(db, "select unReadSum from xmppMessage where currentUser = ? and fromPhone = ?", -1, &stmt, nil);
    if (result1 == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [currentUser UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [fromUser UTF8String], -1, nil);
        
        int ss = sqlite3_step(stmt);
        
        while (ss == SQLITE_ROW) {
            
            int num = sqlite3_column_int(stmt, 0);
            
            return num;
        }
    }
    sqlite3_finalize(stmt);
    
    return -1;
}

// clearReadSum 为 yes 时将unReadSum 置为0,反之则 +1

+ (void)updateCurrentUserPhone:(NSString *)currentPhone fromUserPhone:(NSString *)FromPhone fromName:(NSString *)fromName fromId:(NSString *)fromId newestMessage:(NSString *)message time:(NSString *)time clearReadSum:(BOOL)clearSum
{
    NSLog(@"updateCurrentUserPhone %@ %@ %@ %@ %@",currentPhone,FromPhone,fromName,fromId,message);
    int number = [self numberOfExist:currentPhone fromUser:FromPhone];
    
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    if (number == -1) {
        //插入
        
        //满足nil时说明消息无效,此时不记录
        if (currentPhone == nil || FromPhone == nil || fromName == nil || fromId == nil || message == nil || time == nil) {
            return;
        }
        
        
        //unReadSum = 0,说明没有未读消息 > 0有未读消息
        int result = sqlite3_prepare(db, "insert into xmppMessage(currentUser,fromPhone,fromName,newestMessage,time,unReadSum,fromId) values(?,?,?,?,?,?,?)", -1, &stmt, nil);//?相当于%@格式
        
        sqlite3_bind_text(stmt, 1, [currentPhone UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [FromPhone UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [fromName UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [message UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [time UTF8String], -1, NULL);
        
        sqlite3_bind_text(stmt, 7, [fromId UTF8String], -1, NULL);
        
        if (clearSum) {
            number = 0;
        }else
        {
            number = 1;
        }
        sqlite3_bind_int(stmt, 6, number);
        result = sqlite3_step(stmt);
        
        NSLog(@"save xmppMessage %@ fromId:%@ result:%d",fromName,fromId,result);
        
    }else
    {
        
        if (clearSum) {
            
            int result2;
            
            if (message.length > 0) {
                
                result2 = sqlite3_prepare(db, "update xmppMessage set unReadSum = ?,newestMessage = ? where currentUser = ? and fromPhone = ?", -1, &stmt, nil);
                
                sqlite3_bind_int(stmt, 1, 0);
                sqlite3_bind_text(stmt, 2, [message UTF8String], -1, nil);
                sqlite3_bind_text(stmt, 3, [currentPhone UTF8String], -1, nil);
                sqlite3_bind_text(stmt, 4, [FromPhone UTF8String], -1, nil);
                
            }else
            {
                result2 = sqlite3_prepare(db, "update xmppMessage set unReadSum = ? where currentUser = ? and fromPhone = ?", -1, &stmt, nil);
                
                sqlite3_bind_int(stmt, 1, 0);
                sqlite3_bind_text(stmt, 2, [currentPhone UTF8String], -1, nil);
                sqlite3_bind_text(stmt, 3, [FromPhone UTF8String], -1, nil);
            }
            
            if (result2 == SQLITE_OK) {
                
                int resultx = sqlite3_step(stmt);
                NSLog(@"resultx %d",resultx);
            }
            
        }else
        {
           number ++;
            
            int result2 = sqlite3_prepare(db, "update xmppMessage set unReadSum = ? ,newestMessage = ?,time = ? where currentUser = ? and fromPhone = ?", -1, &stmt, nil);
            if (result2 == SQLITE_OK) {
                
                sqlite3_bind_int(stmt, 1, number);
                sqlite3_bind_text(stmt, 2, [message UTF8String], -1, nil);
                sqlite3_bind_text(stmt, 3, [time UTF8String], -1, nil);
                sqlite3_bind_text(stmt, 4, [currentPhone UTF8String], -1, nil);
                sqlite3_bind_text(stmt, 5, [FromPhone UTF8String], -1, nil);
                int resultx = sqlite3_step(stmt);
                NSLog(@"resultx %d",resultx);
            }
        }
        
        NSLog(@"number --> %d",number);
        
        
    }
    
    sqlite3_finalize(stmt);
    
    NSDictionary *dic = @{@"fromPhone":FromPhone ? FromPhone : @"",@"fromName":fromName ? fromName : @"",@"unreadNum":[NSString stringWithFormat:@"%d",number]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fromUnread" object:nil userInfo:dic];
}

//当前用户所有未读条数

+ (int)numberOfUnreadMessage:(NSString *)currentUser
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int sum = 0;
    //先查询未读数, -1
    int result1= sqlite3_prepare_v2(db, "select unReadSum from xmppMessage where currentUser = ? and unReadSum > 0", -1, &stmt, nil);
    if (result1 == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [currentUser UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int num = sqlite3_column_int(stmt, 0);
            
            sum = sum + num;
        }
    }
    sqlite3_finalize(stmt);
    
    return sum;
}

+ (int)numberOfUnreadMessageFromUser:(NSString *)fromPhone
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
   
    int result1= sqlite3_prepare_v2(db, "select unReadSum from xmppMessage where fromPhone = ?", -1, &stmt, nil);
    if (result1 == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [fromPhone UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int num = sqlite3_column_int(stmt, 0);
            
            return num;
        }
    }
    sqlite3_finalize(stmt);
    
    return 0;
}

+ (NSArray *)queryAllNewestMessageForUser:(NSString *)currentUser
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int result1= sqlite3_prepare_v2(db, "select * from xmppMessage where currentUser = ? order by time desc", -1, &stmt, nil);
    
    NSMutableArray *resultArr = [NSMutableArray array];
    
    if (result1 == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [currentUser UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            const unsigned char *fromPhone = sqlite3_column_text(stmt, 1);
            const unsigned char *fromName = sqlite3_column_text(stmt, 2);
            const unsigned char *message = sqlite3_column_text(stmt, 3);
            const unsigned char *time = sqlite3_column_text(stmt, 4);
            const unsigned char *fromId = sqlite3_column_text(stmt, 6);
            
            NSString *mes = @"";
            if (message != nil) {
                mes = [NSString stringWithUTF8String:(const char *)message];
            }
            
            XMPPMessageModel *aModel = [[XMPPMessageModel alloc]initWithFromPhone:[NSString stringWithUTF8String:(const char *)fromPhone] fromName:[NSString stringWithUTF8String:(const char *)fromName] fromId:[NSString stringWithUTF8String:(const char *)fromId]  newestMessage:mes time:[NSString stringWithUTF8String:(const char *)time]];
            [resultArr addObject:aModel];
        }
    }
    sqlite3_finalize(stmt);
    
    return resultArr;
}

#pragma mark 车源配置保存

+ (BOOL)insertCarConfigId:(NSString *)sid
                      pid:(NSString *)pid
              nodename:(NSString *)nodename
                 dateline:(NSString *)dateline
                   uptime:(NSString *)uptime
                    isdel:(NSString *)isdel
{
    
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, "insert into carConfig(id,pid,nodename,dateline,uptime,isdel) values(?,?,?,?,?,?)", -1, &stmt, nil);//?相当于%@格式
    
    sqlite3_bind_int(stmt, 1, [sid intValue]);
    sqlite3_bind_int(stmt, 2, [pid intValue]);
    sqlite3_bind_text(stmt, 3, [nodename.length > 0 ? nodename : @" " UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [dateline.length > 0 ? dateline : @" " UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [uptime.length > 0 ? uptime : @" " UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 6,[isdel intValue]);
    result = sqlite3_step(stmt);
    
    NSLog(@"save carConfig %@ result:%d",nodename,result);
    
    sqlite3_finalize(stmt);
    
    if (result == SQLITE_DONE) {
        
        return YES;
    }
    
    return NO;

}

#pragma - mark 车型配置数据查询

//未标记删除的数据
+ (NSArray *)queryAllConfig
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carConfig where isdel = 0", -1, &stmt, nil);
    NSLog(@"All carConfig result = %d",result);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        //id,pid,nodename,dateline,uptime,isdel
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int cid = sqlite3_column_int(stmt, 0);
            int pid = sqlite3_column_int(stmt, 1);
            const unsigned char *nodename = sqlite3_column_text(stmt, 3);
            const unsigned char *dateline = sqlite3_column_text(stmt, 4);
            const unsigned char *uptime = sqlite3_column_text(stmt, 5);
            
            PeizhiModel *aModel = [[PeizhiModel alloc]init];
            aModel.id = [NSString stringWithFormat:@"%d",cid];
            aModel.pid = [NSString stringWithFormat:@"%d",pid];
            aModel.nodename = [NSString stringWithUTF8String:(const char *)nodename];
            aModel.dateline = [NSString stringWithUTF8String:(const char *)dateline];
            aModel.uptime = [NSString stringWithUTF8String:(const char *)uptime];
            aModel.isdel = @"0";
            [resultArray addObject:aModel];
        }
    }
    sqlite3_finalize(stmt);
    return resultArray;
}

/**
 *  根据pid获取配置数据
 *
 *  @param pid 上级id
 */

+ (NSArray *)queryConfigWithPid:(NSString *)pid
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carConfig where pid = ? and isdel = 0", -1, &stmt, nil);
    NSLog(@"All carConfig result = %d",result);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    
    if (result == SQLITE_OK) {
        //id,pid,nodename,dateline,uptime,isdel
        
        sqlite3_bind_int(stmt, 1, [pid intValue]);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int cid = sqlite3_column_int(stmt, 0);
            int pid = sqlite3_column_int(stmt, 1);
            const unsigned char *nodename = sqlite3_column_text(stmt, 2);
            const unsigned char *dateline = sqlite3_column_text(stmt, 3);
            const unsigned char *uptime = sqlite3_column_text(stmt, 4);
            
            PeizhiModel *aModel = [[PeizhiModel alloc]init];
            aModel.id = [NSString stringWithFormat:@"%d",cid];
            aModel.pid = [NSString stringWithFormat:@"%d",pid];
            aModel.nodename = [NSString stringWithUTF8String:(const char *)nodename];
            aModel.dateline = [NSString stringWithUTF8String:(const char *)dateline];
            aModel.uptime = [NSString stringWithUTF8String:(const char *)uptime];
            aModel.isdel = @"0";
            [resultArray addObject:aModel];
        }
    }
    sqlite3_finalize(stmt);
    return resultArray;
}

//查询配置name
+ (NSString *)queryConfigNameWithid:(int)cid
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carConfig where id = ?", -1, &stmt, nil);
    NSLog(@"carConfig name result = %d",result);
    if (result == SQLITE_OK) {
        //id,pid,nodename,dateline,uptime,isdel
        
        sqlite3_bind_int(stmt, 1, cid);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {

            const unsigned char *nodename = sqlite3_column_text(stmt, 2);
            
            return [NSString stringWithUTF8String:(const char *)nodename];
        }
    }
    sqlite3_finalize(stmt);
    return @"未知配置";
}

//是否存在
+ (BOOL)existCarPeizhiId:(NSString *)peizhiId//配置是否已存在
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, "select count(*) from carConfig where id = ?", -1, &stmt, nil);
    
    NSLog(@"existCarPeizhiId %d %@",result,peizhiId);
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [peizhiId UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int count = sqlite3_column_int(stmt, 0);
            
            if (count > 0) {
                return YES;
            }
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

//更新配置数据

+ (BOOL)updateCarConfigId:(NSString *)sid
                      pid:(NSString *)pid
                 nodename:(NSString *)nodename
                 dateline:(NSString *)dateline
                   uptime:(NSString *)uptime
                    isdel:(NSString *)isdel
{
    if (sid == nil || nodename.length == 0) {
        return NO;
    }
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, "update carConfig set pid = ?,nodename = ?,dateline = ?,uptime = ?,isdel = ? where id = ?", -1, &stmt, nil);
    
    sqlite3_bind_int(stmt, 6, [sid intValue]);
    sqlite3_bind_int(stmt, 1, [pid intValue]);
    sqlite3_bind_text(stmt, 2, [nodename.length > 0 ? nodename : @" " UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [dateline.length > 0 ? dateline : @" " UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [uptime.length > 0 ? uptime : @" " UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 5,[isdel intValue]);
    
    if (result == SQLITE_OK) {
        
        result = sqlite3_step(stmt);
        
    }
    sqlite3_finalize(stmt);
    
    if (result == SQLITE_DONE) {
        NSLog(@"updateCarConfigId %@ success name %@",sid,nodename);
        
        return YES;
    }
    
    return NO;
}

@end

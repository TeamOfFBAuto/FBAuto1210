//
//  UserHomeController.h
//  FBAuto
//
//  Created by lichaowei on 15/1/9.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "FBBaseViewController.h"
/**
 *  个人主页
 */


typedef enum {
 
    User_Gren = 0, //个人
    User_ShangJia //商家
    
}USER_TYPE;///用户类型

typedef void(^CancelPointBlock)(id aModel,NSString *user_Id,BOOL success);

@interface UserHomeController : FBBaseViewController
{
    CancelPointBlock _cancelBlock;
}

@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *userId;
@property(nonatomic,assign)id friendModel;

@property(nonatomic,assign)BOOL cancel_hotPoint;//是否取消红点

- (void)setBlock:(CancelPointBlock)aBlock;

@end

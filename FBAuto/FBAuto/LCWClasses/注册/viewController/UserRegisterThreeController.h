//
//  UserRegisterThreeController.h
//  FBAuto
//
//  Created by lichaowei on 15/1/7.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  注册第三步（个人的第二步，商家第三步）
 */
@interface UserRegisterThreeController : UIViewController

@property(nonatomic,assign)BOOL isGeren;//是否是个人
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *phone;
@property(nonatomic,retain)NSString *password;

//商家信息
@property(nonatomic,retain)NSString *areaInfo;//地区信息

@property(nonatomic,assign)NSInteger province;//省
@property(nonatomic,assign)NSInteger city;//区
@property(nonatomic,retain)NSString *companyInfo;//公司
@property(nonatomic,retain)NSString *address;//详情地址

@end

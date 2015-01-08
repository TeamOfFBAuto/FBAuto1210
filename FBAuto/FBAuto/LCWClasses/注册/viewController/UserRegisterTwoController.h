//
//  UserRegisterTwoController.h
//  FBAuto
//
//  Created by lichaowei on 15/1/7.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  注册第二步(商家注册会来到此页面)
 */
@interface UserRegisterTwoController : UIViewController

@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *phone;
@property(nonatomic,retain)NSString *password;


@property(nonatomic,strong)UIView *backPickView;//地区选择pickerView后面的背景view


//个人
@property(nonatomic,strong)NSString *province;//省
@property(nonatomic,strong)NSString *city;//城市

//上传参数 int类型

@property(nonatomic,assign)NSInteger provinceIn;
@property(nonatomic,assign)NSInteger cityIn;


@end

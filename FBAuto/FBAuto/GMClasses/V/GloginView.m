//
//  GloginView.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GloginView.h"

#import "GloginViewController.h"

////4寸屏幕
//#define Frame_row3Down CGRectMake(24, 312, 275, 210)
//#define Frame_row3Up CGRectMake(24, 312-180, 275, 210)
//
////3.5屏幕
//#define Frame_row3Down4s CGRectMake(24, 200, 275, 210)
//#define Frame_row3Up4s CGRectMake(24, 200-180, 275, 210)


@implementation GloginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //        //弹出键盘通知
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        
        
        if (iPhone5) {
            _Frame_row3Down = CGRectMake(24, 312, DEVICE_WIDTH - 45, 210);
            _Frame_row3Up = CGRectMake(24, 312-180, DEVICE_WIDTH - 45, 210);
            
            _Frame_logoDown = CGRectMake(53, 118, 220, 60);
            _Frame_logoUp = CGRectMake(60, 50, 320-60-60, 60);
            
        }else{
            _Frame_row3Down = CGRectMake(24, 312-44, DEVICE_WIDTH - 45, 210);
            _Frame_row3Up = CGRectMake(24, 312-44-190, DEVICE_WIDTH - 45, 210);
            
            
            _Frame_logoDown = CGRectMake(53, 118, 220, 60);
            _Frame_logoUp = CGRectMake(105, 40, 110, 30);
        }
        
        
        
        //点击回收键盘
        UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [backControl addTarget:self action:@selector(Gshou) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backControl];
        
        //背景图
//        UIImageView *backGroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"denglu_bg640_1096.png"]];
//        backGroundImageView.frame = CGRectMake(0, 0, 320, 568);
//        [self addSubview:backGroundImageView];
    
        self.backgroundColor = COLOR_NORMAL;
        
        //logo图
        UIImageView *logoImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dl_logo382_148"] highlightedImage:nil];
//        logoImv.frame = CGRectMake(53, 118, 220, 60);
        
        logoImv.frame = CGRectMake(0, 118, DEVICE_WIDTH, 70);
        logoImv.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:logoImv];
        logoImv.center = CGPointMake(DEVICE_WIDTH/2.f, logoImv.center.y);
        self.logoImv = logoImv;
        
        
        
        //账号 密码 登录 底层view
        self.Row3backView = [[UIView alloc]initWithFrame:_Frame_row3Down];
        
//        _Row3backView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.Row3backView];
        //self.Row3backView.backgroundColor = [UIColor purpleColor];
        
        
        //账号和密码输入框
        //输入框
        _zhanghaoBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 19, 45)];
        [_zhanghaoBackView setImage:[UIImage imageNamed:@"yonghu38_38"]];
        _zhanghaoBackView.contentMode = UIViewContentModeCenter;
        
        UIView *user_line = [[UIView alloc]initWithFrame:CGRectMake(_zhanghaoBackView.left - 2, _zhanghaoBackView.bottom - 5, DEVICE_WIDTH - 40 - 4, 0.5)];
        user_line.backgroundColor = RGBCOLOR(245, 210, 209);
        [_Row3backView addSubview:user_line];
        
        
        _passWordBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 19, 45)];
        [_passWordBackView setImage:[UIImage imageNamed:@"mima38_38"]];
        _passWordBackView.contentMode = UIViewContentModeCenter;
        
        UIView *pass_line = [[UIView alloc]initWithFrame:CGRectMake(_zhanghaoBackView.left - 2, _passWordBackView.bottom - 5, DEVICE_WIDTH - 40 - 4, 0.5)];
        pass_line.backgroundColor = RGBCOLOR(245, 210, 209);
        [_Row3backView addSubview:pass_line];
        
        UIColor *a_color = RGBCOLOR(164, 164, 164);
        
        //输入textField
        //用户名
        self.userTf = [[UITextField alloc]initWithFrame:CGRectMake(15 + 20, 0,DEVICE_WIDTH - 45, 45)];
        self.userTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
//        _userTf.backgroundColor = [UIColor orangeColor];

        self.userTf.keyboardType = UIKeyboardTypeNumberPad;
        self.userTf.textColor = RGBCOLOR(164, 164, 164);

        self.userTf.textColor = a_color;

        self.userTf.delegate = self;
        self.userTf.tag = 50;
//        self.userTf.placeholder = @"手机号";
        
        
        
        NSAttributedString *user_placeholder = [LCWTools attributedString:@"手机号" keyword:@"手机号" color:a_color];
        self.userTf.attributedPlaceholder = user_placeholder;
        
        //密码
        self.passWordTf = [[UITextField alloc]initWithFrame:CGRectMake(15 + 20, 60, DEVICE_WIDTH - 45, 45)];
        self.passWordTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.passWordTf.secureTextEntry = YES;
        self.passWordTf.textColor = a_color;
        self.passWordTf.delegate = self;
        self.passWordTf.tag = 51;
//        self.passWordTf.placeholder = @"密码";
        
        
        NSAttributedString *pass_placeholder = [LCWTools attributedString:@"密码" keyword:@"密码" color:a_color];
        self.passWordTf.attributedPlaceholder = pass_placeholder;
        
        [self.Row3backView addSubview:_zhanghaoBackView];
        [self.Row3backView addSubview:_passWordBackView];
        [self.Row3backView addSubview:self.userTf];
        [self.Row3backView addSubview:self.passWordTf];
        
        
//        _placeHolder1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 275, 45)];
////        _placeHolder1.text = @"账号";
//        _placeHolder1.text = @"手机号";
//        _placeHolder1.textColor = RGBCOLOR(164, 164, 164);
//        
//        _placeHolder2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, 275, 45)];
//        _placeHolder2.text = @"密码";
//        _placeHolder2.textColor = RGBCOLOR(164, 164, 164);
//        
//        
//        
//        [self.Row3backView addSubview:_placeHolder1];
//        [self.Row3backView addSubview:_placeHolder2];
        
        
        
        //登录
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"denglu_botton550_100.png"] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:COLOR_NORMAL forState:UIControlStateNormal];
        
        loginBtn.frame = CGRectMake(0, 130, DEVICE_WIDTH - 45, 50);
        [loginBtn addTarget:self action:@selector(denglu) forControlEvents:UIControlEventTouchUpInside];
        [self.Row3backView addSubview:loginBtn];
        
        
        
        //忘记密码
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"忘记密码" forState:UIControlStateNormal];
        btn1.frame = CGRectMake(0, CGRectGetMaxY(loginBtn.frame)+5, 50, 25);
        btn1.titleLabel.font = [UIFont systemFontOfSize:12];
        btn1.titleLabel.textColor = RGBCOLOR(123, 123, 123);
        [btn1 addTarget:self action:@selector(findmima) forControlEvents:UIControlEventTouchUpInside];
        [self.Row3backView addSubview:btn1];
        
        //免费注册
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"免费注册" forState:UIControlStateNormal];
        btn2.frame = CGRectMake(DEVICE_WIDTH - 95, btn1.frame.origin.y, 50, 25);
        btn2.titleLabel.font = [UIFont systemFontOfSize:12];
        btn2.titleLabel.textColor = RGBCOLOR(123, 123, 123);
        [self.Row3backView addSubview:btn2];
        
        [btn2 addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
    }
    return self;
}


//block的set方法

-(void)setZhuceBlock:(zhuceBlock)zhuceBlock{
    _zhuceBlock = zhuceBlock;
}
-(void)setFindPassBlock:(findPasswBlock)findPassBlock{
    _findPassBlock = findPassBlock;
}
-(void)setDengluBlock:(dengluBlock)dengluBlock{
    _dengluBlock = dengluBlock;
}


//收键盘
-(void)Gshou{
    [self.userTf resignFirstResponder];
    [self.passWordTf resignFirstResponder];
    
    
    if (DEVICE_WIDTH == 320) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.Row3backView.frame = _Frame_row3Down;
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.logoImv.frame = _Frame_logoDown;
        } completion:^(BOOL finished) {
            
        }];

    }
    
    
}




#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"------------------%@",NSStringFromRange(range));
    
    if (textField.tag == 50) {
        
        NSString *uname = [NSString stringWithFormat:@"%@%@",textField.text,string];
        
        NSLog(@"%lu",(unsigned long)uname.length);
        
        if (range.length!=1 || range.location!=0) {
            
            self.userName = uname;
            _placeHolder1.hidden = YES;
        }else{
            
            _placeHolder1.hidden = NO;
            
        }
    }else if(textField.tag == 51){
        NSString *passw = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (range.length!=1 || range.location!=0) {
            self.userPassWord = passw;
            _placeHolder2.hidden = YES;
        }else{
            _placeHolder2.hidden = NO;
        }
    }
    
    return YES;
}





//键盘出现
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (DEVICE_WIDTH == 320) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.Row3backView.frame = _Frame_row3Up;
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.logoImv.frame = _Frame_logoUp;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return YES;
}




//注册
-(void)zhuce{
    if (self.zhuceBlock) {
        self.zhuceBlock();
    }
}

//找回密码
-(void)findmima{
    if (self.findPassBlock) {
        self.findPassBlock();
    }
}


//登录
-(void)denglu{
    
    [self Gshou];//收键盘
    
    if (self.dengluBlock) {
        self.dengluBlock(self.userTf.text,self.passWordTf.text);
    }
}


@end

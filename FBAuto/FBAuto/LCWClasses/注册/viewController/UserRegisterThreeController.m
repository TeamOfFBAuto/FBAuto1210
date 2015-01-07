//
//  UserRegisterThreeController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/7.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "UserRegisterThreeController.h"

@interface UserRegisterThreeController ()

@end

@implementation UserRegisterThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    leftImage.contentMode = UIViewContentModeLeft;
    leftImage.image = [UIImage imageNamed:@"logo120_48"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftImage];
    
    UILabel *_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"验证手机";
    self.navigationItem.titleView = _titleLabel;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    //底部 tools
    
    UIView *tools_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 50 - 64, DEVICE_WIDTH, 50)];
    tools_bottom.backgroundColor = [UIColor colorWithHexString:@"222222"];
    [self.view addSubview:tools_bottom];
    
    NSArray *tools_arr = @[@"上一步",@"下一步"];
    
    CGFloat aWidth = (DEVICE_WIDTH - 15) / 2;
    
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:tools_arr[i] forState:UIControlStateNormal];
        [tools_bottom addSubview:btn];
        btn.frame = CGRectMake(5 + (aWidth + 5) * i, 7.5, aWidth, 35);
        [btn setTitleColor:[UIColor colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithHexString:@"434343"];
        btn.tag = 1100 + i;
        btn.layer.cornerRadius = 3.f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 事件处理

- (void)tapToHiddenKeyboard:(UIGestureRecognizer *)ges
{
    for (int i = 0; i < 3; i ++) {
        
        UITextField *tf = (UITextField *)[self.view viewWithTag:100 + i];
        [tf resignFirstResponder];
    }
}

- (void)clickToAction:(UIButton *)sender
{
    if (sender.tag == 1100) {
        NSLog(@"返回");
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        NSLog(@"下一步");
        
        //        UITextField *tf_name = (UITextField *)[self.view viewWithTag:100];
        //        UITextField *tf_phone = (UITextField *)[self.view viewWithTag:101];
        //        UITextField *tf_pass = (UITextField *)[self.view viewWithTag:102];
        //        if (tf_name.text.length == 0) {
        //
        //            [LCWTools showMBProgressWithText:@"用户名不能为空" addToView:self.view];
        //
        //            return;
        //        }else if (![LCWTools isValidateMobile:tf_phone.text]){
        //
        //            [LCWTools showMBProgressWithText:@"请填写有效手机号" addToView:self.view];
        //
        //            return;
        //        }else if (tf_pass.text.length < 6){
        //
        //            [LCWTools showMBProgressWithText:@"密码不能少于6位" addToView:self.view];
        //            return;
        //        }
        
        
        UIButton *gren_btn = (UIButton *)[self.view viewWithTag:1000];
        UIButton *shang_btn = (UIButton *)[self.view viewWithTag:1001];
        
        if (gren_btn.selected) {
            
            NSLog(@"个人注册");
            
            
            
        }else if (shang_btn.selected){
            NSLog(@"商家注册");
            
            
        }else
        {
            [LCWTools showDXAlertViewWithText:@"请选择注册个人或商家"];
        }
        
    }
}

@end

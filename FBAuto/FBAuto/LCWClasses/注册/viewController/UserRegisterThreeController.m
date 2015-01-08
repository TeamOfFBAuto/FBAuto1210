//
//  UserRegisterThreeController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/7.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "UserRegisterThreeController.h"
static int seconds = 60;//计时60s

@interface UserRegisterThreeController ()
{
    //验证码倒计时 label
    UILabel *num_label;
    NSTimer *timer;
    UIButton *sender_yan;//验证码发送按钮
}

@end

@implementation UserRegisterThreeController

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
}

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
    [self creatBottomTools];
    
    //验证码已发送
    
    UILabel *yanzheng_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 22, 120, 13)];
    yanzheng_label.textAlignment = NSTextAlignmentLeft;
    yanzheng_label.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    yanzheng_label.text = @"验证码已经发送到";
    yanzheng_label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:yanzheng_label];
    
    //手机号
    UILabel *phone_label = [[UILabel alloc]initWithFrame:CGRectMake(yanzheng_label.right, 22, 150, 13)];
    phone_label.textAlignment = NSTextAlignmentLeft;
    phone_label.textColor = [UIColor colorWithHexString:@"349adc"];
    phone_label.text = [NSString stringWithFormat:@"(+86)%@",self.phone];
    [self.view addSubview:phone_label];
    
    //验证码输入框
    
    UIView *yanzheng_view = [self viewFrameY:phone_label.bottom + 15 iconName:@"yanzheng42_28" lineColor_Bottom:[UIColor colorWithHexString:@"9b9b9b"] keyboardType:UIKeyboardTypeNumberPad tag:100 isClick:NO placeHolder:@"输入接收到验证码"];
    [self.view addSubview:yanzheng_view];
    
    //发送验证码
    
    sender_yan = [UIButton buttonWithType:UIButtonTypeCustom];
    sender_yan.frame = CGRectMake(10, yanzheng_view.bottom + 20, DEVICE_WIDTH - 20, 50);
    [sender_yan setTitle:@"获取验证码" forState:UIControlStateNormal];
    sender_yan.layer.cornerRadius = 3.f;
    sender_yan.clipsToBounds = YES;
    sender_yan.backgroundColor = [UIColor colorWithHexString:@"272727"];
    [sender_yan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender_yan addTarget:self action:@selector(getSecurityCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender_yan];
    
    //验证码倒计时 label
    num_label = [[UILabel alloc]initWithFrame:sender_yan.frame];
    num_label.textAlignment = NSTextAlignmentCenter;
    num_label.textColor = [UIColor colorWithHexString:@"cccccc"];
    num_label.text = @"重发验证码(60s)";
    num_label.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    [self.view addSubview:num_label];
    
    
    [self getSecurityCode:nil];//开启计时
}

- (UIView *)viewFrameY:(CGFloat)frameY
              iconName:(NSString *)iconName
      lineColor_Bottom:(UIColor *)lineColor_bottom
          keyboardType:(UIKeyboardType)keyboardType
                   tag:(int)tag
               isClick:(BOOL)isClick
           placeHolder:(NSString *)placeHolder
{
    UIView *name_bg = [[UIView alloc]initWithFrame:CGRectMake(10, frameY, DEVICE_WIDTH - 20, 44)];
    name_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:name_bg];
    
    UIImageView *name_icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 44)];
    name_icon.contentMode = UIViewContentModeCenter;
    name_icon.image = [UIImage imageNamed:iconName];
    [name_bg addSubview:name_icon];
    
    UIColor *line_color = [UIColor colorWithHexString:@"9b9b9b"];
    UIColor *text_color = [UIColor colorWithHexString:@"393939"];
    
    UIView *line_v_name = [[UIView alloc]initWithFrame:CGRectMake(name_icon.right, 10, 2, 24)];
    line_v_name.backgroundColor = line_color;
    [name_bg addSubview:line_v_name];
    
    UIView *line_h_name = [[UIView alloc]initWithFrame:CGRectMake(0, name_bg.height - 2, name_bg.width, 2)];
    line_h_name.backgroundColor = lineColor_bottom;
    [name_bg addSubview:line_h_name];
    
    UITextField *name_tf = [[UITextField alloc]initWithFrame:CGRectMake(line_v_name.right + 10, 0, 200, name_bg.height)];
    name_tf.textColor = text_color;
    name_tf.keyboardType = keyboardType;
    [name_bg addSubview:name_tf];
    name_tf.tag = tag;
    name_tf.font = [UIFont systemFontOfSize:14];
    name_tf.placeholder = placeHolder;
    
    return name_bg;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 底部tools

- (void)creatBottomTools
{
    //底部 tools
    
    UIView *tools_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 50 - 64, DEVICE_WIDTH, 50)];
    tools_bottom.backgroundColor = [UIColor colorWithHexString:@"222222"];
    [self.view addSubview:tools_bottom];
    
    NSArray *tools_arr = @[@"上一步",@"完成"];
    
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


#pragma mark 事件处理

- (UITextField *)textFieldForTag:(int)tag
{
    return (UITextField *)[self.view viewWithTag:tag];
}

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
        NSLog(@"提交注册");
        
        UITextField *tf_name = (UITextField *)[self.view viewWithTag:100];

        if (tf_name.text.length < 6) {
            
            [LCWTools showMBProgressWithText:@"请填写有效验证码" addToView:self.view];
            
            return;
        }
        
        [self registerNewUser];
        
        
    }
}

#pragma mark - 验证码

- (void)startTimer
{
    [sender_yan setTitle:@"" forState:UIControlStateNormal];
    
    num_label.hidden = NO;
    
    seconds = 60;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(calculateTime) userInfo:Nil repeats:YES];
    sender_yan.userInteractionEnabled = NO;
}

//计算时间
- (void)calculateTime
{
    NSString *title = [NSString stringWithFormat:@"重发验证码(%d)",seconds];
    
    num_label.text = title;
    
    if (seconds != 0) {
        seconds --;
    }else
    {
        [self renewTimer];
    }
    
}
//计时器归零
- (void)renewTimer
{
    [timer invalidate];//计时器停止
    sender_yan.userInteractionEnabled = YES;
    [sender_yan setTitle:@"获取验证码" forState:UIControlStateNormal];
    num_label.hidden = YES;
    seconds = 60;
}

#pragma mark - 获取验证码

- (void)getSecurityCode:(UIButton *)sender
{
    
    [self startTimer];//开始计时
    
    NSString *url = [NSString stringWithFormat:FBAUTO_GET_VERIFICATION_CODE,self.phone,1];
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
       
        NSLog(@"验证码获取失败");
        
        [LCWTools showMBProgressWithText:failDic[ERROR_INFO] addToView:self.view];
        
        [self renewTimer];
        
    }];
}

/**
 *  注册新用户
 */
- (void)registerNewUser
{
    int userType = self.isGeren ? 1 : 2;
    
    NSString *code = [self textFieldForTag:100].text;
    
    NSString *url = [NSString stringWithFormat:FBAUTO_REGISTERED,self.phone,self.password,self.userName,self.province,self.city,userType,code,[GMAPI getDeviceToken],self.companyInfo,self.address];
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [LCWTools showMBProgressWithText:@"注册成功" addToView:self.view];
        
        [self performSelector:@selector(clickToRoot:) withObject:nil afterDelay:0.2];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        

        [LCWTools showMBProgressWithText:failDic[ERROR_INFO] addToView:self.view];
    }];
}

//调到登录页

- (void)clickToRoot:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

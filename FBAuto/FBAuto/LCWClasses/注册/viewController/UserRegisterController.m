//
//  UserRegisterController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/7.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "UserRegisterController.h"
#import "UserRegisterTwoController.h"
#import "UserRegisterThreeController.h"
#import "XieyiViewController.h"
#import "FBHelper.h"

@interface UserRegisterController ()<UITextFieldDelegate>

@end

@implementation UserRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:FBAUTO_IMAGE_NAVIGATION forBarMetrics: UIBarMetricsDefault];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    leftImage.contentMode = UIViewContentModeLeft;
    leftImage.image = [UIImage imageNamed:@"logo120_48"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftImage];
    
    UILabel *_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"注册";
    self.navigationItem.titleView = _titleLabel;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    
    //用户名、手机号、密码
    NSArray *nameArr = @[@"zhuce_yonghu38_38",@"zhuce_phone28_40",@"zhuce_mima38_40",@"zhuce_mima38_40"];
    NSArray *placeHolders = @[@"用户名",@"手机号",@"密码",@"重复密码"];
    for (int i = 0; i < 4; i ++) {
        UIColor *color = [UIColor colorWithHexString:@"9b9b9b"];
        UIKeyboardType type = UIKeyboardTypeDefault;
        BOOL isPass = NO;
        if (i == 0) {
            color = COLOR_NORMAL;
        }
        
        if (i == 1) {
            type  = UIKeyboardTypeNumberPad;
        }
        if (i == 2 || i == 3) {
            isPass = YES;
        }
        
        UIView *aView = [self viewFrameY:20 + 44 * i iconName:nameArr[i] lineColor_Bottom:color keyboardType:type tag:100 + i isPass:isPass placeHolder:placeHolders[i]];
        [self.view addSubview:aView];
    }
    
    [self textFieldForTag:100].returnKeyType = UIReturnKeyNext;
    [self textFieldForTag:101].returnKeyType = UIReturnKeyNext;
    [self textFieldForTag:102].returnKeyType = UIReturnKeyNext;
    [self textFieldForTag:103].returnKeyType = UIReturnKeyDone;

    
    UILabel *hint = [[UILabel alloc]initWithFrame:CGRectMake(10, 20 + 44 * 4 + 18, DEVICE_WIDTH - 20, 15)];
    hint.font = [UIFont systemFontOfSize:14];
    hint.textAlignment = NSTextAlignmentLeft;
    hint.textColor = [UIColor colorWithHexString:@"b0b0b0"];
    hint.text = @"为保护您的账户安全,请勿设置过于简单的密码";
    [self.view addSubview:hint];
    
    UIButton *xieyi_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyi_btn.frame = CGRectMake(10, hint.bottom + 10, 50, 15);
    [xieyi_btn setTitle:@"协议" forState:UIControlStateNormal];
    xieyi_btn.backgroundColor = [UIColor redColor];
    [xieyi_btn addTarget:self action:@selector(clickToXieyi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyi_btn];
    
    UILabel *hint1 = [[UILabel alloc]initWithFrame:CGRectMake(xieyi_btn.right + 5, hint.bottom + 10, 0, 15)];
    hint1.font = [UIFont systemFontOfSize:14];
    hint1.textAlignment = NSTextAlignmentLeft;
    hint1.textColor = [UIColor colorWithHexString:@"b0b0b0"];
    hint1.text = @"我已阅读并同意";
    [self.view addSubview:hint1];
    hint1.width = [LCWTools widthForText:@"我已阅读并同意" font:14];
    
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"今日车市用户协议"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    
    UIButton *xieyi_content = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    xieyi_content.frame = CGRectMake(hint1.right, hint1.top, 150, 15);
    [xieyi_content addTarget:self action:@selector(clickToXieyi:) forControlEvents:UIControlEventTouchUpInside];
    [xieyi_content setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    xieyi_content.titleLabel.textColor = [UIColor blueColor];
    [xieyi_content.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [xieyi_content setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [xieyi_content setAttributedTitle:content forState:UIControlStateNormal];
    [self.view addSubview:xieyi_content];
    
    
    
    
    
    NSArray *titles = @[@"个人",@"商家"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(10 + (DEVICE_WIDTH - 20) / 2.f * i, hint.bottom + 50, DEVICE_WIDTH/2.f - 10, 55);
        [btn setTitleColor:[UIColor colorWithHexString:@"909090"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tag = 1000 +i;
        [btn addTarget:self action:@selector(clickToSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        
        UIButton *quan_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        quan_btn.frame = CGRectMake(btn.width / 2.f, 0, btn.width / 2.f, btn.height);
        quan_btn.backgroundColor = [UIColor clearColor];
        quan_btn.userInteractionEnabled = NO;
        [quan_btn setImage:[UIImage imageNamed:@"diand_up20_20"] forState:UIControlStateNormal];
        [quan_btn setImage:[UIImage imageNamed:@"diand_down20_20"] forState:UIControlStateSelected];
        quan_btn.tag = 1005 + i;
        [btn addSubview:quan_btn];
        
    }
    
//    NSArray *arr = @[@"普通个人请选择买家个人注册,",@"商家与销售请选择商家注册。"];
//    for (int i = 0; i < 2;  i ++) {
//        UILabel *hint = [[UILabel alloc]initWithFrame:CGRectMake(10, 594/2.f + 10 + (15 + 15)*i, DEVICE_WIDTH - 20, 15)];
//        hint.font = [UIFont systemFontOfSize:14];
//        hint.textAlignment = NSTextAlignmentLeft;
//        hint.textColor = [UIColor colorWithHexString:@"b0b0b0"];
//        hint.text = arr[i];
//        [self.view addSubview:hint];
//    }
    
    //底部 tools
    
    UIView *tools_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 50 - 64, DEVICE_WIDTH, 50)];
    tools_bottom.backgroundColor = [UIColor colorWithHexString:@"222222"];
    [self.view addSubview:tools_bottom];
    
    NSArray *tools_arr = @[@"返回",@"下一步"];
    
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 100) {
      
        [[self textFieldForTag:101]becomeFirstResponder];
        
    }else if (textField.tag == 101){
        
        [[self textFieldForTag:102]becomeFirstResponder];
        
    }else if (textField.tag == 102){
        
//        [textField resignFirstResponder];
        [[self textFieldForTag:103]becomeFirstResponder];
        
    }else if (textField.tag == 103){
        
        [textField resignFirstResponder];
    }

    
    return YES;
}

#pragma mark 事件处理

- (void)clickToXieyi:(UIButton *)sender
{
    //协议页面
    XieyiViewController *xieyi = [[XieyiViewController alloc]init];
    [self.navigationController pushViewController:xieyi animated:YES];
}

- (void)tapToHiddenKeyboard:(UIGestureRecognizer *)ges
{
    for (int i = 0; i < 4; i ++) {
        
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
        
        UITextField *tf_name = (UITextField *)[self.view viewWithTag:100];
        UITextField *tf_phone = (UITextField *)[self.view viewWithTag:101];
        UITextField *tf_pass = (UITextField *)[self.view viewWithTag:102];
        UITextField *tf_pass_2 = (UITextField *)[self.view viewWithTag:103];
        if (tf_name.text.length == 0) {
            
            [LCWTools showMBProgressWithText:@"用户名不能为空" addToView:self.view];
            
            return;
        }else if (![LCWTools isValidateMobile:tf_phone.text]){
            
            [LCWTools showMBProgressWithText:@"请填写有效手机号" addToView:self.view];
            
            return;
        }else if (tf_pass.text.length < 6){
            
            [LCWTools showMBProgressWithText:@"密码不能少于6位" addToView:self.view];
            return;
        }else if (![tf_pass.text isEqualToString:tf_pass_2.text]){
            
            [LCWTools showMBProgressWithText:@"两次密码不一致" addToView:self.view];
            return;
        }

        
        UIButton *gren_btn = (UIButton *)[self.view viewWithTag:1000];
        UIButton *shang_btn = (UIButton *)[self.view viewWithTag:1001];
        
        if (gren_btn.selected) {
            
            NSLog(@"个人注册");
            
            UserRegisterThreeController *regis = [[UserRegisterThreeController alloc]init];
            regis.isGeren = YES;
            regis.userName = [self textFieldForTag:100].text;
            regis.phone = [self textFieldForTag:101].text;
            regis.password = [self textFieldForTag:102].text;
            
            [self.navigationController pushViewController:regis animated:YES];
            
        }else if (shang_btn.selected){
            NSLog(@"商家注册");
            
            UserRegisterTwoController *regis = [[UserRegisterTwoController alloc]init];
            regis.userName = [self textFieldForTag:100].text;
            regis.phone = [self textFieldForTag:101].text;
            regis.password = [self textFieldForTag:102].text;
            [self.navigationController pushViewController:regis animated:YES];
            
        }else
        {
            [LCWTools showDXAlertViewWithText:@"请选择注册个人或商家"];
        }
        
    }
}

- (UITextField *)textFieldForTag:(int)tag
{
    return (UITextField *)[self.view viewWithTag:tag];
}


- (void)clickToSelected:(UIButton *)sender
{
    UIButton *gren_btn = (UIButton *)[self.view viewWithTag:1000];
    UIButton *shang_btn = (UIButton *)[self.view viewWithTag:1001];
    
    UIButton *quan_btn1 = (UIButton *)[self.view viewWithTag:1005];
    UIButton *quan_btn2 = (UIButton *)[self.view viewWithTag:1006];
    
    sender.backgroundColor = [UIColor colorWithHexString:@"434343"];
    sender.selected = YES;
    if (sender == gren_btn) {
        
        shang_btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        shang_btn.selected = NO;
        quan_btn1.selected = YES;
        quan_btn2.selected = NO;
        
    }else
    {
        gren_btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        gren_btn.selected = NO;
        
        quan_btn2.selected = YES;
        quan_btn1.selected = NO;
    }
    
}

#pragma mark 创建视图

- (UIView *)viewFrameY:(CGFloat)frameY
              iconName:(NSString *)iconName
             lineColor_Bottom:(UIColor *)lineColor_bottom
        keyboardType:(UIKeyboardType)keyboardType
                   tag:(int)tag
                isPass:(BOOL)isPass
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
    name_tf.secureTextEntry = isPass;
    name_tf.font = [UIFont systemFontOfSize:14];
    name_tf.placeholder = placeHolder;
    name_tf.delegate = self;
    
    return name_bg;
}


@end

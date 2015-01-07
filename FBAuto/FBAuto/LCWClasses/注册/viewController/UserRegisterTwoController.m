//
//  UserRegisterTwoController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/7.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "UserRegisterTwoController.h"

#import "UserRegisterThreeController.h"

@interface UserRegisterTwoController ()<UITextFieldDelegate>

@end

@implementation UserRegisterTwoController

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
    _titleLabel.text = @"注册资料";
    self.navigationItem.titleView = _titleLabel;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    
    //用户名、手机号、密码
    NSArray *nameArr = @[@"diqu38_38",@"gongsi32_38",@"dizhi26_38"];
    NSArray *placeHolders = @[@"请选择地区",@"所属公司全称",@"详细地址"];
    for (int i = 0; i < 3; i ++) {
        UIColor *color = [UIColor colorWithHexString:@"9b9b9b"];
        UIKeyboardType type = UIKeyboardTypeDefault;
        BOOL isPass = NO;
        
        if (i == 0) {
            isPass = YES;
        }
        
        UIView *aView = [self viewFrameY:20 + 44 * i iconName:nameArr[i] lineColor_Bottom:color keyboardType:type tag:100 + i isClick:isPass placeHolder:placeHolders[i]];
        [self.view addSubview:aView];
    }
    
    
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

    if (isClick) {
        
        name_tf.delegate = self;
    }
    
    name_tf.placeholder = placeHolder;
    
    return name_bg;
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
        
        UserRegisterThreeController *regis = [[UserRegisterThreeController alloc]init];
        [self.navigationController pushViewController:regis animated:YES];
        
    }
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        
        NSLog(@"选择地区");
        
        
        return NO;
    }
    return YES;
}

@end

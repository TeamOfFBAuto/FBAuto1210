//
//  UserRegisterTwoController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/7.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "UserRegisterTwoController.h"

#import "UserRegisterThreeController.h"

#import "FBCityData.h"

@interface UserRegisterTwoController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *pickeView;
    BOOL _isChooseArea;
    NSArray *_data;
    NSInteger _flagRow;//pickerView地区标志位
}

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

    //地区选择 ===================
    
    //地区pickview
    pickeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, 216)];
    pickeView.delegate = self;
    pickeView.dataSource = self;
    [self.view addSubview:pickeView];
    _isChooseArea = NO;
    
    //确定按钮
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quedingBtn.frame = CGRectMake(270, 0, 35, 30);
    [quedingBtn addTarget:self action:@selector(areaHidden) forControlEvents:UIControlEventTouchUpInside];
    //上下横线
    UIView *shangxian = [[UIView alloc]initWithFrame:CGRectMake(270, 5, 35, 0.5)];
    shangxian.backgroundColor = [UIColor blackColor];
    UIView *xiaxian = [[UIView alloc]initWithFrame:CGRectMake(270, 25, 35, 0.5)];
    xiaxian.backgroundColor = [UIColor blackColor];
    
    //地区选择
    UIView *backPickView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 216+30)];
    backPickView.backgroundColor = [UIColor whiteColor];
    [backPickView addSubview:pickeView];
    [backPickView addSubview:shangxian];
    [backPickView addSubview:xiaxian];
    [backPickView addSubview:quedingBtn];
    self.backPickView = backPickView;
    [self.view addSubview:self.backPickView];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
    
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
    name_tf.font = [UIFont systemFontOfSize:14];

    if (isClick) {
        
        name_tf.delegate = self;
    }
    
    name_tf.placeholder = placeHolder;
    
    return name_bg;
}

#pragma mark 事件处理


#pragma - mark 控制地区pickerView

- (void)showSelectedAreaInfo
{
    NSLog(@"province:%@ %d\n  city:%@ %d",self.province,self.provinceIn,self.city,self.cityIn);
    
    if (self.province.length > 0) {
        
        [self textFieldForTag:100].text = [NSString stringWithFormat:@"%@%@",self.province,self.city];
    }
}

-(void)areaShow{//地区出现
    NSLog(@"_backPickView");
    __weak typeof (self)bself = self;
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0,DEVICE_HEIGHT - 216 - 64, DEVICE_WIDTH, 216);
    }];
    
    
}

-(void)areaHidden{//地区消失
    NSLog(@"_backPickView");
    __weak typeof (self)bself = self;
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0,DEVICE_HEIGHT, DEVICE_WIDTH, 216);
    }];
    
    [self showSelectedAreaInfo];
}

- (void)tapToHiddenKeyboard:(UIGestureRecognizer *)ges
{
    for (int i = 0; i < 3; i ++) {
        
        UITextField *tf = (UITextField *)[self.view viewWithTag:100 + i];
        [tf resignFirstResponder];
    }
    
    [self areaHidden];
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
        if (tf_name.text.length == 0) {
            
            [LCWTools showMBProgressWithText:@"请选择地区" addToView:self.view];
            
            return;
        }else if (tf_phone.text.length == 0){
            
            [LCWTools showMBProgressWithText:@"请填写公司全称" addToView:self.view];
            
            return;
        }else if (tf_pass.text.length == 0){
            
            [LCWTools showMBProgressWithText:@"请填写详细地址" addToView:self.view];
            return;
        }
        
        
        
        //只有商家来此页面
        
        UserRegisterThreeController *regis = [[UserRegisterThreeController alloc]init];
        regis.isGeren = NO;
        regis.userName = self.userName;
        regis.phone = self.phone;
        regis.password = self.password;
        
        //商家信息
        
        regis.province = self.provinceIn;
        regis.city = self.cityIn;
        
        regis.areaInfo = [self textFieldForTag:100].text;
        regis.companyInfo = [self textFieldForTag:101].text;
        regis.address = [self textFieldForTag:102].text;
        
        [self.navigationController pushViewController:regis animated:YES];
        
    }
}

- (UITextField *)textFieldForTag:(int)tag
{
    return (UITextField *)[self.view viewWithTag:tag];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        
        NSLog(@"选择地区");
        
        [self tapToHiddenKeyboard:nil];
        
        [self areaShow];
        
        return NO;
    }
    return YES;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _data.count;
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        return cities.count;
    }
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        
        if ([_data[row][@"State"] isEqualToString:@"省份"]) {
            self.province = @"";
        }else{
            self.province = _data[row][@"State"];
            
        }
        
        
        NSString *provinceStr = [NSString stringWithFormat:@"%@",_data[row][@"State"]];
        
        //字符转id
        
        self.provinceIn = [FBCityData cityIdForName:provinceStr];//上传
        
        return provinceStr;
        
        
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        
        if ([cities[row][@"city"] isEqualToString:@"市区县"]) {
            self.city = @"";
        }else{
            self.city = cities[row][@"city"];
            
        }
        
        NSString *cityStr = [NSString stringWithFormat:@"%@",cities[row][@"city"]];
        
        //字符转id
        
        self.cityIn = [FBCityData cityIdForName:cityStr];//上传
        
        return cityStr;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (component == 0) {
        _flagRow = row;
        _isChooseArea = YES;
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }else if (component == 1){
        _isChooseArea = YES;
    }
    
    [pickerView reloadAllComponents];
}


@end

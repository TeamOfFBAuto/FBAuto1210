//
//  LiuyanViewController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "LiuyanViewController.h"

@interface LiuyanViewController ()<UITextViewDelegate>
{
    UITextView *_textView;
}

@end

@implementation LiuyanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"留言";
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 20, DEVICE_WIDTH - 20, 150)];
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
    [self.view addSubview:_textView];
    _textView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    UIButton *btn_liuyan = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_liuyan setTitle:@"留言" forState:UIControlStateNormal];
    btn_liuyan.frame = CGRectMake(25, 20 + _textView.bottom, DEVICE_WIDTH - 50, 50);
    btn_liuyan.layer.cornerRadius = 3.f;
    btn_liuyan.backgroundColor = [UIColor colorWithHexString:@"222222"];
    [self.view addSubview:btn_liuyan];
    [btn_liuyan addTarget:self action:@selector(clickToLiuyan:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

- (void)tapToHiddenKeyboard:(UITapGestureRecognizer *)tap
{
    [_textView resignFirstResponder];
}

- (void)clickToLiuyan:(UIButton *)sender
{
    [self tapToHiddenKeyboard:nil];
    
    if ([LCWTools isEmpty:_textView.text]) {
        
        [LCWTools showMBProgressWithText:@"内容不能为空" addToView:self.view];
        return;
    }
    
    [self networkToliuyan];
}

#pragma mark - 网络请求

- (void)networkToliuyan
{
    NSString *url = [NSString stringWithFormat:FBAUTO_LIUYAN_ADD,[GMAPI getAuthkey],_textView.text,self.art_uid,2];
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PUBLISH_LIYYAN_SUCCESS object:nil];
        
        [LCWTools showMBProgressWithText:@"发布留言成功" addToView:self.view];
        
        [self performSelector:@selector(clickToBack:) withObject:nil afterDelay:0.5];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LCWTools showMBProgressWithText:failDic[ERROR_INFO] addToView:self.view];
    }];
}

#pragma mark - UITextViewDelegate


@end

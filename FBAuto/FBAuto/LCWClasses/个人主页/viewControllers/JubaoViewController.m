//
//  JubaoViewController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/20.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "JubaoViewController.h"
#import "LTextView.h"

@interface JubaoViewController ()
{
    UIScrollView *bigScroll;
    LTextView *_lTextView;
    MBProgressHUD *loading;
}

@end

@implementation JubaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"车源举报";
    
    bigScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64)];
    [self.view addSubview:bigScroll];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 14)];
    title.text = @"举报类型";
    title.textColor = [UIColor colorWithHexString:@"383838"];
    title.font = [UIFont systemFontOfSize:14];
    [bigScroll addSubview:title];
    
    CGFloat text_top = 0.0;
    NSArray *titles = @[@"此车已售",@"价格过低",@"无人接听",@"预付定金",@"车型有误",@"其他类型"];
    CGFloat aWidth = (DEVICE_WIDTH - 10 * 2 - 15 * 2)/3;
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + (aWidth + 15) * (i % 3), title.bottom + 15 + (40 + 15)* (i / 3), aWidth, 40);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [UIColor colorWithHexString:@"e52f17"].CGColor;
        [btn setTitleColor:[UIColor colorWithHexString:@"e52f17"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
        [bigScroll addSubview:btn];
        text_top = btn.bottom;
    }
    
    _lTextView = [[LTextView alloc]initWithFrame:CGRectMake(10, text_top + 25, DEVICE_WIDTH - 20, DEVICE_HEIGHT - text_top - 25 - 20 - 64 - 40 - 50 - 40) placeHolder:@"详细描述:" fontSize:15];
    _lTextView.layer.borderWidth = 0.5f;
    _lTextView.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
    [bigScroll addSubview:_lTextView];
    
    bigScroll.contentSize = CGSizeMake(DEVICE_WIDTH, bigScroll.height + _lTextView.height);
    
    __weak typeof(bigScroll)weakScroll = bigScroll;

    [_lTextView setBlock:^(LTextView *textView, ActionStyle actionStyle) {
       
        if (actionStyle == textViewDidBeginEditing) {
            
            weakScroll.contentOffset = CGPointMake(0, textView.top - 10);
            
        }else if (actionStyle == textViewDidEndEditing){
            
            weakScroll.contentOffset = CGPointMake(0, 0);
        }
        
    }];
    
    UIButton *send_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    send_btn.frame = CGRectMake(45/2.f, _lTextView.bottom + 20, DEVICE_WIDTH - 45, 50);
    send_btn.backgroundColor = [UIColor colorWithHexString:@"222222"];
    send_btn.layer.cornerRadius = 3.f;
    [send_btn setTitle:@"发送" forState:UIControlStateNormal];
    send_btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [send_btn addTarget:self action:@selector(clickToSend:) forControlEvents:UIControlEventTouchUpInside];
    [bigScroll addSubview:send_btn];
    
    loading = [LCWTools MBProgressWithText:@"" addToView:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.navigationController.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

- (void)sendJubaoTypeString:(NSString *)type
                   describe:(NSString *)describe
{
    [loading show:YES];
    NSString *url = [NSString stringWithFormat:FBAUTO_ADD_JUBAO,[GMAPI getAuthkey],self.cid,type,describe,[LCWTools cacheForKey:LOGIN_PHONE]];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [loading hide:YES];
        
        [LCWTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];
        
        [self performSelector:@selector(clickToBack:) withObject:nil afterDelay:1.f];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [loading hide:YES];
        [LCWTools showDXAlertViewWithText:failDic[ERROR_INFO]];
        
    }];
}

#pragma mark - 事件处理

- (void)clickToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)buttonWithTag:(int)tag
{
    return (UIButton *)[self.view viewWithTag:tag];
}

- (NSString *)typeForJubao
{
    NSMutableString *type = [NSMutableString string];
    
    for (int i = 0; i < 6; i ++) {
        
        if ([self buttonWithTag:100 + i].selected) {
            
            if (type.length == 0) {
                
                [type appendFormat:@"%@",[self buttonWithTag:100 + i].titleLabel.text];
            }else
            {
                [type appendFormat:@",%@",[self buttonWithTag:100 + i].titleLabel.text];
            }
        }
    }
    
    NSLog(@"-->%@",type);
    
    return type;
}

- (void)hiddenKeyboard
{
    [_lTextView resignFirstResponder];
}

- (void)clickToSend:(UIButton *)sender
{
    [self hiddenKeyboard];
    
    NSString *type = [self typeForJubao];
    if (type.length == 0) {

        [LCWTools showDXAlertViewWithText:@"请选择举报类型"];
        return;
    }
    
    [self sendJubaoTypeString:type describe:_lTextView.text];
}

- (void)clickToAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [sender setBackgroundColor:[UIColor colorWithHexString:@"e72f17"]];
    }else
    {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
}


@end

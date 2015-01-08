//
//  LSecurityCode.m
//  FBAuto
//
//  Created by lichaowei on 15/1/8.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "LSecurityCode.h"
static int seconds = 60;//计时60s

@implementation LSecurityCode

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static LSecurityCode *code;
    
    dispatch_once(&once_t, ^{
        code = [[LSecurityCode alloc]init];
    });
    
    return code;
}

- (void)startTimer
{
    [codeButton setTitle:@"" forState:UIControlStateNormal];
    
    codeLabel.hidden = NO;
    
    seconds = 60;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(calculateTime) userInfo:Nil repeats:YES];
    codeButton.userInteractionEnabled = NO;
}

//计算时间
- (void)calculateTime
{
    NSString *title = [NSString stringWithFormat:@"%d秒",seconds];
    
    codeLabel.text = title;
    
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
    codeButton.userInteractionEnabled = YES;
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeLabel.hidden = YES;
    seconds = 60;
}


@end

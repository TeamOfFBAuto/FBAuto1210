//
//  PeizhiMoreViewController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/22.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "PeizhiMoreViewController.h"

#import "FBCityData.h"

#import "PeizhiModel.h"

@interface PeizhiMoreViewController ()

@end

@implementation PeizhiMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *titleName = [FBCityData queryConfigNameWithid:self.pid];
    
    self.titleLabel.text = titleName;
    
    //标题
    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 35 - 14, DEVICE_WIDTH - 20, 14)];
    [aview addSubview:label];
    label.textColor = [UIColor colorWithHexString:@"373737"];
    label.text = titleName;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:aview];
    
    NSArray *arr = [FBCityData queryConfigWithPid:NSStringFromInt(self.pid)];
        
    for (int i = 0; i < arr.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderWidth = 0.5f;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:btn];
        CGFloat aWidth = (DEVICE_WIDTH - 20 - 15*2)/3.f;
        btn.frame = CGRectMake(10 + (15 + aWidth) * (i % 3),label.bottom + 15 + (15 + 40) * (i / 3), aWidth, 40);
        PeizhiModel *object = arr[i];
        [btn setTitleColor:[UIColor colorWithHexString:@"e52f17"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_color_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_color_selected"] forState:UIControlStateSelected];
        btn.layer.borderColor = [UIColor colorWithHexString:@"e52f17"].CGColor;
        [btn setTitle:object.nodename forState:UIControlStateNormal];
        
        btn.tag = 100 + [object.id intValue];
        
        [btn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.idsArray containsObject:object.id]) {
            btn.selected = YES;
        }else
        {
            btn.selected = NO;
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理


- (void)clickToSelect:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    int tag = sender.tag - 100;
    
    if (sender.selected) {
        [self.idsArray addObject:NSStringFromInt(tag)];
    }else
    {
        [self.idsArray removeObject:NSStringFromInt(tag)];
    }
}

@end

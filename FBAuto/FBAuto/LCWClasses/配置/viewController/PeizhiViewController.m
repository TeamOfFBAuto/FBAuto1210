//
//  PeizhiViewController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/20.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "PeizhiViewController.h"
#import "PeizhiModel.h"
#import "FBCityData.h"
#import "LTextView.h"

#import "PeizhiMoreViewController.h"

@interface PeizhiViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *loading;
    NSArray *arr_peizhi_one;//一级分类
    NSArray *arr_peizhi_two;
    
    UITableView *_tableView;
    
    NSMutableArray *ids_array;//已选择id数组
    
    LTextView *_textView;
}
@end

@implementation PeizhiViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_tableView) {
        
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"车源配置";
    
    loading = [LCWTools MBProgressWithText:@"数据加载..." addToView:self.view];
    
    [self createViews];//创建tableView
    
    //初始化 选择 ids
    NSArray *ids_arr = [self.idstring componentsSeparatedByString:@","];
    
    ids_array = [NSMutableArray arrayWithArray:ids_arr];
    
    NSLog(@"--->|%@|",[LCWTools cacheForKey:CAR_UPDATE_CONFIG_DATE_LOCAL]);
    //判断是否需要初始化 配置数据
    if ([LCWTools cacheForKey:CAR_UPDATE_CONFIG_DATE_LOCAL] == nil) {
        
        //初始化配置数据
        [self getPeizhiList];
        
    }else
    {
        //获取更新时间
        
        [self getPeizhiUpdateTime];
    }
    
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    _textView.delegate = nil;
    _textView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建视图

- (void)createViews
{
    arr_peizhi_one = [FBCityData queryConfigWithPid:@"0"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 203)];
    _tableView.tableFooterView = footer;
    
    _textView = [[LTextView alloc]initWithFrame:CGRectMake(10, 25, DEVICE_WIDTH - 20, 75) placeHolder:@"自定义:" fontSize:16];
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
    
    __weak typeof(_tableView)weakTable = _tableView;
    [_textView setBlock:^(LTextView *textView, ActionStyle actionStyle) {
       
        if (actionStyle == textViewDidBeginEditing) {
            
            [weakTable setContentOffset:CGPointMake(0, weakTable.contentSize.height - 203)];
            
            weakTable.scrollEnabled = NO;
            
        }else if (actionStyle == textViewDidEndEditing){
            
            [weakTable setContentOffset:CGPointMake(0, 0)];
            
            weakTable.scrollEnabled = YES;
        }
        
    }];
    [footer addSubview:_textView];
    
    UIButton *send_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    send_btn.frame = CGRectMake(45/2.f, _textView.bottom + 20, DEVICE_WIDTH - 45, 50);
    send_btn.backgroundColor = [UIColor colorWithHexString:@"222222"];
    send_btn.layer.cornerRadius = 3.f;
    [send_btn setTitle:@"确定" forState:UIControlStateNormal];
    send_btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [send_btn addTarget:self action:@selector(clickToSend:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:send_btn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.navigationController.view addGestureRecognizer:tap];
}

//数据更新
- (void)reloadTableViewData
{
    arr_peizhi_one = [FBCityData queryConfigWithPid:@"0"];
    [_tableView reloadData];
    
    _tableView.contentSize = CGSizeMake(DEVICE_WIDTH, _tableView.contentSize.height + DEVICE_HEIGHT - 203 - 64);
}

#pragma mark - 网络请求
//获取是否要更新

- (void)getPeizhiUpdateTime
{
    [loading show:YES];
    
    __weak typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:FBAUTO_GET_PEIZHI_UPDATE_DATELINE];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [loading hide:YES];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *datainfo = result[@"datainfo"];
            NSString *time = datainfo[@"time"];
            
            NSString *localTimeline = [LCWTools cacheForKey:CAR_UPDATE_CONFIG_DATE_LOCAL];
            
            localTimeline = localTimeline.length ? localTimeline : @"0";
            
            NSLog(@"time %@ local %@",time,localTimeline);
            
            if ([time compare:localTimeline] == 1) {
                
                //需要更新
                
                NSLog(@"需要更新");
                
                loading = [LCWTools MBProgressWithText:@"配置数据更新中..." addToView:self.view];
                
                [weakSelf getPeizhiListFromTime:localTimeline endTime:time];
                
            }else
            {
                NSLog(@"不需要更新");
                
            }
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [loading hide:YES];
        [LCWTools showDXAlertViewWithText:failDic[ERROR_INFO]];
        
    }];

}

//配置初始数据
- (void)getPeizhiList
{
    [loading show:YES];
    NSString *url = [NSString stringWithFormat:FBAUTO_GET_INIT_PEIZHI];
    
    __weak typeof(self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [loading hide:YES];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *datainfo = result[@"datainfo"];
            NSArray *peizhi = datainfo[@"peizhi"];
            
            BOOL succes = NO;
            for (NSDictionary *aDic in peizhi) {
                
                PeizhiModel *aModel = [[PeizhiModel alloc]initWithDictionary:aDic];
                
               succes = [FBCityData insertCarConfigId:aModel.id pid:aModel.pid nodename:aModel.nodename dateline:aModel.dateline uptime:aModel.uptime isdel:aModel.isdel];
                
            }
            
            if (succes) {
                
                NSLog(@"配置数据保存完成");
                
                [LCWTools cache:[LCWTools timechangeToDateline] ForKey:CAR_UPDATE_CONFIG_DATE_LOCAL];
                
                [weakSelf reloadTableViewData];
            }
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [loading hide:YES];
        [LCWTools showDXAlertViewWithText:failDic[ERROR_INFO]];
        
    }];
}

//配置增量更新

- (void)getPeizhiListFromTime:(NSString *)fromTime endTime:(NSString *)endTime
{
    [loading show:YES];
    
    __weak typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:FBAUTO_GET_PEIZHI_NEW,fromTime,endTime];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [loading hide:YES];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *datainfo = result[@"datainfo"];
            NSArray *peizhi = datainfo[@"peizhi"];
            
            BOOL succes = NO;
            for (NSDictionary *aDic in peizhi) {
                
                PeizhiModel *aModel = [[PeizhiModel alloc]initWithDictionary:aDic];
                
                if ([FBCityData existCarPeizhiId:aModel.id]) {
                    
                    //更新
                    succes = [FBCityData updateCarConfigId:aModel.id pid:aModel.pid nodename:aModel.nodename dateline:aModel.dateline uptime:aModel.uptime isdel:aModel.isdel];
                    
                }else
                {
                    //插入
                    
                    succes = [FBCityData insertCarConfigId:aModel.id pid:aModel.pid nodename:aModel.nodename dateline:aModel.dateline uptime:aModel.uptime isdel:aModel.isdel];
                }
                
            }
            
            if (succes) {
                
                NSLog(@"配置数据保存完成");
                
                [LCWTools cache:[LCWTools timechangeToDateline] ForKey:CAR_UPDATE_CONFIG_DATE_LOCAL];
                
                [weakSelf reloadTableViewData];
            }
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [loading hide:YES];
        [LCWTools showDXAlertViewWithText:failDic[ERROR_INFO]];
        
    }];
}


#pragma mark - 事件处理


- (void)setPeizhiBlcock:(PeizhiBlock)aBlock
{
    peizhiBlock = aBlock;
}

- (IBAction)clickToBack:(id)sender {
    
    if (peizhiBlock) {
        
        NSString *idstring = [ids_array componentsJoinedByString:@","];
        peizhiBlock(idstring,_textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToSend:(UIButton *)sender
{
    [self clickToBack:sender];
}

- (void)hiddenKeyboard
{
    [_textView resignFirstResponder];
}

- (void)clickToSelect:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    int tag = sender.tag - 100;
    
    if (sender.selected) {
        [ids_array addObject:NSStringFromInt(tag)];
    }else
    {
        [ids_array removeObject:NSStringFromInt(tag)];
    }
}

- (void)clickToMore:(UIButton *)sender
{
    PeizhiMoreViewController *more = [[PeizhiMoreViewController alloc]init];
    more.pid = sender.tag - 1000;
    more.idsArray = ids_array;
    [self.navigationController pushViewController:more animated:YES];
//    self.navigationController.delegate = self;
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController == self) {
//        
//        [_tableView reloadData];
//    }
//}

#pragma mark - UITableViewDataSource<NSObject>


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return arr_peizhi_one.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_peizhi_one.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    for (UIView *aView in cell.contentView.subviews) {
        [aView removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PeizhiModel *aModel = arr_peizhi_one[indexPath.row];
    
    //标题
    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 35 - 14, DEVICE_WIDTH - 20, 14)];
    [aview addSubview:label];
    label.textColor = [UIColor colorWithHexString:@"373737"];
    label.text = aModel.nodename;
    label.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:aview];
    
    //配置按钮
    NSArray *arr = [FBCityData queryConfigWithPid:aModel.id];
    if (arr.count > 5) {
        
        for (int i = 0; i < 6; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.borderWidth = 0.5f;
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:btn];
            CGFloat aWidth = (DEVICE_WIDTH - 20 - 15*2)/3.f;
            btn.frame = CGRectMake(10 + (15 + aWidth) * (i % 3),label.bottom + 15 + (15 + 40) * (i / 3), aWidth, 40);
            
            if (i != 5) {
                PeizhiModel *object = arr[i];
                [btn setTitleColor:[UIColor colorWithHexString:@"e52f17"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_color_normal"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_color_selected"] forState:UIControlStateSelected];
                btn.layer.borderColor = [UIColor colorWithHexString:@"e52f17"].CGColor;
                [btn setTitle:object.nodename forState:UIControlStateNormal];
                
                btn.tag = 100 + [object.id intValue];
                
                [btn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([ids_array containsObject:object.id]) {
                    btn.selected = YES;
                }else
                {
                    btn.selected = NO;
                }
                
            }else
            {
                btn.layer.borderColor = [UIColor colorWithHexString:@"9d9d9d"].CGColor;
                [btn setTitleColor:[UIColor colorWithHexString:@"8a8a8a"] forState:UIControlStateNormal];
                [btn setTitle:@"更多" forState:UIControlStateNormal];
                
                btn.tag = 1000 + [aModel.id intValue];
                [btn addTarget:self action:@selector(clickToMore:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
        }
    }else
    {
        for (int i = 0; i < arr.count; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.borderWidth = 0.5f;
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:btn];
            CGFloat aWidth = (DEVICE_WIDTH - 20 - 15*2)/3.f;
            btn.frame = CGRectMake(10 + (15 + aWidth) * (i % 3), label.bottom + 15 + (15 + 40) * (i / 3), aWidth, 40);
            
            PeizhiModel *object = arr[i];
            [btn setTitleColor:[UIColor colorWithHexString:@"e52f17"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_color_normal"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_color_selected"] forState:UIControlStateSelected];
            btn.layer.borderColor = [UIColor colorWithHexString:@"e52f17"].CGColor;
            [btn setTitle:object.nodename forState:UIControlStateNormal];
            
            btn.tag = 100 + [object.id intValue];
            
            [btn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([ids_array containsObject:object.id]) {
                btn.selected = YES;
            }else
            {
                btn.selected = NO;
            }
        }
    }
    
    
    return cell;
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeizhiModel *aModel = arr_peizhi_one[indexPath.row];
    
    NSArray *arr = [FBCityData queryConfigWithPid:aModel.id];
    if (arr.count > 3) {
        
        return 110 + 35;//两行
    }
    
    return 55 + 35;//一行
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    PeizhiModel *aModel = arr_peizhi_one[section];
//    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 35)];
////    aview.backgroundColor = [UIColor orangeColor];
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 35 - 14, DEVICE_WIDTH - 20, 14)];
//    [aview addSubview:label];
//    label.textColor = [UIColor colorWithHexString:@"373737"];
//    label.text = aModel.nodename;
//    label.font = [UIFont systemFontOfSize:14];
//    
//    return aview;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 35;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50;
//}

@end

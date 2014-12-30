//
//  FindViewController.m
//  FBAuto
//
//  Created by lichaowei on 14/12/11.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindViewController.h"
#import "RefreshTableView.h"

#import "TucaoViewCell.h"
#import "TucaoModel.h"

#import "TucaoPublishController.h"

#import "TucaoDetailController.h"

@interface FindViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
}

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"吐糟";
    self.button_back.hidden = YES;
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 49 - 64)];
    
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:NO];
    
    
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [saveButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:[UIImage imageNamed:@"shoucang_46_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
    
    self.navigationItem.rightBarButtonItems = @[save_item];
}

- (void)test
{
    TucaoPublishController *publishTucao = [[TucaoPublishController alloc]init];
    
    [self PushToViewController:publishTucao animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

/**
 *  获取吐槽列表
 */
- (void)getTucaoList
{
    
    NSString *url = [NSString stringWithFormat:FBATUO_TUCAO_LIST,_table.pageNum,KPageSize,[GMAPI getAuthkey]];
    
    //    __weak typeof(FindCarViewController *)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr_ = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
             TucaoModel *aModel = [[TucaoModel alloc]initWithDictionary:aDic];
            
            [arr_ addObject:aModel];
        }
        
        [_table reloadData:arr_ total:total];
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
        
        int errocode = [[failDic objectForKey:@"errocode"]integerValue];
        if (errocode == 1) {
            NSLog(@"结果为空");
            [_table reloadData:nil total:0];
        }
        
        [_table loadFail];
        
    }];
}


#pragma - mark RefreshDelegate <NSObject>


- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
    NSLog(@"offset %f",offset);
}

- (void)refreshScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"refreshScrollViewDidEndDecelerating");
    
    //    currentOffsetY = scrollView.contentOffset.y;
}

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self getTucaoList];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    [self getTucaoList];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TucaoDetailController *detail = [[TucaoDetailController alloc]init];
    detail.tucaoModel = _table.dataArray[indexPath.row];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 316;
}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return _table.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"TucaoViewCell";
    TucaoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TucaoViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TucaoModel *aModel = (TucaoModel *)_table.dataArray[indexPath.row];
    [cell setCellWithModel:aModel];
    
    return cell;
    
}


@end

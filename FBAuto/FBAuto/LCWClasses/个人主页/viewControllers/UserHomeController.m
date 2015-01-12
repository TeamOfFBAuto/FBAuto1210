//
//  UserHomeController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/9.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "UserHomeController.h"

@interface UserHomeController ()<UIScrollViewDelegate,RefreshDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *scroll_bg;
    
    RefreshTableView *_table;
    
    UITableView *leftTable;
    UITableView *rightTable;
}

@end

@implementation UserHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    scroll_bg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    scroll_bg.delegate = self;
//    [self.view addSubview:scroll_bg];
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _table.tableHeaderView = [self createHeaderView];
    
    //搜索遮罩
//    [_table showRefreshHeader:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma - mark 创建视图

- (UIView *)createHeaderView
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    
    //背景图
    UIImageView *image_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 256)];
    image_bg.backgroundColor = [UIColor orangeColor];
    [header addSubview:image_bg];
    
    //头像
    UIImageView *image_Head = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 10 - 75, 206, 75, 75)];
    image_Head.layer.borderWidth = 3.f;
    image_Head.layer.borderColor = [UIColor whiteColor].CGColor;
    [header addSubview:image_Head];
    
    header.height = image_Head.bottom + 10;
    
    return header;
    
}

#pragma - mark 网络请求

#pragma - mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    
}
- (void)loadMoreData
{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return DEVICE_HEIGHT - 64;
}

- (UIView *)refreshTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        
        UIView *section_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
        section_view.backgroundColor = [UIColor redColor];
        
        NSArray *items_names = @[@"在售车源",@"留言"];
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:items_names[i] forState:UIControlStateNormal];
            [section_view addSubview:btn];
            btn.frame = CGRectMake(DEVICE_WIDTH/2.f * i, 0, DEVICE_WIDTH/2.f, 42);
        }
        
        return section_view;
    }
    
    return [UIView new];
}

- (CGFloat)refreshTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)refreshScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

#pragma - mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == leftTable) {
        
        return 20;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView == leftTable) {
        
        static NSString * identifier = @"leftCell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        
        return cell;
    }
    
    static NSString * identifier = @"sourceCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
            leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64) style:UITableViewStylePlain];
            leftTable.delegate = self;
            leftTable.dataSource = self;
        
        [cell addSubview:leftTable];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}


@end

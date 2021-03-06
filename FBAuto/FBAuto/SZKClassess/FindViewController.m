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

#import "TucaoPublish.h"

#import "TucaoDetailController.h"

#import "GridView.h"

#import "FBPhotoBrowserController.h"

@interface FindViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    
    CGFloat currentOffsetY;
    CGFloat oldTableHeight;//table初始高度
    UIView *statesBarView;//灰色状态栏
}

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"吐槽故事";
    self.button_back.hidden = YES;
    
    oldTableHeight = self.view.height - 49 - 64;
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.view.height - 49 - 64)];
    
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTucaoList:) name:NOTIFICATION_PUBLISHTUCAO_SUCCESS object:nil];
    
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 50 - 10,self.view.height - 64 - 49 - 50 - 10,50,50)];
    [saveButton addTarget:self action:@selector(clickToPublishTucao) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:[UIImage imageNamed:@"tucao_add"] forState:UIControlStateNormal];
    
    [self.view addSubview:saveButton];
    
    statesBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.width, 20)];
    statesBarView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:statesBarView];
}

#pragma mark 事件处理

- (void)updateTucaoList:(NSNotification *)notification
{
    [_table showRefreshHeader:NO];
}

/**
 *  发布吐槽
 */
- (void)clickToPublishTucao
{
//    TucaoPublishController *publishTucao = [[TucaoPublishController alloc]init];
//    
//    [self PushToViewController:publishTucao animated:YES];
//    
//    [self updateViewFrameForShow:YES duration:0.2];
    
    TucaoPublish *publishTucao = [[TucaoPublish alloc]init];
    [self PushToViewController:publishTucao animated:YES];
    [self updateViewFrameForShow:YES duration:0.2];

}

/**
 *  调整至大图
 *
 *  @param images     图片url数组
 *  @param imageIndex 显示图片下标
 */
- (void)clickToBigPhotoWithImages:(NSArray *)images showIndex:(int)imageIndex{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *urlDic in images) {
        
        NSMutableString *str = [NSMutableString stringWithString:[urlDic objectForKey:@"link"]];
        
        [str replaceOccurrencesOfString:@"small" withString:@"ori" options:0 range:NSMakeRange(0, str.length)];
        
        [arr addObject:str];
        
    }
    
    FBPhotoBrowserController *browser = [[FBPhotoBrowserController alloc]init];
    browser.imagesArray = arr;
    browser.showIndex = imageIndex;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
    [self updateViewFrameForShow:YES duration:0.2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

//赞

- (void)clickToZan:(UIButton *)sender
{
    int index = sender.tag - 1000;
    
    TucaoModel *aModel = (TucaoModel *)_table.dataArray[index];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    TucaoViewCell *aCell = (TucaoViewCell *)[_table cellForRowAtIndexPath:indexPath];
    
    if (sender.selected) {
        
        return;
        
    }else
    {
        sender.selected = YES;
        
        aCell.likeLabel.text = [NSString stringWithFormat:@"%d",[aCell.likeLabel.text intValue] + 1];
        
        aModel.zan_num = aCell.likeLabel.text;
        
        aCell.likeButton.selected = YES;
        
        aModel.dianzan_status = 1;

    }
    
    
    NSString *url = [NSString stringWithFormat:FBAUTO_TUCAO_ZAN,[GMAPI getAuthkey],aModel.id];
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"赞erro%@",[result objectForKey:@"errinfo"]);
        
//        [LCWTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];
        
//        aCell.likeLabel.text = [NSString stringWithFormat:@"%d",[aCell.likeLabel.text intValue] + 1];
//        
//        aModel.zan_num = aCell.likeLabel.text;
//       
//        aCell.likeButton.selected = YES;
//       
//        aModel.dianzan_status = 1;
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
//        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
        
    }];
    
}

/**
 *  获取吐槽列表
 */
- (void)getTucaoList
{
    
    NSString *url = [NSString stringWithFormat:FBATUO_TUCAO_LIST,_table.pageNum,KPageSize,[GMAPI getAuthkey],@""];
    
    //    __weak typeof(FindCarViewController *)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"吐槽列表erro%@",[result objectForKey:@"errinfo"]);
        
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

#pragma mark 列表滑动更新视图

//滑动列表时更新 navigationBar  tabbar 等视图 frame

- (void)updateViewFrameForShow:(BOOL)show duration:(CGFloat)seconds
{
    __weak typeof(_table)weakTable = _table;
    
    __weak typeof(statesBarView)weakstatesBarView = statesBarView;
    
    weakTable.top = show ? 0 : -44;
    
    weakTable.height = show ? oldTableHeight : self.view.height + 64 + 49;
    
    [UIView animateWithDuration:seconds animations:^{
        
        
        CGFloat aY = show ? 20 : -44;
        
        self.navigationController.navigationBar.top = aY;
        
        self.tabBarController.tabBar.top = show ? DEVICE_HEIGHT - 49 : DEVICE_HEIGHT;
        
//        NSLog(@"----tabbar %f",self.tabBarController.tabBar.top);
        
        weakstatesBarView.top = show ? -20 : -64;
        
    }];
    
}


#pragma - mark RefreshDelegate <NSObject>


- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
//    NSLog(@"offset %f",offset);
    
    if (offset > 20 && offset > currentOffsetY) {
        
        //消失
        
        [self updateViewFrameForShow:NO duration:0.2];
        
    }
    
    if (offset > 0 && offset < currentOffsetY) {
        
        [self updateViewFrameForShow:YES duration:0.2];
    }
    
    if (scrollView.contentOffset.y <= ((scrollView.contentSize.height - scrollView.frame.size.height-40))) {
        
        currentOffsetY = scrollView.contentOffset.y;
    }
    
}



#pragma - mark RefreshDelegate <NSObject>


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
    TucaoViewCell *cell = (TucaoViewCell *)[_table cellForRowAtIndexPath:indexPath];
    
    TucaoDetailController *detail = [[TucaoDetailController alloc]init];
    detail.tucaoModel = _table.dataArray[indexPath.row];
    
    detail.commentLabe = cell.commentLable;
    detail.likeLabel = cell.likeLabel;
    detail.zanButton = cell.likeButton;
    
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
    [self updateViewFrameForShow:YES duration:0.0];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    TucaoModel *aModel = (TucaoModel *)_table.dataArray[indexPath.row];
    
    return [TucaoViewCell heightForCellWithModel:aModel];
}

//判断是否有图
- (BOOL)haveImage:(NSArray *)imageArr
{
    if (imageArr.count > 0 && ((NSString *)imageArr[0][@"link"]).length > 0) {
        return YES;
    }
    
    return NO;
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
    
    cell.likeButton.tag = 1000 + indexPath.row;
    [cell.likeButton addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self)weakSelf = self;
    
    //点击图片 进 大图
    cell.gridView.clickBlock = ^(int imageIndex,NSArray *images){
        
        [weakSelf clickToBigPhotoWithImages:images showIndex:imageIndex];
    };
    
    
    return cell;
    
}


@end

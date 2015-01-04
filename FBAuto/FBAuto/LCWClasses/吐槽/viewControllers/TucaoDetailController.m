//
//  TucaoDetailController.m
//  FBAuto
//
//  Created by lichaowei on 14/12/30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "TucaoDetailController.h"
#import "RefreshTableView.h"

#import "TucaoViewCell.h"
#import "TucaoModel.h"

#import "TucaoPublishController.h"

@interface TucaoDetailController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    TucaoModel *tucaoDetail;
    
    TucaoViewCell *cell_detail;
    
}
@end

@implementation TucaoDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"吐糟详情";
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 64)];
    
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_table];
    

    tucaoDetail = self.tucaoModel;
    [self getTucaoDetail];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

/**
 *  获取吐槽列表
 */
- (void)getTucaoDetail
{
    
    NSString *url = [NSString stringWithFormat:FBATUO_TUCAO_DETAIL,self.tucaoModel.id,KPageSize];
    
        __weak typeof(_table)weakTable = _table;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        NSDictionary *article = [dataInfo objectForKey:@"article"];
        
        // 吐槽详情
        
        tucaoDetail = [[TucaoModel alloc]initWithDictionary:article];
        
        tucaoDetail.image = [NSArray arrayWithArray:tucaoDetail.data[@"image"]];
        
        //吐槽评论

        NSDictionary *comment = [dataInfo objectForKey:@"comment"];
        int total = [comment[@"total"]intValue];
        NSArray *data = comment[@"data"];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *aDic in data) {
            
            TucaoModel *commentModel = [[TucaoModel alloc]initWithDictionary:aDic];
            [arr addObject:commentModel];
        }
        
        [weakTable reloadData:arr total:total];
        
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


/**
 *  获取吐槽列表
 */
- (void)getTucaoComment
{
    NSString *url = [NSString stringWithFormat:FBATUO_TUCAO_CommentList,self.tucaoModel.id,@"1",_table.pageNum,KPageSize];
    
    __weak typeof(_table)weakTable = _table;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        //吐槽评论
        
        int total = [dataInfo[@"total"]intValue];
        NSArray *data = dataInfo[@"data"];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *aDic in data) {
            
            TucaoModel *commentModel = [[TucaoModel alloc]initWithDictionary:aDic];
            [arr addObject:commentModel];
        }
        
        [weakTable reloadData:arr total:total];
        
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

//评论
- (void)clickToComment:(UIButton *)sender
{
    //弹出评论框
    
//    NSString *url = [NSString stringWithFormat:FBATUO_TUCAO_CommentList,self.tucaoModel.id,@"1",_table.pageNum,KPageSize];
//    
//    __weak typeof(_table)weakTable = _table;
//    
//    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
//    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
//        
//        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
//        
//        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
//        
//        
//        
//    }failBlock:^(NSDictionary *failDic, NSError *erro) {
//        
//        NSLog(@"failDic %@",failDic);
//        
//        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
//        
//        
//    }];
}


//赞

- (void)clickToZan:(UIButton *)sender
{
    NSString *url = [NSString stringWithFormat:FBAUTO_TUCAO_ZAN,[GMAPI getAuthkey],self.tucaoModel.id];
    
    __weak typeof(_table)weakTable = _table;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
       
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];

        
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
    
    [self getTucaoDetail];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    [self getTucaoComment];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//判断是否有图
- (BOOL)haveImage:(NSArray *)imageArr
{
    if (imageArr.count > 0 && ((NSString *)imageArr[0][@"link"]).length > 0) {
        return YES;
    }
    
    return NO;
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        
        //有图片有文字
        
        if ([self haveImage:tucaoDetail.image] && tucaoDetail.content.length > 0 ) {
            
            CGFloat aHeight = [LCWTools heightForText:tucaoDetail.content width:300 font:17];
            
            return 400 - 20 + aHeight;
        }
        
        return 400 - 40;
    }
    return 40;
}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString * identifier = @"TucaoViewCell";
        cell_detail = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell_detail == nil)
        {
            cell_detail = [[[NSBundle mainBundle]loadNibNamed:@"TucaoViewCell" owner:self options:nil]objectAtIndex:0];
        }
        
        [cell_detail setCellWithModel:tucaoDetail];
        
        cell_detail.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell_detail.likeButton addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
        [cell_detail.commentButton addTarget:self action:@selector(clickToComment:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell_detail;
    }
    
    static NSString *identifier = @"comment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
    
}


@end

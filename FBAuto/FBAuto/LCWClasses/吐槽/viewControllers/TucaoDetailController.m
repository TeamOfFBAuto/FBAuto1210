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

#import "TucaoCommentCell.h"

#import "TucaoPublishController.h"

#import "CommentBottomView.h"

#import "LInputView.h"

@interface TucaoDetailController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    TucaoModel *tucaoDetail;
    
    TucaoViewCell *cell_detail;
    
    LInputView *inputView;
    
}
@end

@implementation TucaoDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"吐糟详情";
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.view.height - 64) showLoadMore:NO];
    
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_table];
    
    [self createBottomCommentView];
    
    _table.tableFooterView = [self footerViewForTable];

    tucaoDetail = self.tucaoModel;
    [self getTucaoDetail];
}

/**
 *  底部评论
 */
- (void)createBottomCommentView
{
//    UIView *comment_view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 62 - 64, 320, 62)];
//    comment_view.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:comment_view];
    
    CommentBottomView *bottomView = [[CommentBottomView alloc] init];
//    bottomView.hidden = YES;
    [self.view addSubview:bottomView];
    
//    __weak typeof(self)weakSelf = self;
    
    [bottomView setMyBlock:^(CommentTapType aType) {
        NSLog(@"bottom tap : %d",aType);
        
        if (aType == CommentTypeLogIn) {
            
            
            
        }else if (aType == CommentTypeComent){
        
            NSLog(@"弹出评论框");
            
            [inputView.textView becomeFirstResponder];
        }
        
    }];
    
    inputView = [[LInputView alloc]initWithFrame:CGRectMake(0, self.view.height, DEVICE_WIDTH, 0) inView:self.view inputText:^(NSString *inputText) {
        
        NSLog(@"评论内容 %@",inputText);
        
        //添加评论
        //
        
        [self addTucaoComment:inputText];
        
    }];
    
    inputView.clearInputWhenSend = NO;;
    inputView.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:inputView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

//- (void)addLocalComment:(NSString *)text
//{
//    TucaoModel *commentModel = [[TucaoModel alloc]initWithDictionary:aDic];
//    _table.dataArray insertObject:<#(id)#> atIndex:<#(NSUInteger)#>
//}

#pragma mark - 创建视图
- (UIView *)footerViewForTable
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 62)];
    
//    //框
//    UIView *kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 13, 320 - 10*2, 75)];
//    kuang.layer.borderWidth = 0.5f;
//    kuang.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
//    [footer addSubview:kuang];
//    
//    //文字
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, 45, 18)];
//    title.font = [UIFont systemFontOfSize:18];
//    title.textColor = [UIColor colorWithHexString:@"222222"];
//    title.textAlignment = NSTextAlignmentRight;
//    title.text = @"评论:";
//    [kuang addSubview:title];
//    
//    
//    UIButton *publish_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    publish_btn.frame = CGRectMake(22, kuang.bottom +15, 320 - 22 * 2, 50);
//    [publish_btn setBackgroundImage:[UIImage imageNamed:@"fabu550_100"] forState:UIControlStateNormal];
//    [publish_btn setTitle:@"发布" forState:UIControlStateNormal];
//    [footer addSubview:publish_btn];
    
    return footer;
}



#pragma mark - 网络请求

/**
 *  获取吐槽列表
 */
- (void)addTucaoComment:(NSString *)text
{
    if ([LCWTools isEmpty:text]) {
        
        [LCWTools showMBProgressWithText:@"评论内容不能为空" addToView:self.view];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:FBAUTO_TUCAO_Comment,[GMAPI getAuthkey],text,self.tucaoModel.id,@"1"];
    
    __weak typeof(_table)weakTable = _table;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"erro%@",[result objectForKey:@"errinfo"]);
        
        //成功之后 评论 + 1
        
//        [LCWTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];
        
        TucaoModel *aModel = [[TucaoModel alloc]init];
        aModel.uid = [GMAPI getUid];
        aModel.username = [GMAPI getUsername];
        aModel.content = text;
        
        [weakTable.dataArray insertObject:aModel atIndex:0];
        
        int num = [cell_detail.commentLable.text intValue];
        
        NSLog(@"---comment num %d",num);
        
        cell_detail.commentLable.text = [NSString stringWithFormat:@"%d",num + 1];
        
        tucaoDetail.comemt_num = [NSString stringWithFormat:@"%d",num + 1];
        
        self.tucaoModel.comemt_num = tucaoDetail.comemt_num;
        
        [weakTable reloadData];

        
        NSLog(@"---commentLable num %@",cell_detail.commentLable.text);
        
        self.commentLabe.text = cell_detail.commentLable.text;//更新列表
        
        [inputView clearContent];
        
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
    }];
}


/**
 *  获取吐槽列表
 */
- (void)getTucaoDetail
{
    
    NSString *url = [NSString stringWithFormat:FBATUO_TUCAO_DETAIL,self.tucaoModel.id,10000];
    
        __weak typeof(_table)weakTable = _table;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        NSDictionary *article = [dataInfo objectForKey:@"article"];
        
        // 吐槽详情
        
        tucaoDetail = [[TucaoModel alloc]initWithDictionary:article];
        
//        tucaoDetail.image = [NSArray arrayWithArray:tucaoDetail.data[@"image"]];
        
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
    
    [inputView.textView becomeFirstResponder];
}


//赞

- (void)clickToZan:(UIButton *)sender
{
    
    if (sender.selected) {
        
        return;
    }else
    {
        sender.selected = YES;
        
        
        cell_detail.likeLabel.text = [NSString stringWithFormat:@"%d",[cell_detail.likeLabel.text intValue] + 1];
        
        tucaoDetail.zan_num = self.likeLabel.text;
        
        cell_detail.likeButton.selected = YES;
        
        //更新上一页列表数据
        
        self.likeLabel.text = cell_detail.likeLabel.text;
        
        self.zanButton.selected = YES;
        
        self.tucaoModel.zan_num = tucaoDetail.zan_num;
        
        self.tucaoModel.dianzan_status = 1;
    }
    
    
    NSString *url = [NSString stringWithFormat:FBAUTO_TUCAO_ZAN,[GMAPI getAuthkey],self.tucaoModel.id];
    
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
//        [LCWTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];
        
        
//        cell_detail.likeLabel.text = [NSString stringWithFormat:@"%d",[cell_detail.likeLabel.text intValue] + 1];
//       
//        tucaoDetail.zan_num = self.likeLabel.text;
//        
//        cell_detail.likeButton.selected = YES;
//        
//        //更新上一页列表数据
//        
//        self.likeLabel.text = cell_detail.likeLabel.text;
//        
//        self.zanButton.selected = YES;
//        
//        self.tucaoModel.zan_num = tucaoDetail.zan_num;
//        
//        self.tucaoModel.dianzan_status = 1;
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];

        
    }];
 
}

#pragma - mark RefreshDelegate <NSObject>


- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat offset = scrollView.contentOffset.y;
    
//    NSLog(@"offset %f",offset);
}

- (void)refreshScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"refreshScrollViewDidEndDecelerating");
    
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
    
    TucaoModel *aModel = _table.dataArray[indexPath.row - 1];
    
    return 76 - 18 + [LCWTools heightForText:aModel.content width:235 font:15];
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
    
    static NSString *identifier1 = @"TucaoCommentCell";
    TucaoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TucaoCommentCell" owner:self options:nil]lastObject];
    }
    
    [cell setCellWithModel:_table.dataArray[indexPath.row - 1]];
    cell.bottomLine.top = cell.bottom - 0.5;
    cell.bottomLine.height = 0.5f;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


@end

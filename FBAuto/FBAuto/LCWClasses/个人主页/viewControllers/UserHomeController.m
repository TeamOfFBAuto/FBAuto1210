//
//  UserHomeController.m
//  FBAuto
//
//  Created by lichaowei on 15/1/9.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "UserHomeController.h"
#import "GuserModel.h"
#import "FBCityData.h"

#import "CarSourceCell.h"
#import "CarSourceClass.h"

#import "FBDetail2Controller.h"
#import "LiuyanViewController.h"

#import "LiuyanCell.h"

#import "DXAlertView.h"

@interface UserHomeController ()<UIScrollViewDelegate,RefreshDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *scroll_bg;
    
    RefreshTableView *_table;
    
    RefreshTableView *leftTable;
    RefreshTableView *rightTable;
    
    GuserModel *userModel;
    
    UIView *line_left;
    UIView *line_right;
    
    UIView *view_liuyan;//留言按钮背景view
    
    BOOL isCarsource;//当前是否是 车源列表
    
    NSMutableArray *arr_carsource;//车源数据源
    NSMutableArray *arr_liuyan;
    
    int page_carsource;//车源 页数
    int page_liuyan;
    int total_carsource;//车源总页数
    int total_liuyan;
    
    int friend_status;//用户关系  -1:不是好友关系 0:好友 1:添加中 2:接到邀请 3:特别关注
    UIButton *rightButton2;
    
    NSArray *titles;
    
    MBProgressHUD *loading;
    
    BOOL firstLoadData;//第一次加载数据
}

@end

@implementation UserHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.titleLabel.text = self.title;
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64) needShowLoadMore:YES];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _table.contentSize = CGSizeMake(DEVICE_WIDTH, (DEVICE_HEIGHT - 64) * 2);
    
    isCarsource = YES;//默认是车源
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLiuyan:) name:NOTIFICATION_PUBLISH_LIYYAN_SUCCESS object:nil];
    
    firstLoadData = YES;
    
    //搜索遮罩
    [_table showRefreshHeader:YES];
    
    arr_carsource = [NSMutableArray array];
    arr_liuyan = [NSMutableArray array];
    
    [self prepareUeserInfo];//用户信息
    
//    [self getCarSourceIsReload:YES page:1];//车源
//    
//    [self getLiuyanIsReload:YES page:1];//留言
    
    
    view_liuyan = [self liuyanVeiw];//留言view
    view_liuyan.hidden = YES;
    [self.view addSubview:view_liuyan];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 事件处理

- (void)clickToAddFriend:(UIButton *)sender
{
    NSString *name = userModel.name ? userModel.name : userModel.fullname;
    
    NSString *message = [NSString stringWithFormat:@"是否添加%@为好友",name];
    
    //用户关系  -1:不是好友关系 0:好友 1:添加中 2:接到邀请 3:特别关注
    
    BOOL isConcern = YES;
    if (friend_status == -1) {
        
        NSLog(@"加好友");
        message = [NSString stringWithFormat:@"是否添加%@为好友",name];
        isConcern = NO;
        
    }else if (friend_status == 0 || friend_status == 1 || friend_status == 2){
        message = [NSString stringWithFormat:@"是否关注%@",name];
        isConcern = YES;
    }
    
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:message contentText:nil leftButtonTitle:@"添加" rightButtonTitle:@"取消" isInput:NO];
    [alert show];
    
    __weak typeof(self)weakSelf = self;
    alert.leftBlock = ^(){
        NSLog(@"确定");
        [weakSelf addFriend:userModel.uid isConcern:isConcern];
    };
    alert.rightBlock = ^(){
        NSLog(@"取消");
        
    };
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath
                          IsCarSource:(BOOL)isCar
{
    if (isCar) {
        
        static NSString * identifier = @"CarSourceCell";
        
        CarSourceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CarSourceCell" owner:self options:nil]objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row % 2 == 0) {
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        }else
        {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        if (_table.dataArray.count > indexPath.row) {
            CarSourceClass *aCar = [_table.dataArray objectAtIndex:indexPath.row];
            [cell setCellDataWithModel:aCar];
        }
        
        return cell;
        
    }
        
    static NSString * identifier = @"LiuyanCell";
    
    LiuyanCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LiuyanCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if (_table.dataArray.count > indexPath.row)
    {
        LiuyanModel *aCar = [_table.dataArray objectAtIndex:indexPath.row];
        [cell setCellWithModel:aCar];

    }
    
    cell.bottomLine.top = cell.height - 0.5f;
    cell.bottomLine.height = 0.5f;
    
    return cell;
}


/**
 *  刷新留言列表
 */
- (void)refreshLiuyan:(NSNotification *)notification
{
    [self getLiuyanIsReload:YES page:1];
}

- (void)clickToLiuyan:(UIButton *)sender
{
    NSLog(@"留言页面");
    LiuyanViewController *liuyan = [[LiuyanViewController alloc]init];
    liuyan.art_uid = self.userId;
    [self.navigationController pushViewController:liuyan animated:YES];
}

- (void)clickToSwap:(UIButton *)sender
{
    sender.selected = YES;
    
    [_table.dataArray removeAllObjects];
    if (sender.tag == 70) {
        
        //left
        
        line_left.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
        line_right.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        [self buttonForTag:71].selected = NO;
        
//        leftTable.hidden = NO;
//        rightTable.hidden = YES;
        
        isCarsource = YES;
        
//        [_table reloadData:arr_carsource total:total_carsource];
        
        [_table reloadData:arr_carsource haveMore:(page_carsource < total_carsource ? YES : NO)];
        
        view_liuyan.hidden = YES;
        _table.height = DEVICE_HEIGHT - 64;
        
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }else if (sender.tag == 71){
        //right
        
        line_right.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
        line_left.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        [self buttonForTag:70].selected = NO;
        
//        rightTable.hidden = NO;
//        leftTable.hidden = YES;
        
        isCarsource = NO;
        
//        [_table reloadData:arr_liuyan total:total_liuyan];
        
        [_table reloadData:arr_liuyan haveMore:(page_liuyan < total_liuyan ? YES : NO)];
        
        view_liuyan.hidden = NO;
        _table.height = DEVICE_HEIGHT - 64 - 85;
        
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self.view viewWithTag:tag];
}


#pragma - mark 创建视图

/**
 *  右上角添加或者关注按钮
 */
- (void)createRightButton
{
    if ([self.userId isEqualToString:[GMAPI getUid]]) {
        //说明是自己
        
    }else
    {
        if (rightButton2 == nil) {
            rightButton2 =[[UIButton alloc]initWithFrame:CGRectMake(0,8,70,29)];
            [rightButton2 addTarget:self action:@selector(clickToAddFriend:) forControlEvents:UIControlEventTouchUpInside];
            [rightButton2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            //        [rightButton2 setImage:[UIImage imageNamed:@"jiahaoyou 92_58"] forState:UIControlStateNormal];
            UIBarButtonItem *save_item2=[[UIBarButtonItem alloc]initWithCustomView:rightButton2];
            rightButton2.titleLabel.font = [UIFont systemFontOfSize:14];
            self.navigationItem.rightBarButtonItems = @[save_item2];
        }

        //用户关系  -1:不是好友关系 0:好友 1:添加中 2:接到邀请 3:特别关注
        
        switch (friend_status) {
            case -1:
            case 1:
            case 2:
            {
                NSLog(@"-1:不是好友关系 1:添加中 2:接到邀请");
                
                [rightButton2 setTitle:@"加好友" forState:UIControlStateNormal];
                [rightButton2 setTitle:@"关注" forState:UIControlStateSelected];
            }
                break;
            case 0:
            {
                NSLog(@"好友");
                [rightButton2 setTitle:@"关注" forState:UIControlStateNormal];
                [rightButton2 setTitle:@"已关注" forState:UIControlStateSelected];
            }
                break;
                
            case 3:
            {
               NSLog(@"特别关注");
                [rightButton2 setTitle:@"已关注" forState:UIControlStateNormal];
                rightButton2.userInteractionEnabled = NO;
            }
                break;


                
            default:
                break;
        }
        
    }
}

- (UIView *)liuyanVeiw
{
    UIView * liuyan = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 85 - 64, DEVICE_WIDTH, 85)];
    liuyan.backgroundColor = [UIColor whiteColor];
    UIButton *btn_liuyan = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_liuyan setTitle:@"留言" forState:UIControlStateNormal];
    btn_liuyan.frame = CGRectMake(25, 20, DEVICE_WIDTH - 50, 50);
    btn_liuyan.layer.cornerRadius = 3.f;
    btn_liuyan.backgroundColor = [UIColor colorWithHexString:@"222222"];
    [liuyan addSubview:btn_liuyan];
    
    [btn_liuyan addTarget:self action:@selector(clickToLiuyan:) forControlEvents:UIControlEventTouchUpInside];
    
    return liuyan;
}

- (UIView *)liuyan
{
    if (view_liuyan) {
        return view_liuyan;
    }
    
    //DEVICE_HEIGHT - 64 - 85
    view_liuyan = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 85)];
    view_liuyan.backgroundColor = [UIColor whiteColor];
    UIButton *btn_liuyan = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_liuyan setTitle:@"留言" forState:UIControlStateNormal];
    btn_liuyan.frame = CGRectMake(25, 20, DEVICE_WIDTH - 50, 50);
    btn_liuyan.layer.cornerRadius = 3.f;
    btn_liuyan.backgroundColor = [UIColor colorWithHexString:@"222222"];
    [view_liuyan addSubview:btn_liuyan];
    
    [btn_liuyan addTarget:self action:@selector(clickToLiuyan:) forControlEvents:UIControlEventTouchUpInside];
    
    return view_liuyan;
}

- (UIView *)createHeaderView
{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    
    //背景图
    UIImageView *image_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 256)];
    image_bg.backgroundColor = [UIColor orangeColor];
    [header addSubview:image_bg];
    
    [image_bg sd_setImageWithURL:[NSURL URLWithString:userModel.backgroundimage] placeholderImage:DEFAULT_CAR_IAMGE];
    
    UIImageView *kuang_view = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 10 - 75, 206, 75, 75)];
    kuang_view.layer.borderWidth = 0.5f;
    kuang_view.layer.borderColor = [UIColor colorWithHexString:@"d9d9d9"].CGColor;
    kuang_view.backgroundColor = [UIColor whiteColor];
    [header addSubview:kuang_view];
                                                                          
    
    //头像
    UIImageView *image_Head = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 75 - 4, 75 - 4)];
    image_Head.layer.borderWidth = 3.f;
    image_Head.layer.borderColor = [UIColor whiteColor].CGColor;
    image_Head.backgroundColor = [UIColor lightGrayColor];
    [kuang_view addSubview:image_Head];
    [image_Head sd_setImageWithURL:[NSURL URLWithString:userModel.headimage] placeholderImage:DEFAULT_HEAD_IMAGE];
    
    header.height = kuang_view.bottom + 10;
    
    //名字
    CGFloat name_width = DEVICE_WIDTH - image_Head.width - 30;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kuang_view.left - 10 - name_width, kuang_view.top, name_width, 20)];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor whiteColor];
    [header addSubview:nameLabel];
    
    nameLabel.text = userModel.name;
    
    //名称
    
    UILabel *areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(kuang_view.left - 10 - name_width, nameLabel.bottom, name_width, 20)];
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.font = [UIFont systemFontOfSize:16];
    areaLabel.textColor = [UIColor whiteColor];
    [header addSubview:areaLabel];
    
    NSString *sheng = [FBCityData cityNameForId:[userModel.province intValue]];
    NSString *shi = [FBCityData cityNameForId:[userModel.city intValue]];
    NSString *area = [NSString stringWithFormat:@"%@%@",sheng,shi];
    areaLabel.text = area;
    
    return header;
    
}

#pragma - mark 网络请求

//获取用户信息
-(void)prepareUeserInfo{
    NSString *api = [NSString stringWithFormat:FBAUTO_GET_USER_INFORMATION_NEW,self.userId,[GMAPI getAuthkey]];
    
    NSLog(@"获取用户信息 api === %@",api);
    
    __weak typeof (self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]] == NO) {
            return ;
        }
        int status = [dataInfo[@"status"] intValue];
        
        NSDictionary *userinfo = dataInfo[@"userinfo"];
        
        GuserModel *guserModel = [[GuserModel alloc]initWithDic:userinfo];
        
        userModel = guserModel;
        
        friend_status = status;
        
        [weakSelf createRightButton];//右上角按钮
        
        titles = @[@"公司",@"地址",@"电话",@"个人简介"];
        
        _table.tableHeaderView = [weakSelf createHeaderView];
        
        [_table reloadData];

        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSString *str = [failDic objectForKey:ERROR_INFO];
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }];
}

//获取用户车源信息
-(void)getCarSourceIsReload:(BOOL)isReload page:(int)page{
    //获取用户车源信息
    NSString *api = [NSString stringWithFormat:FBAUTO_CARSOURCE_MYSELF,self.userId,page,20];
    
    NSLog(@"用户车源信息接口:%@",api);
    
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"用户车源列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];

        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
            
            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
            
            [arr addObject:aCar];
        }
        
        NSLog(@"车源page %d total %d",page_carsource,total_carsource);
        
        page_carsource = page;
        total_carsource = total;
        
        if (isReload) {
            
            [arr_carsource removeAllObjects];
        }
        
        [arr_carsource addObjectsFromArray:arr];
        
        if (isCarsource) {
            
            [_table.dataArray removeAllObjects];
//            [_table reloadData:arr_carsource total:total];
            
            [_table reloadData:arr_carsource haveMore:(page_carsource < total_carsource ? YES : NO)];
        }

        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        int erroCode = [failDic[@"errocode"] intValue];
        
        if (erroCode != 2) { //2 代表数据为空
            
            [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        }
        
        [_table loadFail];
        
    }];
}

/**
 *  获取商家留言
 */
- (void)getLiuyanIsReload:(BOOL)isReload page:(int)page
{
//    getcomment&art_uid=%@&ctype=%d&page=%d&ps=%d
    
    //获取用户车源信息
    NSString *api = [NSString stringWithFormat:FBAUTO_LIUYAN_LIST,self.userId,2,page,20];
    
    NSLog(@"留言接口:%@",api);
    __weak typeof (self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"用户车源列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
            LiuyanModel *aCar = [[LiuyanModel alloc]initWithDictionary:aDic];
            
            [arr addObject:aCar];
        }
        
        NSLog(@"留言page %d total %d",page_liuyan,total_liuyan);
        
        page_liuyan = page;
        total_liuyan = total;
        
        if (isReload) {
            [arr_liuyan removeAllObjects];
        }
        [arr_liuyan addObjectsFromArray:arr];
        
        if (isCarsource == NO) {
            
            [_table.dataArray removeAllObjects];
//            [_table reloadData:arr_liuyan total:total];
            
            [_table reloadData:arr_liuyan haveMore:(page_liuyan < total_liuyan ? YES : NO)];
        }
        
//        rightTable.dataArray = arr;
//        
//        [rightTable reloadData];
        
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [_table loadFail];
        
    }];

}

/**
 *  添加好友
 *
 *  @param isConcern 是否加关注
 */
- (void)addFriend:(NSString *)friendId isConcern:(BOOL)isConcern
{
    NSLog(@"provinceId %@",friendId);
    
    NSString *api;
    
    if (isConcern) {
        api = [NSString stringWithFormat:FBAUTO_ADD_CONCERN,[GMAPI getAuthkey],friendId];
    }else
    {
        api = [NSString stringWithFormat:FBAUTO_FRIEND_ADD,[GMAPI getAuthkey],friendId];
    }
    
    __weak typeof(self)weakSelf = self;
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@ erro %@",result,[result objectForKey:@"errinfo"]);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
//            rightButton2.selected = YES;
            friend_status = isConcern ? 3 : 0;//已是好友0 关注 3
            
            [weakSelf createRightButton];
            
            [LCWTools showMBProgressWithText:[result objectForKey:@"errinfo"] addToView:self.view];
            
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
}

#pragma - mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    if (firstLoadData) {
        
        [self getCarSourceIsReload:YES page:1];
        [self getLiuyanIsReload:YES page:1];
        
        firstLoadData = NO;
        return;
    }
    
    if (isCarsource) {
        
        [self getCarSourceIsReload:YES page:1];
    }else
    {
        [self getLiuyanIsReload:YES page:1];
    }
}
- (void)loadMoreData
{
    if (isCarsource) {
        page_carsource ++;
        [self getCarSourceIsReload:NO page:page_carsource];
    }else
    {
        page_liuyan ++;
        [self getLiuyanIsReload:NO page:page_liuyan];
    }
}
- (void)refreshTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _table) {
        
        
    }else if (tableView == leftTable){
        
        FBDetail2Controller *fbdetailvc = [[FBDetail2Controller alloc]init];
        CarSourceClass *car = leftTable.dataArray[indexPath.row];
        fbdetailvc.infoId = car.id;
        fbdetailvc.isHiddenUeserInfo = YES;
        fbdetailvc.style = Navigation_Special;
        fbdetailvc.navigationTitle = @"详情";
        fbdetailvc.carId = car.car;
        [self.navigationController pushViewController:fbdetailvc animated:YES];
        
    }
}

- (CGFloat)refreshTableView:(UITableView *)tableView heightForRowIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _table) {
        
        if (indexPath.section == 0) {
        
            if (indexPath.row == 3) {
                
                //根据文字变
                NSString *text = userModel.intro;
                CGFloat aHeight = [LCWTools heightForText:text width:DEVICE_WIDTH - 20 font:16];
                
                return 44 + (aHeight + (text.length > 0 ? 18 : 0));
            }
            
            return 44;
        }else if (indexPath.section == 1){
            
            if (isCarsource) {
                
                return 75;
            }
            
            LiuyanModel *aCar = [_table.dataArray objectAtIndex:indexPath.row];
            
            return [LiuyanCell heightWithContent:aCar.content];

//            return DEVICE_HEIGHT - 64 - 44;
        }
    }
    
//    if (tableView == leftTable) {
//        return 75;
//    }
//    
//    if (tableView == rightTable) {
//        
//        LiuyanModel *aCar = [rightTable.dataArray objectAtIndex:indexPath.row];
//        
//        return [LiuyanCell heightWithContent:aCar.content];
//    }
    
    return 44;
}

- (UIView *)refreshTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if (section == 1) {
        
        UIView *section_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
        section_view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        
        NSArray *items_images_normal = @[@"zs_cheyuan_normal",@"x_liuyan_normal"];
        NSArray *items_images_selected = @[@"zs_cheyuan_selected",@"x_liuyan_selected"];
        
        NSArray *items_names = @[@"在售车源",@"留言"];
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:items_names[i] forState:UIControlStateNormal];
            [section_view addSubview:btn];
            btn.frame = CGRectMake(DEVICE_WIDTH/2.f * i, 0, DEVICE_WIDTH/2.f, 41);
            [btn setTitleColor:[UIColor colorWithHexString:@"424242"] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithHexString:@"888888"] forState:UIControlStateNormal];
            
            btn.tag = 70 + i;
            
            [btn setImage:[UIImage imageNamed:items_images_normal[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:items_images_selected[i]] forState:UIControlStateSelected];
            
            [btn addTarget:self action:@selector(clickToSwap:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH/2.f * i, 41, DEVICE_WIDTH/2.f, 3)];
            [section_view addSubview:line];
            
            if (isCarsource) {
                if (i == 0) {
                    line.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
                    line_left = line;
                    btn.selected = YES;
                }else
                {
                    line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
                    line_right = line;
                }
            }else
            {
                if (i == 1) {
                    line.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
                    line_left = line;
                    btn.selected = YES;
                }else
                {
                    line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
                    line_right = line;
                }
            }
            
//            if (i == 0) {
//                line.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
//                line_left = line;
//                btn.selected = YES;
//            }else
//            {
//                line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
//                line_right = line;
//            }
            
        }
        
        return section_view;
    }
    
    return [UIView new];
}

- (CGFloat)refreshTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _table) {
        
        if (section == 0) {
            return 0;
        }else if (section == 1){
            return 44;
        }
    }
    
    return 0;
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView %f",scrollView.contentOffset.y);
//    if (scrollView == leftTable || scrollView == rightTable) {
//        
//        if (scrollView.contentOffset.y <= -50)
//        {
//            
//            // 输出改变后的值
//            [_table setContentOffset:CGPointMake(0,0) animated:YES];
//            
//        }else if(scrollView.contentOffset.y > 50)
//        {
//            [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
//    }

}

- (void)refreshScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

#pragma - mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _table) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _table) {
        
        if (section == 0) {
            
            return titles.count;
        }
        
        return _table.dataArray.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //最外侧tableView
    if (tableView == _table) {
        
        if (indexPath.section == 0) {
            
            static NSString *normal = @"normal";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normal];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
                UILabel *leftLabel = [[UILabel alloc]init];
                leftLabel.textAlignment = NSTextAlignmentLeft;
                leftLabel.font = [UIFont systemFontOfSize:16];
                leftLabel.textColor = [UIColor colorWithHexString:@"383838"];
                [cell.contentView addSubview:leftLabel];
                leftLabel.tag = 100 + indexPath.row;
                
                UILabel *rightLabel = [[UILabel alloc]init];
                rightLabel.font = [UIFont systemFontOfSize:16];
                rightLabel.textColor = [UIColor colorWithHexString:@"888888"];
                [cell.contentView addSubview:rightLabel];
                rightLabel.tag = 1000 + indexPath.row;
                
                rightLabel.lineBreakMode = NSLineBreakByCharWrapping;
                rightLabel.numberOfLines = 0;
            }
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0.5)];
            line.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
            [cell.contentView addSubview:line];
            
            UILabel *label = (UILabel *)[cell viewWithTag:100 + indexPath.row];
            label.frame = CGRectMake(10, 0, 70, 44);
            label.text = titles[indexPath.row];
            
            UILabel *label2 = (UILabel *)[cell viewWithTag:1000 + indexPath.row];
            
            if (indexPath.row == 3) {
                
                label2.frame = CGRectMake(10, label.bottom, DEVICE_WIDTH - 20, 44);
                
                label2.backgroundColor = [UIColor whiteColor];
                //根据文字变
                NSString *text = userModel.intro;
                
                label2.height = [LCWTools heightForText:text width:DEVICE_WIDTH - 20 font:16];
                
                label2.text = text;
                
                label2.textAlignment = NSTextAlignmentLeft;

            }else
            {
                CGFloat aWidth = DEVICE_WIDTH - label.right - 10 - 10;
                label2.frame = CGRectMake(DEVICE_WIDTH - 10 - aWidth, 0,aWidth, 44);
                
                if (indexPath.row == 0) {
                    label2.text = userModel.fullname;
                }else if (indexPath.row == 1){
                    label2.text = userModel.address;
                }else if (indexPath.row == 2){
                    label2.text = userModel.phone;
                }
                
                label2.textAlignment = NSTextAlignmentRight;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }else if (indexPath.section == 1){
            
            return [self cellForTableView:tableView indexPath:indexPath IsCarSource:isCarsource];
            
        }
        
    }
    
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


#pragma - mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}


@end

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
}

@end

@implementation UserHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    scroll_bg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    scroll_bg.delegate = self;
//    [self.view addSubview:scroll_bg];
    
    self.titleLabel.text = self.title;
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64) showLoadMore:NO];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLiuyan:) name:NOTIFICATION_PUBLISH_LIYYAN_SUCCESS object:nil];
    
    //搜索遮罩
//    [_table showRefreshHeader:YES];
    
    [self prepareUeserInfo];//用户信息
    
    [self prepareUserCarSource];//车源
    
    [self getLiuyan];//留言
    
    [self liuyan];//留言view
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 事件处理
/**
 *  刷新留言列表
 */
- (void)refreshLiuyan:(NSNotification *)notification
{
    [self getLiuyan];
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
    
    if (sender.tag == 70) {
        
        //left
        
        line_left.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
        line_right.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        [self buttonForTag:71].selected = NO;
        
        leftTable.hidden = NO;
        rightTable.hidden = YES;
        
//        view_liuyan.hidden = YES;
        
    }else if (sender.tag == 71){
        //right
        
        line_right.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
        line_left.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        [self buttonForTag:70].selected = NO;
        
        rightTable.hidden = NO;
        leftTable.hidden = YES;
        
//        view_liuyan.hidden = NO;
    }
}

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self.view viewWithTag:tag];
}


#pragma - mark 创建视图

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
        
        _table.tableHeaderView = [self createHeaderView];
        
        [_table reloadData];

        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSString *str = [failDic objectForKey:ERROR_INFO];
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }];
}

//获取用户车源信息
-(void)prepareUserCarSource{
    //获取用户车源信息
    NSString *api = [NSString stringWithFormat:FBAUTO_CARSOURCE_MYSELF,self.userId,1,10000];
    
    NSLog(@"用户车源信息接口:%@",api);
    __weak typeof (self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"用户车源列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
//        if (_page < total) {
//            
//            _tableView.isHaveMoreData = YES;
//        }else
//        {
//            _tableView.isHaveMoreData = NO;
//        }
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
            
            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
            
            [arr addObject:aCar];
        }
        

        [leftTable.dataArray addObjectsFromArray:arr];
        
        [leftTable reloadData];
        
//        [leftTable reloadData];
//        [weakSelf reloadData:arr isReload:_tableView.isReloadData];
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        int erroCode = [failDic[@"errocode"] intValue];
        
        if (erroCode != 2) { //2 代表数据为空
            
            [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        }
        
        
//        if (_tableView.isReloadData) {
//            
//            _page --;
//            
//            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
//        }
        
    }];
}

/**
 *  获取商家留言
 */
- (void)getLiuyan
{
//    getcomment&art_uid=%@&ctype=%d&page=%d&ps=%d
    
    //获取用户车源信息
    NSString *api = [NSString stringWithFormat:FBAUTO_LIUYAN_LIST,self.userId,2,1,10000];
    
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
        
        
        rightTable.dataArray = arr;
        
        [rightTable reloadData];
        
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
    }];

}

/**
 *  添加好友
 *
 *  @param friendId userId
 */
- (void)addFriend:(NSString *)friendId
{
    NSLog(@"provinceId %@",friendId);
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_ADD,[GMAPI getAuthkey],friendId]isPost:NO postData:nil];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@ erro %@",result,[result objectForKey:@"errinfo"]);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            //            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
//            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:erroInfo contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定" isInput:NO];
//            [alert show];
//            
//            alert.leftBlock = ^(){
//                NSLog(@"确定");
//            };
//            alert.rightBlock = ^(){
//                NSLog(@"取消");
//                
//            };
            
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        //        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
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
    
}
- (void)loadMoreData
{
    
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
            
            return DEVICE_HEIGHT - 64 - 44;
        }
    }
    
    if (tableView == leftTable) {
        return 75;
    }
    
    if (tableView == rightTable) {
        
        LiuyanModel *aCar = [rightTable.dataArray objectAtIndex:indexPath.row];
        
        return [LiuyanCell heightWithContent:aCar.content];
    }
    
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
            
            if (i == 0) {
                line.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
                line_left = line;
                btn.selected = YES;
            }else
            {
                line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
                line_right = line;
            }
            
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
    if (scrollView == leftTable || scrollView == rightTable) {
        
        if (scrollView.contentOffset.y <= -50)
        {
            
            // 输出改变后的值
            [_table setContentOffset:CGPointMake(0,0) animated:YES];
            
        }else if(scrollView.contentOffset.y > 50)
        {
            [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }

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
            return 4;
        }
        
        return 1;
    }
    
    if (tableView == leftTable) {
        
        return leftTable.dataArray.count;
    }
    
    if (tableView == rightTable) {
        
        return rightTable.dataArray.count;
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
            
            NSArray *titles = @[@"公司",@"地址",@"电话",@"个人简介"];
            
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
            
            static NSString * identifier = @"sourceCell";
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                rightTable = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64 - 44) headerShow:NO footerShow:NO];
                
                leftTable = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64 - 44) headerShow:NO footerShow:NO];
            }
            
            rightTable.dataSource = self;
            rightTable.refreshDelegate = self;
            rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            [cell.contentView addSubview:rightTable];
            
            rightTable.tableFooterView = [self liuyan];
            
            leftTable.dataSource = self;
            leftTable.refreshDelegate = self;
            leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:leftTable];
            
            return cell;
            
        }
        
    }
    
    if (tableView == leftTable) {
        
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
        
        CarSourceClass *aCar = [leftTable.dataArray objectAtIndex:indexPath.row];
        [cell setCellDataWithModel:aCar];
        
        return cell;

    }
    
    if (tableView == rightTable) {
        
        static NSString * identifier = @"LiuyanCell";
        
        LiuyanCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LiuyanCell" owner:self options:nil]objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        LiuyanModel *aCar = [rightTable.dataArray objectAtIndex:indexPath.row];
        [cell setCellWithModel:aCar];
        
        return cell;
        
    }
    
//    if (tableView == leftTable) {
    
        static NSString * identifier = @"leftCell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        
        return cell;
//    }
    
    
    
}


#pragma - mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}


@end

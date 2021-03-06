//
//  RefreshTableView.h
//  TuanProject
//
//  Created by 李朝伟 on 13-9-6.
//  Copyright (c) 2013年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@class HelperConnection;

@protocol RefreshDelegate <NSObject>

@optional

- (void)loadNewData;
- (void)loadMoreData;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)refreshTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)refreshTableView:(UITableView *)tableView heightForRowIndexPath:(NSIndexPath *)indexPath;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (UIView *)refreshTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)refreshTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (void)refreshScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface RefreshTableView : UITableView<EGORefreshTableDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,retain)EGORefreshTableHeaderView * refreshHeaderView;

@property (nonatomic,assign)id<RefreshDelegate>refreshDelegate;
@property (nonatomic,assign)BOOL                        isReloadData;      //是否是下拉刷新数据
@property (nonatomic,assign)BOOL                        reloading;         //是否正在loading
@property (nonatomic,assign)BOOL                        isLoadMoreData;    //是否是载入更多
@property (nonatomic,assign)BOOL                        isHaveMoreData;    //是否还有更多数据,决定是否有更多view

@property (nonatomic,assign)BOOL showMore;//是否显示更多加载view

@property(nonatomic,retain)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)UILabel *normalLabel;
@property(nonatomic,retain)UILabel *loadingLabel;

@property (nonatomic,assign)int pageNum;//页数
@property (nonatomic,retain)NSMutableArray *dataArray;//数据源

-(id)initWithFrame:(CGRect)frame showLoadMore:(BOOL)show;//是否需要显示加载更多
-(id)initWithFrame:(CGRect)frame headerShow:(BOOL)headerShow footerShow:(BOOL)footerShow;//可选显示下拉或者上拉view

-(id)initWithFrame:(CGRect)frame needShowLoadMore:(BOOL)show;//刚开始不显示更多加载view,请求过数据之后再显示

-(void)createHeaderView;
-(void)removeHeaderView;

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos;
-(void)showRefreshHeader:(BOOL)animated;//代码出发刷新
- (void)finishReloadigData;

- (void)reloadData:(NSArray *)data total:(int)totalPage;//更新数据
- (void)reloadData:(NSArray *)data haveMore:(BOOL)haveMore;//更新数据,是否有更多

- (void)loadFail;//请求数据失败

@end

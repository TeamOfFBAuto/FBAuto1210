//
//  TucaoDetailController.h
//  FBAuto
//
//  Created by lichaowei on 14/12/30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"
#import "TucaoModel.h"

/**
 *  吐槽详情
 */
@interface TucaoDetailController : FBBaseViewController

@property(nonatomic,retain)TucaoModel *tucaoModel;

@property(nonatomic,assign)UILabel *likeLabel;
@property(nonatomic,assign)UILabel *commentLabe;
@property(nonatomic,assign)UIButton *zanButton;

@end

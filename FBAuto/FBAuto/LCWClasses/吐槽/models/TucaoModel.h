//
//  TucaoModel.h
//  FBAuto
//
//  Created by lichaowei on 14/12/26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "BaseModel.h"

@interface TucaoModel : BaseModel

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *pid;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *color;
@property(nonatomic,retain)NSString *zan_num;
@property(nonatomic,retain)NSString *comemt_num;
@property(nonatomic,retain)NSString *isdel;
@property(nonatomic,retain)NSString *dateline;
@property(nonatomic,retain)NSString *uptime;
@property(nonatomic,retain)NSArray *image;//图片数组

@property(nonatomic,assign)int dianzan_status;//点赞状态


@end

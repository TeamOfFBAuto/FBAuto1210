//
//  PeizhiModel.h
//  FBAuto
//
//  Created by lichaowei on 15/1/20.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "BaseModel.h"
/**
 *  配置
 */
@interface PeizhiModel : BaseModel

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *pid;
@property(nonatomic,retain)NSString *nodename;
@property(nonatomic,retain)NSString *dateline;
@property(nonatomic,retain)NSString *uptime;
@property(nonatomic,retain)NSString *isdel;

@end

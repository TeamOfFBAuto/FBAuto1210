//
//  TucaoModel.h
//  FBAuto
//
//  Created by lichaowei on 14/12/26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "BaseModel.h"

/**
 *  吐槽内容 和 吐槽评论 对应model
 */
@interface TucaoModel : BaseModel

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *pid;
@property(nonatomic,retain)NSString *content;//对应吐槽内容  或者 是评论内容
@property(nonatomic,retain)NSString *color;
@property(nonatomic,retain)NSString *zan_num;
@property(nonatomic,retain)NSString *comemt_num;
@property(nonatomic,retain)NSString *isdel;
@property(nonatomic,retain)NSString *dateline;
@property(nonatomic,retain)NSString *uptime;
@property(nonatomic,retain)NSArray *image;//图片数组

@property(nonatomic,retain)NSDictionary *data;//存图片的一个数组

@property(nonatomic,retain)NSString *neirong;

@property(nonatomic,assign)int dianzan_status;//点赞状态

//评论特有
@property(nonatomic,retain)NSString *art_uid;//对应的吐槽信息id
@property(nonatomic,retain)NSString *ctype;//评论类型

@end

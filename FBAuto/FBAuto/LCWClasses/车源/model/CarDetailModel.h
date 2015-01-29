//
//  CarDetailModel.h
//  FBAuto
//
//  Created by lichaowei on 15/1/29.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "BaseModel.h"
/**
 *  车源详情model
 */
@interface CarDetailModel : BaseModel

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *usertype;
@property(nonatomic,retain)NSString *car;
@property(nonatomic,retain)NSString *car_name;
@property(nonatomic,retain)NSString *province;
@property(nonatomic,retain)NSString *city;
@property(nonatomic,retain)NSString *spot_future;
@property(nonatomic,retain)NSString *color_out;
@property(nonatomic,retain)NSString *color_out_z;
@property(nonatomic,retain)NSString *color_in;
@property(nonatomic,retain)NSString *color_in_z;
@property(nonatomic,retain)NSString *carfrom;
@property(nonatomic,retain)NSString *photo;
@property(nonatomic,retain)NSString *peizhi;
@property(nonatomic,retain)NSString *custom_peizhi;
@property(nonatomic,retain)NSString *build_time;
@property(nonatomic,retain)NSString *isdel;
@property(nonatomic,retain)NSString *pub_time;
@property(nonatomic,retain)NSString *uptime;
@property(nonatomic,retain)NSString *dateline;
@property(nonatomic,retain)NSString *is_shoucang;
@property(nonatomic,retain)NSString *phone;
@property(nonatomic,retain)NSString *headimage;
@property(nonatomic,retain)NSString *cardiscrib;
@property(nonatomic,retain)NSArray *image;
@property(nonatomic,retain)NSArray *peizhi_info;


@end

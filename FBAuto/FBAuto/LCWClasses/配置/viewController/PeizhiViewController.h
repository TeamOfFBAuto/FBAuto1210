//
//  PeizhiViewController.h
//  FBAuto
//
//  Created by lichaowei on 15/1/20.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "FBBaseViewController.h"
/**
 *  车源配置选择页
 */
typedef void(^PeizhiBlock)(NSString *ids_string,NSString *customString);
@interface PeizhiViewController : FBBaseViewController
{
    PeizhiBlock peizhiBlock;
}
@property(nonatomic,retain)UILabel *aLabel;
@property(nonatomic,retain)NSString *idstring;//选择id string

- (void)setPeizhiBlcock:(PeizhiBlock)aBlock;

@end

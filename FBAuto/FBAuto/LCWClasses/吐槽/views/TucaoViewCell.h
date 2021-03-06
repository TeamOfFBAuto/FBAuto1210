//
//  TucaoViewCell.h
//  FBAuto
//
//  Created by lichaowei on 14/12/25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridView;
@interface TucaoViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLine;
@property (strong, nonatomic) IBOutlet UIImageView *centerImageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;//赞
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;//评论
@property (strong, nonatomic) IBOutlet UILabel *commentLable;
@property (strong, nonatomic) IBOutlet UIView *lineOne;
@property (strong, nonatomic) IBOutlet UIView *lineTwo;
@property (strong, nonatomic) IBOutlet UIView *toolsView;//底部工具 背景view

@property (strong, nonatomic) IBOutlet GridView *gridView;//图片九宫格

- (void)setCellWithModel:(id)aModel;

+ (CGFloat)heightForCellWithModel:(id)aModel;

@end

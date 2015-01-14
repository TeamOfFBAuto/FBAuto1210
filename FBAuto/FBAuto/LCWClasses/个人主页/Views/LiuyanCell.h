//
//  LiuyanCell.h
//  FBAuto
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiuyanModel.h"
@interface LiuyanCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *contenLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;

- (void)setCellWithModel:(LiuyanModel *)aModel;

+ (CGFloat)heightWithContent:(NSString *)content;

@end

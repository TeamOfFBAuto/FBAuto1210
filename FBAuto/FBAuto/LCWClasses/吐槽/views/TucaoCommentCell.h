//
//  TucaoCommentCell.h
//  FBAuto
//
//  Created by lichaowei on 15/1/5.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TucaoCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;

- (void)setCellWithModel:(id)aModel;

@end

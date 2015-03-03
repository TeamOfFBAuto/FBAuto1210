//
//  TucaoCellSmall.h
//  FBAuto
//
//  Created by lichaowei on 15/3/3.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TucaoCellSmall : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *cotentLabel;

- (void)setCellWithModel:(id)aModel;

@end

//
//  LiuyanCell.m
//  FBAuto
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "LiuyanCell.h"

@implementation LiuyanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(LiuyanModel *)aModel
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:aModel.head_image] placeholderImage:DEFAULT_HEAD_IMAGE];
    self.nameLabel.text = aModel.username;
    self.contenLabel.text = aModel.content;
    
    CGFloat aWidth = DEVICE_WIDTH - (320 - 236);
    CGFloat aHeight = [LCWTools heightForText:aModel.content width:aWidth font:15];
    self.contenLabel.height = aHeight;
    
//    self.bottomLine.top = [LiuyanCell heightWithContent:aModel.content] - 0.5f;
}

+ (CGFloat)heightWithContent:(NSString *)content
{
    CGFloat aWidth = DEVICE_WIDTH - (320 - 236);
    CGFloat aHeight = [LCWTools heightForText:content width:aWidth font:15];
    if (aHeight <= 15) {
        
        return 75;
    }
    return 75 + aHeight - 15;
}

@end

//
//  TucaoCommentCell.m
//  FBAuto
//
//  Created by lichaowei on 15/1/5.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "TucaoCommentCell.h"
#import "TucaoModel.h"

@implementation TucaoCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(TucaoModel *)aModel
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[LCWTools headImageForUserId:aModel.uid]] placeholderImage:DEFAULT_HEAD_IMAGE];
    self.userNameLabel.text = aModel.username;
    self.commentLabel.text = aModel.content;
    
    self.commentLabel.height = [LCWTools heightForText:aModel.content width:_commentLabel.width font:15];
    NSLog(@"-->%f",self.commentLabel.height);
}

@end

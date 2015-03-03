//
//  TucaoCellSmall.m
//  FBAuto
//
//  Created by lichaowei on 15/3/3.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "TucaoCellSmall.h"
#import "TucaoModel.h"

@implementation TucaoCellSmall

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(TucaoModel *)aModel
{
    self.timeLabel.text = [LCWTools timechange:aModel.dateline withFormat:@"YYYY-MM-dd"];
    
    self.iconImageView.backgroundColor = [ColorModel colorForTucao:[aModel.color intValue]];
    
    NSString *imageUrl = aModel.image_tub[0][@"link"];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    
    if (aModel.content.length > 0) {
        
        self.cotentLabel.text = aModel.content;

    }else
    {
        self.cotentLabel.text = @"点击查看";
    }
}

@end

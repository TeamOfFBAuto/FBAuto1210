//
//  TucaoViewCell.m
//  FBAuto
//
//  Created by lichaowei on 14/12/25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "TucaoViewCell.h"
#import "TucaoModel.h"

@implementation TucaoViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//判断是否有图
- (BOOL)haveImage:(NSArray *)imageArr
{
    if (imageArr.count > 0 && ((NSString *)imageArr[0][@"link"]).length > 0 && ![(NSString *)imageArr[0][@"imgid"]isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
}

//判断是否有图
+ (BOOL)haveImage:(NSArray *)imageArr
{
    if (imageArr.count > 0 && ((NSString *)imageArr[0][@"link"]).length > 0 && ![(NSString *)imageArr[0][@"imgid"]isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
}

-(void)setCellWithModel:(TucaoModel *)aModel
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[LCWTools headImageForUserId:aModel.uid]] placeholderImage:DEFAULT_HEAD_IMAGE];
    self.nameLabel.text = aModel.username;
    self.dateLine.text = [LCWTools timestamp:aModel.dateline];
    
    self.centerImageView.backgroundColor = [ColorModel colorForTucao:[aModel.color intValue]];
    self.centerImageView.height = DEVICE_WIDTH - 20;
    
//    self.contentLabel.backgroundColor = [UIColor orangeColor];
    
    if ([self haveImage:aModel.image_ori]) {
        
        NSString *imageUrl = aModel.image_ori[0][@"link"];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        
        //内容描述 图片底部
        
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.top = self.centerImageView.bottom + 5;
        self.contentLabel.width = DEVICE_WIDTH - 20;
        _contentLabel.height = [LCWTools heightForText:aModel.content width:DEVICE_WIDTH - 20 font:17];
        
        self.contentLabel.width = self.centerImageView.width;
        
    }else
    {
        [self.centerImageView sd_setImageWithURL:nil placeholderImage:nil];
        
        //内容描述 中间
        
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.width = DEVICE_WIDTH - 120;
        self.contentLabel.height = [LCWTools heightForText:aModel.content width:DEVICE_WIDTH - 120 font:17];
        self.contentLabel.center = _centerImageView.center;
    }
    
    //有图片但是没有文字
    if ([self haveImage:aModel.image_ori] && aModel.content.length > 0 ) {
        
        self.toolsView.top = self.contentLabel.bottom + 5;
        
        self.lineOne.hidden = NO;
        
    }else
    {
        self.toolsView.top = self.centerImageView.bottom + 5;
        
        self.lineOne.hidden = YES;
    }
    //imageview 325
    // 325 + 5 + 38
    // 325 + 5 + 38 + aheight + 5
    self.contentLabel.text = aModel.content;
    self.likeLabel.text = aModel.zan_num;
    self.commentLable.text = aModel.comemt_num;
    
    self.likeButton.selected = aModel.dianzan_status == 1 ? YES : NO;

}

+ (CGFloat)heightForCellWithModel:(TucaoModel *)aModel
{
    CGFloat aHeight = 0.f;
    
    CGFloat content_width = DEVICE_WIDTH - 120;
    
    if ([TucaoViewCell haveImage:aModel.image_ori]) {
        
        content_width = DEVICE_WIDTH - 20;
    }
    
    //有图片但是没有文字
    if ([TucaoViewCell haveImage:aModel.image_ori] && aModel.content.length > 0 ) {
        
        
        aHeight = DEVICE_WIDTH - 20 + 25 + 5 + 38 + [LCWTools heightForText:aModel.content width:content_width font:17] + 5 + 40;

//        aHeight = 325 + 5 + 38 + [LCWTools heightForText:aModel.content width:content_width font:17] + 5;
        
    }else
    {
//        aHeight = 325 + 5 + 38;
        
        aHeight = DEVICE_WIDTH - 20 + 25 + 5 + 38 + 40;

    }
    
    return aHeight;
}

@end

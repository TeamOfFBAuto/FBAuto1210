//
//  TucaoViewCell.m
//  FBAuto
//
//  Created by lichaowei on 14/12/25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "TucaoViewCell.h"
#import "TucaoModel.h"
#import "GridView.h"

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
    //个人信息、发布时间
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[LCWTools headImageForUserId:aModel.uid]] placeholderImage:DEFAULT_HEAD_IMAGE];
    self.nameLabel.text = aModel.username;
    self.dateLine.text = [LCWTools timestamp:aModel.dateline];
    
    //文字描述
    self.contentLabel.text = aModel.content;
    
    CGFloat content_height = [LCWTools heightForText:aModel.content width:DEVICE_WIDTH - 20 font:17];
    
    if (aModel.content.length > 0) {
        
        _contentLabel.height = content_height;
    }else
    {
        _contentLabel.height = 0.f;
    }

    CGFloat aTop = _contentLabel.bottom + 5;
    
    //图片
    
    if (self.gridView) {
        
        [self.gridView removeFromSuperview];
        self.gridView = nil;
    }
    
    self.gridView = [[GridView alloc]initWithFrame:CGRectMake(0, aTop, DEVICE_WIDTH, 0) imageUrls:aModel.image_tub];
    [self addSubview:_gridView];
    
    //底部工具条
    
    self.toolsView.top = _gridView.bottom + 5;
    
    self.likeLabel.text = aModel.zan_num;
    self.commentLable.text = aModel.comemt_num;
    
    self.likeButton.selected = aModel.dianzan_status == 1 ? YES : NO;
    
}

+ (CGFloat)heightForCellWithModel:(TucaoModel *)aModel
{
    //文字描述以上高度
    CGFloat aHeight = 62.f;
    
    //内容高度
    CGFloat contentHeight = [LCWTools heightForText:aModel.content width:DEVICE_WIDTH - 20 font:17];
    
    if (!aModel.content.length > 0)
    {
        contentHeight = 0.f;
    }
    
    CGFloat aTop = 0.f;
    
    //图片高度
    CGFloat aWidth = (DEVICE_WIDTH - 40) / 3;//每张图片大小
    CGFloat imageHeight = 0.f;
    
    int sum = aModel.image_tub.count;
    if (sum == 1) {
        
        imageHeight =  aWidth * 2 + 10;
        
    }else if (sum > 1){
        
        int line_num = (sum - 1) / 3 + 1;//总行数
        
        imageHeight = aWidth * line_num + 5 * (line_num - 1);
    }
    
    aHeight += contentHeight;
    aHeight += aTop;
    aHeight += imageHeight;
    aHeight += 38;
    
    return aHeight + 5;
}


//-(void)setCellWithModel:(TucaoModel *)aModel
//{
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[LCWTools headImageForUserId:aModel.uid]] placeholderImage:DEFAULT_HEAD_IMAGE];
//    self.nameLabel.text = aModel.username;
//    self.dateLine.text = [LCWTools timestamp:aModel.dateline];
//    
//    self.centerImageView.backgroundColor = [ColorModel colorForTucao:[aModel.color intValue]];
//    self.centerImageView.height = DEVICE_WIDTH - 20;
//    
////    self.contentLabel.backgroundColor = [UIColor orangeColor];
//    
//    if ([self haveImage:aModel.image_ori]) {
//        
//        NSString *imageUrl = aModel.image_ori[0][@"link"];
//        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
//        
//        //内容描述 图片底部
//        
//        _contentLabel.textAlignment = NSTextAlignmentLeft;
//        self.contentLabel.top = self.centerImageView.bottom + 5;
//        self.contentLabel.width = DEVICE_WIDTH - 20;
//        _contentLabel.height = [LCWTools heightForText:aModel.content width:DEVICE_WIDTH - 20 font:17];
//        
//        self.contentLabel.width = self.centerImageView.width;
//        
//    }else
//    {
//        [self.centerImageView sd_setImageWithURL:nil placeholderImage:nil];
//        
//        //内容描述 中间
//        
//        _contentLabel.textAlignment = NSTextAlignmentCenter;
//        self.contentLabel.width = DEVICE_WIDTH - 120;
//        self.contentLabel.height = [LCWTools heightForText:aModel.content width:DEVICE_WIDTH - 120 font:17];
//        self.contentLabel.center = _centerImageView.center;
//    }
//    
//    //有图片但是没有文字
//    if ([self haveImage:aModel.image_ori] && aModel.content.length > 0 ) {
//        
//        self.toolsView.top = self.contentLabel.bottom + 5;
//        
//        self.lineOne.hidden = NO;
//        
//    }else
//    {
//        self.toolsView.top = self.centerImageView.bottom + 5;
//        
//        self.lineOne.hidden = YES;
//    }
//    //imageview 325
//    // 325 + 5 + 38
//    // 325 + 5 + 38 + aheight + 5
//    self.contentLabel.text = aModel.content;
//    self.likeLabel.text = aModel.zan_num;
//    self.commentLable.text = aModel.comemt_num;
//    
//    self.likeButton.selected = aModel.dianzan_status == 1 ? YES : NO;
//
//}
//
//+ (CGFloat)heightForCellWithModel:(TucaoModel *)aModel
//{
//    CGFloat aHeight = 0.f;
//    
//    CGFloat content_width = DEVICE_WIDTH - 120;
//    
//    if ([TucaoViewCell haveImage:aModel.image_ori]) {
//        
//        content_width = DEVICE_WIDTH - 20;
//    }
//    
//    //有图片但是没有文字
//    if ([TucaoViewCell haveImage:aModel.image_ori] && aModel.content.length > 0 ) {
//        
//        
//        aHeight = DEVICE_WIDTH - 20 + 25 + 5 + 38 + [LCWTools heightForText:aModel.content width:content_width font:17] + 5 + 40;
//
////        aHeight = 325 + 5 + 38 + [LCWTools heightForText:aModel.content width:content_width font:17] + 5;
//        
//    }else
//    {
////        aHeight = 325 + 5 + 38;
//        
//        aHeight = DEVICE_WIDTH - 20 + 25 + 5 + 38 + 40;
//
//    }
//    
//    return aHeight;
//}

@end

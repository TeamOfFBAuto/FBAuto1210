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
    if (imageArr.count > 0 && ((NSString *)imageArr[0][@"link"]).length > 0) {
        return YES;
    }
    
    return NO;
}

-(void)setCellWithModel:(TucaoModel *)aModel
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[LCWTools headImageForUserId:aModel.uid]] placeholderImage:DEFAULT_HEAD_IMAGE];
    self.nameLabel.text = aModel.username;
    self.dateLine.text = [LCWTools timestamp:aModel.dateline];
    
    self.centerImageView.backgroundColor = [LCWTools colorForColorId:[aModel.color intValue]];
    
    if ([self haveImage:aModel.image]) {
        
        NSString *imageUrl = aModel.image[0][@"link"];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        
        //内容描述 图片底部
        
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.top = self.centerImageView.bottom + 5;
        self.contentLabel.width = _centerImageView.width;
        _contentLabel.height = [LCWTools heightForText:aModel.content width:_centerImageView.width font:17];
        
    }else
    {
        [self.centerImageView sd_setImageWithURL:nil placeholderImage:nil];
        
        //内容描述 中间
        
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.width = 200;
        self.contentLabel.height = [LCWTools heightForText:aModel.content width:200 font:17];
        self.contentLabel.center = _centerImageView.center;
    }
    self.contentLabel.text = aModel.content;
    self.likeLabel.text = aModel.zan_num;
    self.commentLable.text = aModel.comemt_num;
//    
//    @property (strong, nonatomic) IBOutlet UIButton *likeButton;
//    @property (strong, nonatomic) IBOutlet UILabel *likeLabel;
//    @property (strong, nonatomic) IBOutlet UIButton *commentButton;
//    @property (strong, nonatomic) IBOutlet UILabel *commentLable;
}

@end

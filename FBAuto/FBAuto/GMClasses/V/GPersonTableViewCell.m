//
//  GPersonTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GPersonTableViewCell.h"

@implementation GPersonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}


//block的set方法
-(void)setKuangBlock:(kuangBlock)kuangBlock{
    _kuangBlock = kuangBlock;
}




//加载控件
-(void)loadViewWithIndexPath:(NSIndexPath *)theIndexPatch{
    viewTag++;
    
    //背景框
    self.kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH - 20, 44)];
    self.kuang.layer.borderWidth = 0.5;
    self.kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
    [self.contentView addSubview:self.kuang];
    //设置背景框的tag值
    if (theIndexPatch.section == 0) {
        self.kuang.tag = theIndexPatch.row+1;//1 2 3 4
    }else if (theIndexPatch.section == 1){
        self.kuang.tag = theIndexPatch.row + 5;//5 6 7 8
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gdoTap:)];
    [self.kuang addGestureRecognizer:tap];
    
    //图标
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    _iconImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_iconImageView];
    
    //标题lable
    self.titileLabel= [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.right, 14, 60, 17)];
//    _titileLabel.backgroundColor = [UIColor redColor];
    self.titileLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titileLabel];
    
    //箭头
    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 20 - 8, 18, 5, 9)];
    [jiantou setImage:[UIImage imageNamed:@"jiantou_hui10_18.png"]];
    [self.contentView addSubview:jiantou];
}


//给标题赋值
-(void)dataWithTitleLableWithIndexPath:(NSIndexPath *)theIndexPatch{
    
    if (theIndexPatch.row == 0 && theIndexPatch.section == 0) {
        self.titileLabel.text = @"我的资料";
        self.iconImageView.image = [UIImage imageNamed:@"ziliao46_46"];
        
    }else if (theIndexPatch.row == 1 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的车源";
        self.iconImageView.image = [UIImage imageNamed:@"cheyuan46_46"];
    }else if (theIndexPatch.row == 2 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的求购";
        self.iconImageView.image = [UIImage imageNamed:@"xunche46_46"];
    }else if (theIndexPatch.row == 3 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的收藏";
        self.iconImageView.image = [UIImage imageNamed:@"shoucang46_46"];
    }
    
    else if (theIndexPatch.row == 0 && theIndexPatch.section == 1){
        self.titileLabel.text = @"修改密码";
        self.iconImageView.image = [UIImage imageNamed:@"gaimi46_46"];
    }else if (theIndexPatch.row == 1 && theIndexPatch.section == 1){
        self.titileLabel.text = @"版本检查";
        self.iconImageView.image = [UIImage imageNamed:@"gengxin_46"];
    }else if (theIndexPatch.row == 2 && theIndexPatch.section == 1){
        self.titileLabel.text = @"联系我们";
        self.iconImageView.image = [UIImage imageNamed:@"lianxi46_46"];
    }else if (theIndexPatch.row == 3 && theIndexPatch.section == 1){
        self.titileLabel.text = @"消息设置";
        self.iconImageView.image = [UIImage imageNamed:@"xiaoshe46_46"];
    }else if (theIndexPatch.row == 4 && theIndexPatch.section == 1){
        self.titileLabel.text = @"退出登录";
        self.iconImageView.image = [UIImage imageNamed:@"ziliao46_46"];
    }
    
}






-(void)gdoTap:(UITapGestureRecognizer *)sender{
    
    if (self.kuangBlock) {
        self.kuangBlock(sender.view.tag);
    }
}



- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

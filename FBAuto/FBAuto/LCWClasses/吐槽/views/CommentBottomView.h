//
//  CommentBottomView.h
//  CustomNewProject
//
//  Created by soulnear on 14-12-15.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//
/*
 *评论视图
 */

#import <UIKit/UIKit.h>
typedef enum
{
    CommentTypeLogIn = 0,
    CommentTypeComent
}CommentTapType;

typedef void(^CommentBottomViewBlock)(CommentTapType aType);

@interface CommentBottomView : UIView
{
    CommentBottomViewBlock comment_bottom_block;
    ///头像
    UIImageView * headerImageView;
}


-(void)setMyBlock:(CommentBottomViewBlock)aBlock;


@end

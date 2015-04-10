//
//  GridView.h
//  FBAuto
//
//  Created by lichaowei on 15/4/10.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  放 图片 九宫格
 */

typedef void(^ClickImageBlock)(int imageIndex,NSArray *images);

@interface GridView : UIView
{
    NSArray *_images;
    
    ClickImageBlock _aBlock;
}

-(instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls;

@property(nonatomic,assign)ClickImageBlock clickBlock;

@end

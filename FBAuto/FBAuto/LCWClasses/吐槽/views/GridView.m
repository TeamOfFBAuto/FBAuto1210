//
//  GridView.m
//  FBAuto
//
//  Created by lichaowei on 15/4/10.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "GridView.h"

@implementation GridView

-(instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _images = imageUrls;
        
        CGFloat aWidth = (frame.size.width - 40) / 3;
        if (imageUrls.count == 1) {
            
            //一张图片得时候 为四个小图大小
            
            UIImageView *aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, aWidth * 2 + 10, aWidth * 2 + 10)];
            [aImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrls[0] objectForKey:@"link"]] placeholderImage:[UIImage imageNamed:@"detail_test.jpg"]];
            [self addSubview:aImageView];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = aImageView.frame;
            btn.tag = 100;
            [self addSubview:btn];
            [btn addTarget:self action:@selector(clickImageIndex:) forControlEvents:UIControlEventTouchUpInside];
            
            self.height = aImageView.bottom;
            
        }else if (imageUrls.count > 1){
            
            for (int i = 0 ; i < imageUrls.count; i ++) {
                
                int x = 10 + (aWidth + 10 ) * (i % 3);
                int y = (aWidth + 5) * (i / 3);
                
                UIImageView *aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, aWidth, aWidth)];
                
                NSDictionary *imageDic = [imageUrls objectAtIndex:i];
                NSString *imageUrl;
                if (imageDic) {
                    imageUrl = [imageDic objectForKey:@"link"];
                }
                
                [aImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"detail_test.jpg"]];
                [self addSubview:aImageView];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = aImageView.frame;
                btn.tag = 100 + i;
                [self addSubview:btn];
                [btn addTarget:self action:@selector(clickImageIndex:) forControlEvents:UIControlEventTouchUpInside];
                
                self.height = aImageView.bottom;
            }
        }
        
    }
    return self;
}

-(void)setClickBlock:(ClickImageBlock)clickBlock
{
    _aBlock = clickBlock;
}

- (void)clickImageIndex:(UIButton *)button
{
    _aBlock(button.tag - 100,_images);
}

@end

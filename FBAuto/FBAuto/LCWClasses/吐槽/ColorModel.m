//
//  ColorModel.m
//  FBAuto
//
//  Created by lichaowei on 15/1/8.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "ColorModel.h"

@implementation ColorModel


+ (UIColor *)colorForTucao:(int)colorid
{
    switch (colorid) {
        case 1:
        {
            return [UIColor colorWithHexString:@"19bd9b"];//绿色
        }
            break;
        case 2:
        {
            return [UIColor colorWithHexString:@"95a5a5"];//灰色
        }
            break;
        case 3:
        {
            return [UIColor colorWithHexString:@"3399db"];//蓝色
        }
            break;
        case 4:
        {
            return [UIColor colorWithHexString:@"9b5ab6"];//紫色
        }
            break;
        case 5:
        {
            return [UIColor colorWithHexString:@"354a5d"];//深蓝
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end

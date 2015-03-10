//
//  LPickerView.h
//  FBAuto
//
//  Created by lichaowei on 15/3/10.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickerBlock)(NSString *selectString);

@interface LPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *bgView;
    UIPickerView *pickerView;
    PickerBlock _pickerBlock;
}

- (void)showPickerBlock:(PickerBlock)aBlock;


@end

//
//  LTextView.h
//  FBAuto
//
//  Created by lichaowei on 15/1/20.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTextView;

typedef enum {
    
    textViewDidBeginEditing = 0,
    textViewDidEndEditing
    
}ActionStyle;

typedef void(^LTextViewBlock)(LTextView *textView,ActionStyle actionStyle);
@interface LTextView : UITextView<UITextViewDelegate>
{
    UILabel *hint_label;
    LTextViewBlock _textViewBlock;
}

-(instancetype)initWithFrame:(CGRect)frame
                 placeHolder:(NSString *)placeHolder
                    fontSize:(CGFloat)fontSize;
- (void)setBlock:(LTextViewBlock)textViewBlock;

@end

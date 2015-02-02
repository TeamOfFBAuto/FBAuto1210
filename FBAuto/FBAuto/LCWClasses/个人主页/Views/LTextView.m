//
//  LTextView.m
//  FBAuto
//
//  Created by lichaowei on 15/1/20.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "LTextView.h"

@implementation LTextView

-(instancetype)initWithFrame:(CGRect)frame
                 placeHolder:(NSString *)placeHolder
                    fontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.font = [UIFont systemFontOfSize:fontSize];
        hint_label = [[UILabel alloc]initWithFrame:CGRectMake(7, 7.5, 100, fontSize)];
        hint_label.font = [UIFont systemFontOfSize:fontSize];
        hint_label.text = placeHolder;
        [self addSubview:hint_label];
        
        self.hintLabel = hint_label;
    }
    return self;
}

- (void)setBlock:(LTextViewBlock)textViewBlock
{
    _textViewBlock = textViewBlock;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_textViewBlock) {
        _textViewBlock((LTextView *)textView,textViewDidBeginEditing);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_textViewBlock) {
        _textViewBlock((LTextView *)textView,textViewDidEndEditing);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        [textView resignFirstResponder];
        
        if (_textViewBlock) {
            _textViewBlock((LTextView *)textView,textViewDidEndEditing);
        }
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        hint_label.hidden = YES;
    }else
    {
        hint_label.hidden = NO;
    }
}

@end

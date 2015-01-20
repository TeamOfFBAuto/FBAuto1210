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

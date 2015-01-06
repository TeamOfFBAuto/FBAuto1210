//
//  LInputView.h
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WeiBoFaceScrollView.h"
//#import "NewFaceView.h"


typedef void(^ ToolBlock) (int aTag);//aTag, 0 打电话,1 拍照,2 相册,3 frame变化
typedef void(^ FrameBlock) (id inputView,CGRect frame,BOOL isEnd);//frame变化

typedef void(^ InputTextBlock)(NSString *inputText);//输入内容


@interface LInputView : UIView<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat initFrameY;//最开始的frame y
    CGFloat current_FrameY;//inputView当前坐标Y
    CGFloat current_KeyBoard_Y;//当前键盘坐标Y
    
    ToolBlock toolBlock;
    FrameBlock frameBlock;
    InputTextBlock _inputBlock;
    
//    WeiBoFaceScrollView * faceScrollView;
}

@property(strong,nonatomic)UITextView *textView;
@property(strong,nonatomic)UIButton *sendBtn;
@property(strong,nonatomic)UIButton *toolBtn1;
@property(strong,nonatomic)UIButton *toolBtn2;

//点击btn时候是否清空textfield  默认NO
@property(assign,nonatomic)BOOL clearInputWhenSend;
//点击btn时候是否隐藏键盘  默认NO
@property(assign,nonatomic)BOOL resignFirstResponderWhenSend;
//初始frame
@property(assign,nonatomic)CGRect originalFrame;

- (id)initWithFrame:(CGRect)frame  inView:(UIView *)superView inputText:(InputTextBlock)inputBlock;

//隐藏键盘
- (BOOL)resignFirstResponder;

- (void)setToolBlock:(ToolBlock)aBlock;

- (void)setFrameBlock:(FrameBlock)aFrameBlock;

- (void)clearContent;//清空内容

@end

//
//  LInputView.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//
#define SELF_HEIGHT 45  //本身的高度
#define TEXT_HEIGHT 32 //输入框高度
#define TEXT_WIDTH 218 //输入框宽带

#define KLEFT 54 //左距离
#define KTOP 7 //上

#define FONT_SIZE 14 //输入框字体大小

#define UPDARE_HEIGHT 44 //使用系统navigationBar时,高度需要减去此

#define PLACE_HOLDER @"写评论..." //默认语

#import "LInputView.h"

@implementation LInputView

- (id)initWithFrame:(CGRect)frame  inView:(UIView *)superView inputText:(InputTextBlock)inputBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirstResponder)];
        tap.delegate = self;
        [superView addGestureRecognizer:tap];
        
        self.backgroundColor = [UIColor colorWithHexString:@"f3f4f6"];
        self.frame = CGRectMake(0, CGRectGetMinY(frame), DEVICE_WIDTH, SELF_HEIGHT);
        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
//        line.backgroundColor = [UIColor colorWithHexString:@"919499"];
//        [self addSubview:line];
        
        _inputBlock = inputBlock;
        
        [self toolBtn1];//表情切换按钮
        [self textView];
        [self sendBtn];
        
        initFrameY = frame.origin.y;//记录最开始的y
        
    }
    return self;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isKindOfClass:[LButtonView class]]) {
//        return NO;
//    }
//    return YES;
//}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _originalFrame = frame;
}
//_originalFrame的set方法  因为会调用setFrame  所以就不在此做赋值；
- (void)setOriginalFrame:(CGRect)originalFrame
{
    self.frame = CGRectMake(0, CGRectGetMinY(originalFrame), DEVICE_WIDTH, CGRectGetHeight(originalFrame));
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 视图创建

//- (WeiBoFaceScrollView *)faceScrollView
//{
//    if (faceScrollView == nil) {
//        faceScrollView = [[WeiBoFaceScrollView alloc] initWithFrame:CGRectMake(0,0,320,215) target:self];
//        faceScrollView.delegate = self;
//        faceScrollView.bounces = NO;
//        faceScrollView.contentSize = CGSizeMake(320*1,0);//设置有多少页表情
//    }
//    return faceScrollView;
//}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, KTOP, DEVICE_WIDTH - 60, TEXT_HEIGHT)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeySend;
//        _textView.layer.cornerRadius = 5.0;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor colorWithHexString:@"b5b5b7"].CGColor;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:FONT_SIZE];
        _textView.text = PLACE_HOLDER;
        _textView.textColor = [UIColor colorWithHexString:@"cacacc"];
        [self addSubview:_textView];
        
        
//        _textView.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    return _textView;
}

/**
 *  根据编辑状态调整发送按钮
 *
 */
- (void)sendBtnSelected:(BOOL)selected
{
    if (selected) {
        
        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"5c7bbe"] forState:UIControlStateNormal];
//        
//        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"5c7bbe"];
//        
//        _sendBtn.layer.borderWidth = 0.f;
////        _sendBtn.layer.borderColor = [UIColor clearColor].CGColor;

    }else
    {
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
//        _sendBtn.backgroundColor = [UIColor clearColor];
//        
//        _sendBtn.layer.borderWidth = 1.f;
//        _sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"5c7bbe"] forState:UIControlStateSelected];
        
        //colorWithHexString:@"b7b7b7"
        
        [_sendBtn setFrame:CGRectMake(_textView.right+2, 11, 50 - 4 -2, 25)];
        [_sendBtn addTarget:self action:@selector(sendBtnPress:) forControlEvents:UIControlEventTouchUpInside];
//        _sendBtn.layer.borderWidth = 1.f;
//        _sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _sendBtn.layer.cornerRadius = 3.f;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_sendBtn];
        
        _sendBtn.userInteractionEnabled = NO;//默认不可点击
    }
    return _sendBtn;
}

/**
 * 表情切换
 */
- (UIButton *)toolBtn1
{
    if (!_toolBtn1) {
        _toolBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolBtn1 setFrame:CGRectMake(12, (self.height - 28) / 2.f, 28, 28)];
        [_toolBtn1 addTarget:self action:@selector(tool1Press:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBtn1 setImage:[UIImage imageNamed:@"biaoqing-56_56"] forState:UIControlStateNormal];
        [_toolBtn1 setImage:[UIImage imageNamed:@"jianpan-icon-56_56"] forState:UIControlStateSelected];
        _toolBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_toolBtn1];
    }
    return _toolBtn1;
}

#pragma - mark block 回调

- (void)setToolBlock:(ToolBlock)aBlock
{
    toolBlock = aBlock;
}
- (void)setFrameBlock:(FrameBlock)aFrameBlock
{
    frameBlock = aFrameBlock;
}

#pragma mark - 事件处理

/**
 *  清空时恢复inputView 和 textView frame
 */
- (void)resetFrame
{
    [self textViewDidChange:self.textView];
}

- (void)clearContent
{
    
    self.textView.text = @"";
    [self resetFrame];
    [self resignFirstResponder];
    
    self.top = initFrameY;
}

- (void)sendBtnPress:(UIButton*)sender
{
    if (_inputBlock) {
        _inputBlock(self.textView.text);
    }
    
    
    if (self.clearInputWhenSend) {
        self.textView.text = @"";
        _sendBtn.selected = NO;
        [self resetFrame];
    }
    if (self.resignFirstResponderWhenSend) {
        [self resignFirstResponder];
    }
}

- (void)tool1Press:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [_textView resignFirstResponder];
    
    if (sender.selected) {
//        _textView.inputView = [self faceScrollView];
    }else
    {
        _textView.inputView = nil;
    }
    
    if (toolBlock) {
        toolBlock(0);
    }
    
    [_textView becomeFirstResponder];
}

#pragma mark - FaceViewDelegate

//-(void)expressionClickWith:(NewFaceView *)faceView faceName:(NSString *)name
//{
//    _textView.text = [_textView.text stringByAppendingString:name];
//    
//    [self resetFrame];
//}

#pragma mark keyboardNotification

- (void)keyboardWillShow:(NSNotification*)notification{
    
    NSLog(@"keyboardWillShow");
    
    _sendBtn.userInteractionEnabled = YES;//打开发送按钮交互
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect aFrame = self.originalFrame;
        aFrame.origin.y = keyboardRect.origin.y - aFrame.size.height - UPDARE_HEIGHT - 20;
        self.frame = aFrame;
        current_FrameY = aFrame.origin.y;//记录当前y
        current_KeyBoard_Y = keyboardRect.origin.y;
    }];
    
    if (frameBlock) {
        frameBlock(self,self.frame,NO);
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    _sendBtn.userInteractionEnabled = NO;//打开发送按钮交互
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect aFrame = self.frame;
                         aFrame.origin.y = initFrameY - (self.height - SELF_HEIGHT);//框内有内容也能正常显示
                         self.frame = aFrame;
                         current_FrameY = aFrame.origin.y;//记录当前y
                     } completion:nil];
    
    if (frameBlock) {
        frameBlock(self,self.frame,YES);
    }
}

#pragma  mark ConvertPoint

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma - mark UITextView 代理委托

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACE_HOLDER]) {
        
        textView.text = @"";
        
    }
    
    if (textView.text.length > 0) {
        _sendBtn.selected = YES;
    }else
    {
        _sendBtn.selected = NO;
    }
    
    _textView.textColor = [UIColor blackColor];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = PLACE_HOLDER;
        _textView.textColor = [UIColor colorWithHexString:@"cacacc"];
        
            _sendBtn.selected = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    
    [self sendBtnPress:nil];
    
    return NO;
}
/**
 *  计算输入框以及 inputView的高度
 */
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
//        _sendBtn.selected = YES;
        
        [self sendBtnSelected:YES];
        
    }else
    {
//        _sendBtn.selected = NO;
        
        [self sendBtnSelected:NO];

    }
    
    
    CGFloat newHeight = [[self textView] sizeThatFits:CGSizeMake(textView.frame.size.width,CGFLOAT_MAX)].height;
    
    if (newHeight >= 120) {
        return;
    }
    
    CGRect text_Frame = self.textView.frame;
    text_Frame.size.height = newHeight;
    self.textView.frame = text_Frame;
    
    NSLog(@"newheight %f",newHeight);
    CGRect input_Frame = self.frame;
    input_Frame.size.height = SELF_HEIGHT - TEXT_HEIGHT + newHeight;
    input_Frame.origin.y = current_KeyBoard_Y - input_Frame.size.height - UPDARE_HEIGHT - 20;
    
    self.frame = input_Frame;
    
    if (toolBlock) {
        toolBlock(3);
    }
    
    
    if (frameBlock) {
        frameBlock(self,input_Frame,NO);
    }
}


@end

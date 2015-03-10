//
//  LPickerView.m
//  FBAuto
//
//  Created by lichaowei on 15/3/10.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "LPickerView.h"

@implementation LPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = [UIScreen mainScreen].bounds;
        self.window.windowLevel = UIWindowLevelAlert;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        //        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.0;
        
        
        bgView = [[UIView alloc]init];
        [self addSubview:bgView];
        
        //        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 220.0, 216)];
        //        datePicker.backgroundColor = [UIColor whiteColor];
        //        datePicker.datePickerMode = UIDatePickerModeDate;
        //        datePicker.date = [NSDate date];
        //        [bgView addSubview:datePicker];
        //
        //        [datePicker addTarget:self action:@selector(updatetime:) forControlEvents:UIControlEventValueChanged];
        
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.width, 216)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [bgView addSubview:pickerView];
        
        
        UIView *toolsBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
        toolsBarView.backgroundColor = [UIColor colorWithRed:223/255. green:223/255. blue:223/255. alpha:1];
        [bgView addSubview:toolsBarView];
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [finishButton setTitle:@"确定" forState:UIControlStateNormal];
        [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        finishButton.frame = CGRectMake(DEVICE_WIDTH - 50 - 10, 0, 50, 44);
        [finishButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        finishButton.tag = 100;
        [toolsBarView addSubview:finishButton];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"不填写" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(10, 0, 60, 44);
        [cancelButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag = 101;
        [toolsBarView addSubview:cancelButton];
        
        UIImageView *aImage = [[UIImageView alloc]initWithFrame:CGRectMake(finishButton.right, 0, 1, 44)];
        [aImage setImage:[UIImage imageNamed:@"topSeg.png"]];
        [toolsBarView addSubview:aImage];
        
        
        //        UIView *mask = [[UIView alloc]initWithFrame:CGRectMake((self.width - 50) / 2.f, 0, 50.f, datePicker.height)];
        //        mask.backgroundColor = [UIColor whiteColor];
        //        [datePicker addSubview:mask];
        //
        //        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, datePicker.height / 2.f - 22 + 4 + 0.5, self.width, 0.5)];
        //        line1.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        //        [mask addSubview:line1];
        //
        //        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, datePicker.height / 2.f - 22 + 4 + 35, self.width, 0.5)];
        //        line2.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        //        [mask addSubview:line2];
        //
        
//        bgView.frame = CGRectMake(0, self.height, DEVICE_WIDTH, datePicker.height + toolsBarView.height);
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (void)showPickerBlock:(PickerBlock)aBlock
{
    _pickerBlock = aBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.top = self.height - bgView.height;
        self.alpha = 1.0;
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.5 animations:^{
        bgView.top = self.height;
        self.alpha = 0.0;
    }];
    
    [self removeFromSuperview];
}



- (void)clickDoneButton:(UIButton *)sender
{
    if (sender.tag == 100) {
        
//        if (dateBlock) {
//            dateBlock([self selectTime:datePicker.date]);
//        }
    }else if (sender.tag == 101){
        
//        if (dateBlock) {
//            dateBlock(@"不填写");
//        }
    }
    
    [self hidden];
}

- (void)clickCancelButton:(UIButton *)sender
{
    
}

- (void)updatetime:(UIDatePicker *)sender
{
    
//    if (dateBlock) {
//        dateBlock([self selectTime:sender.date]);
//    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        return;
    }
    
    [self hidden];
}


#pragma - mark UIPickerViewDataSource<NSObject>

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma - mark UIPickerViewDelegate<NSObject>

// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0); // attributed title is favored if both methods are implemented
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;


@end

//
//  TucaoPublishController.m
//  FBAuto
//
//  Created by lichaowei on 14/12/26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "TucaoPublishController.h"
#import "FBActionSheet.h"

#import "CustomImagePickerController.h"

#import "QBImagePickerController.h"

@interface TucaoPublishController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
{
    BOOL haveImage;
    
    CGPoint imageCenter;//imageView中心点
    
    CGFloat current_KeyBoard_Y;//键盘当前y
}


@end

@implementation TucaoPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"发布吐槽";
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    imageCenter = self.imageView.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



#pragma mark 事件处理

- (void)addPhoto:(UIImage *)aImage
{
    self.imageView.image = aImage;
    
    haveImage = YES;
    
    //有图片了 输入框跑图片下面去
    
    self.inputView.top = self.imageView.bottom + 10;
    self.photoButton.top = self.inputView.bottom + 10;
    
}

/**
 *  添加图片按钮点击事件
 */
- (IBAction)clickToPhoto:(id)sender {
    
    [self tapToHiddenKeyboard:nil];
    
    __weak typeof(self)weakSelf = self;
    FBActionSheet *sheet = [[FBActionSheet alloc]initWithFrame:self.view.frame];
    [sheet actionBlock:^(NSInteger buttonIndex) {
        NSLog(@"%ld",(long)buttonIndex);
        if (buttonIndex == 0) {
            NSLog(@"拍照");
            
            [weakSelf clickToCamera:nil];
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"相册");
            
            [weakSelf clickToAlbum:nil];
        }
        
    }];
}

- (IBAction)tapToHiddenKeyboard:(id)sender {
    
    [self.inputView resignFirstResponder];
}

//打开相册

- (IBAction)clickToAlbum:(id)sender {
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    //    imagePickerController.assters = photosArray;
    
    imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = 1;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    
}

//打开相机

- (IBAction)clickToCamera:(id)sender {
    
    BOOL is =  [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (is) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark -- 代理

#pragma mark keyboardNotification

- (void)keyboardWillShow:(NSNotification*)notification{
    
    NSLog(@"keyboardWillShow");
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    current_KeyBoard_Y = keyboardRect.origin.y;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        if (haveImage) {
            
            self.inputView.bottom = keyboardRect.origin.y - 64;
            
            self.imageView.bottom = self.inputView.top - 20;
            
            self.photoButton.top = self.imageView.bottom + 10;
        }
        
    }];
    
    //     self.backScroll.contentSize = CGSizeMake(_backScroll.width, _backScroll.height + _photoButton.bottom);
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.imageView.center = imageCenter;
                         
                         if (haveImage) {
                             
                             //有图片了 输入框跑图片下面去
                             self.inputView.top = self.imageView.bottom + 10;
                             self.photoButton.top = self.inputView.bottom + 10;
                         }else
                         {
                             self.inputView.center = self.imageView.center;
                             self.photoButton.top = self.imageView.bottom + 10;
                         }
                         
                         //                          self.backScroll.contentSize = CGSizeMake(_backScroll.width, _backScroll.height + _photoButton.bottom);
                         
                     } completion:nil];
    
    
    
}


#pragma - mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //限高 120
    
    if (textView.height <= 120 && textView.contentSize.height <= 120) {
        
        textView.height = textView.contentSize.height;
        
        if (haveImage == NO) {
            textView.center = self.imageView.center;
        }else
        {
            
            self.inputView.bottom = current_KeyBoard_Y - 64;
            
            self.imageView.bottom = self.inputView.top - 20;
            
            self.photoButton.top = self.imageView.bottom + 10;
            
            //            self.backScroll.contentSize = CGSizeMake(_backScroll.width, _backScroll.height + _photoButton.bottom);
        }
    }
}

#pragma - mark imagePicker 代理

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        UIImage * scaleImage = [SzkAPI scaleToSizeWithImage:originImage size:CGSizeMake(originImage.size.width>1024?1024:originImage.size.width,originImage.size.width>1024?originImage.size.height*1024/originImage.size.width:originImage.size.height)];
        //        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
        NSData *data;
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 0.4);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        [self addPhoto:image];
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
            
        }];
        
    }
}

#pragma - mark QBImagePicker 代理

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)aImagePickerController
{
    [aImagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)imagePickerController1:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    
    
    //    NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
    
    for (int i = 0;i < mediaInfoArray.count;i++)
    {
        UIImage * image = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImage * newImage = image;
        
        [self addPhoto:newImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)imagePickerControllerWillFinishPickingMedia:(QBImagePickerController *)imagePickerController
{
    
}


@end

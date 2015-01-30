//
//  TucaoPublishController.m
//  FBAuto
//
//  Created by lichaowei on 14/12/26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "TucaoPublishController.h"
#import "FBActionSheet.h"

#import "QBImagePickerController.h"

#import "ASIFormDataRequest.h"

@interface TucaoPublishController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
{
    BOOL haveImage;
    
    CGPoint imageCenter;//imageView中心点
    
    CGFloat current_KeyBoard_Y;//键盘当前y
    
    MBProgressHUD *loadingHub;
    
    int colorid;//背景颜色
    
}


@end

@implementation TucaoPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"写吐槽";
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    imageCenter = CGPointMake(DEVICE_WIDTH /2.f, self.imageView.center.y);
    
    //随机一个背景颜色
    
    colorid = arc4random() % 5 + 1;
    
    self.imageView.backgroundColor = [ColorModel colorForTucao:colorid];
    
    NSLog(@"随机颜色id %d",colorid);
    
    loadingHub = [LCWTools MBProgressWithText:@"发布中..." addToView:self.view];
    
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,22,44)];
//    saveButton.backgroundColor = [UIColor orangeColor];
    [saveButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"发布" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [saveButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [saveButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22 - 2, -22 - 9, 0)];
    [saveButton setImage:[UIImage imageNamed:@"fabu44_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
    
    self.navigationItem.rightBarButtonItems = @[save_item];
}

- (void)test
{
    [self postImages:self.imageView.image];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求


/**
 *  发布吐槽
 */
- (void)publishTucaoImageId:(NSString *)imageId
{
    NSString *content = self.inputView.text;
    NSString *url  = [NSString stringWithFormat:FBAUTO_TUCAO_PUBLISH,[GMAPI getAuthkey],content,colorid,imageId];
    
    __weak typeof(self)weakSelf = self;
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [loadingHub hide:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PUBLISHTUCAO_SUCCESS object:nil];
        
        [LCWTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];
        
        [weakSelf performSelector:@selector(clickToBack:) withObject:nil afterDelay:1.5];
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        [LCWTools showDXAlertViewWithText:result[ERROR_INFO]];
        
        [loadingHub hide:YES];
    }];
    
}

/**
 *  图片上传
 */
- (void)postImages:(UIImage *)eImage
{
    [self tapToHiddenKeyboard:nil];
    
    //都为空 就别发布了
    if (!eImage && self.inputView.text.length == 0) {

        NSLog(@"请上传有效图片 或者 填写内容");
        
        [LCWTools showMBProgressWithText:@"没有发布内容" addToView:self.view];
        
        return;
    }
    
    [loadingHub show:YES];
    
    //图片为空,当有文字,直接发布
    if (!eImage && self.inputView.text.length > 0) {
        
        [self publishTucaoImageId:nil];
        
        return;
    }
    
    //有图片,不管是否有文字，
    
    NSString* url = [NSString stringWithFormat:FBAUTO_TUCAO_UPLOAD_IMAGE];
    
    ASIFormDataRequest *uploadImageRequest= [ ASIFormDataRequest requestWithURL : [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    
    [uploadImageRequest setStringEncoding:NSUTF8StringEncoding];
    
    [uploadImageRequest setRequestMethod:@"POST"];
    
    [uploadImageRequest setResponseEncoding:NSUTF8StringEncoding];
    
    [uploadImageRequest setPostValue:[GMAPI getAuthkey] forKey:@"authkey"];
    
    [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    UIImage * newImage = [SzkAPI scaleToSizeWithImage:eImage size:CGSizeMake(eImage.size.width>1024?1024:eImage.size.width,eImage.size.width>1024?eImage.size.height*1024/eImage.size.width:eImage.size.height)];
    
    NSData *imageData=UIImageJPEGRepresentation(newImage,0.5);
    
    [uploadImageRequest addData:imageData withFileName:@"tucao.png" andContentType:@"image/png" forKey:@"photo[]"];
    
    NSLog(@"--- ddxx %u",imageData.length);
    
    [uploadImageRequest setDelegate : self ];
    
    [uploadImageRequest startAsynchronous];
    
    __weak typeof(ASIFormDataRequest *)weakRequst = uploadImageRequest;
    //完成
    [uploadImageRequest setCompletionBlock:^{
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:weakRequst.responseData options:0 error:nil];
        
        NSLog(@"result--> %@",result);
        
        NSArray *datainfo = result[@"datainfo"];
        
        if (datainfo.count > 0) {
            
            NSDictionary *dic = [datainfo lastObject];
            
             [self publishTucaoImageId:dic[@"imageid"]];
        }
        
//        [LCWTools showDXAlertViewWithText:result[@"errinfo"]];
        
    }];
    
    //失败
    [uploadImageRequest setFailedBlock:^{
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:weakRequst.responseData options:0 error:nil];
        
        NSLog(@"uploadFail %@  ss %@",weakRequst.responseString,result);
        
        [loadingHub hide:YES];
        
        [LCWTools showDXAlertViewWithText:@"上传失败，重新发布"];
        
    }];
    
}


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
    if (textView.text.length > 0) {
        
        self.placeHolder.hidden = YES;
    }else
    {
        self.placeHolder.hidden = NO;
    }
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

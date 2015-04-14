//
//  TucaoPublish.m
//  FBAuto
//
//  Created by lichaowei on 15/4/13.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "TucaoPublish.h"
#import "FBActionSheet.h"
#import "QBImagePickerController.h"
#import "PhotoImageView.h"
#import "ASIFormDataRequest.h"

#import "DXAlertView.h"

@interface TucaoPublish ()<UIScrollViewDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    MBProgressHUD *loadingHub;
    NSMutableArray *photosArray;//存放图片
    NSMutableArray *photoViewArray;//存放imageView
    
    NSString *_photo;//图片id组成的字符串
    
    int _colorid;//随机颜色id
    
    QBImagePickerController *imagePickerController;
    
    UIScrollView *photosScroll;//图片底部scrollView
    
    UIButton *photoButton;//添加图片按钮

}

@property(nonatomic,retain)UIButton *dButton;
@property (strong, nonatomic) IBOutlet UITextView *inputView;
@property(strong,nonatomic)UILabel *placeHolder;


@end

@implementation TucaoPublish

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"写吐槽";
    
    //注册键盘通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,22,44)];
    [saveButton addTarget:self action:@selector(clickToPublish:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"发布" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [saveButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [saveButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -22 - 2, -22 - 9, 0)];
    [saveButton setImage:[UIImage imageNamed:@"fabu44_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItems = @[save_item];
    
    //背景view
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH - 20, 260)];
    [self.view addSubview:colorView];
    
    self.inputView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, colorView.width - 20, colorView.height - 20)];
    _inputView.backgroundColor = [UIColor clearColor];
    _inputView.font = [UIFont systemFontOfSize:16];
    _inputView.delegate = self;
    [colorView addSubview:_inputView];
    
    self.placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, colorView.width, 16)];
    _placeHolder.textColor = [UIColor whiteColor];
    _placeHolder.textAlignment = NSTextAlignmentCenter;
    _placeHolder.font = [UIFont systemFontOfSize:16];
    _placeHolder.text = @"输入内容";
    [colorView addSubview:_placeHolder];
    _placeHolder.center = CGPointMake(colorView.width/2.f, colorView.height/2.f);

    //随机一个背景颜色
    _colorid = arc4random() % 5 + 1;
    
    colorView.backgroundColor = [ColorModel colorForTucao:_colorid];
    
    NSLog(@"随机颜色id %d",_colorid);
    
    //添加图片按钮
    
    photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(10, colorView.bottom + 10, colorView.width, 62);
    [photoButton setImage:[UIImage imageNamed:@"tianjia60_60"] forState:UIControlStateNormal];
    [photoButton setTitle:@"选择照片或者拍照" forState:UIControlStateNormal];
    [photoButton setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
    [photoButton setTitleColor:[UIColor colorWithHexString:@"C7C7C7"] forState:UIControlStateNormal];
    [photoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -31 - 31, -33, 0)];
    [photoButton setImageEdgeInsets:UIEdgeInsetsMake(0, 119, 18, 0)];
    [self.view addSubview:photoButton];
    
    [photoButton addTarget:self action:@selector(clickToPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    //底部图片
    
    [self createPhotoView];
    
    loadingHub = [LCWTools MBProgressWithText:@"发布中..." addToView:self.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 网络请求

/**
 *  发布吐槽 多张图片
 */
- (void)publishTucaoImageId:(NSString *)imageId
{
    NSString *content = self.inputView.text;
    
    if (imageId == nil) {
        
        imageId = @"";
    }
    
    NSString *url  = [NSString stringWithFormat:FBAUTO_TUCAO_PUBLISH,[GMAPI getAuthkey],content,_colorid,imageId];
    
    __weak typeof(self)weakSelf = self;
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [loadingHub hide:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PUBLISHTUCAO_SUCCESS object:nil];
        
        [LCWTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];
        
        [weakSelf performSelector:@selector(publishSuccessBack:) withObject:nil afterDelay:1.5];
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        [LCWTools showDXAlertViewWithText:result[ERROR_INFO]];
        
        [loadingHub hide:YES];
    }];
    
}


#pragma - mark 创建视图
/**
 *  添加图片部分
 */
- (void)createPhotoView
{
    photosScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10, photoButton.bottom + 10, DEVICE_WIDTH - 20, 90)];//和图片一样高
    photosScroll.backgroundColor = [UIColor clearColor];
    photosScroll.showsHorizontalScrollIndicator = NO;
    photosScroll.pagingEnabled = YES;
    photosScroll.contentSize = CGSizeZero;
    photosScroll.delegate = self;
    [self.view addSubview:photosScroll];
    
    photosArray = [NSMutableArray array];
    photoViewArray = [NSMutableArray array];
    
}

#pragma - mark 事件处理

-(void)clickToBack:(id)sender
{
    [self.inputView resignFirstResponder];
    
    if (self.inputView.text.length > 0 || photosArray.count > 0) {
        
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"是否放弃编辑内容?" contentText:nil leftButtonTitle:@"放弃" rightButtonTitle:@"编辑" isInput:NO];
        [alert show];
        
        alert.leftBlock = ^(){
            NSLog(@"放弃");
            
            [super clickToBack:sender];
            
        };
        alert.rightBlock = ^(){
            NSLog(@"编辑");
            
        };
        
    }else
    {
        [super clickToBack:sender];
    }
    
}


/**
 *  发布成功直接返回
 *
 *  @param sender
 */
- (void)publishSuccessBack:(id)sender
{
    [self.inputView resignFirstResponder];
    [super clickToBack:sender];
}

/**
 *  点击去发布
 *
 *  @param sender
 */
- (void)clickToPublish:(UIButton *)sender
{
    //    [self postImages:self.imageView.image]; //单张图
    
    [self postImagesDuotu:photosArray];
    
}

/**
 *  多图上传
 */
- (void)postImagesDuotu:(NSArray *)allImages
{
    [loadingHub show:YES];
    
    //挑选 imageId 和 image
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0; i < allImages.count; i ++) {
        id aObject = [allImages objectAtIndex:i];
        
        if ([aObject isKindOfClass:[UIImage class]]) {
            
            NSLog(@"aObject %@",aObject);
            [images addObject:aObject];
        }
    }
    
    
    NSString* url = [NSString stringWithFormat:FBAUTO_TUCAO_UPLOAD_IMAGE];
    
    ASIFormDataRequest *uploadImageRequest= [ ASIFormDataRequest requestWithURL : [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    
    [uploadImageRequest setStringEncoding:NSUTF8StringEncoding];
    
    [uploadImageRequest setRequestMethod:@"POST"];
    
    [uploadImageRequest setResponseEncoding:NSUTF8StringEncoding];
    
    [uploadImageRequest setPostValue:[GMAPI getAuthkey] forKey:@"authkey"];
    
    [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    for (int i = 0;i < allImages.count; i ++)
        
    {
        UIImage *eImage  = [allImages objectAtIndex:i];
        
        
        UIImage * newImage = [SzkAPI scaleToSizeWithImage:eImage size:CGSizeMake(eImage.size.width>1024?1024:eImage.size.width,eImage.size.width>1024?eImage.size.height*1024/eImage.size.width:eImage.size.height)];
        
        NSData *imageData=UIImageJPEGRepresentation(newImage,0.5);
        
        NSString *photoName=[NSString stringWithFormat:@"tucao%d.png",i];
        
        NSLog(@"photoName:%@",photoName);
        
        [uploadImageRequest addData:imageData withFileName:photoName andContentType:@"image/png" forKey:@"photo[]"];
        
        NSLog(@"---%u",imageData.length/1024/1024);
    }
    
    [uploadImageRequest setDelegate : self ];
    
    [uploadImageRequest startAsynchronous];
    
    __weak typeof(ASIFormDataRequest *)weakRequst = uploadImageRequest;
    //完成
    [uploadImageRequest setCompletionBlock:^{
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:weakRequst.responseData options:0 error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            [loadingHub hide:YES];
            
            if (erroCode != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
            
            NSArray *dataInfo = [result objectForKey:@"datainfo"];
            NSMutableArray *imageIdArr = [NSMutableArray arrayWithCapacity:dataInfo.count];
            
            for (NSDictionary *imageDic in dataInfo) {
                NSString *imageId = [imageDic objectForKey:@"imageid"];
                [imageIdArr addObject:imageId];
            }
            
            _photo = [imageIdArr componentsJoinedByString:@","];
            
            __weak typeof(self)weakSelf = self;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [weakSelf publishTucaoImageId:_photo];
            });
        }
        
        
    }];
    
    //失败
    [uploadImageRequest setFailedBlock:^{
        
        NSLog(@"uploadFail %@",weakRequst.responseString);
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:weakRequst.responseData options:0 error:nil];
        
        NSString *erroInfo = [result objectForKey:@"errinfo"];
        
        
        
        [loadingHub hide:YES];
        
        //        [LCWTools showDXAlertViewWithText:@"上传失败，重新发布"];
        
        [LCWTools showDXAlertViewWithText:erroInfo];
        
        
    }];
    
}


//添加图片,移动scrollView

- (void)updateScrollViewAndPhotoButton:(UIImage *)aImage imageUrl:(NSString *)imageUrl
{
    if (aImage == nil && imageUrl == Nil) {
        return;
    }
        
    CGSize scrollSize = photosScroll.contentSize;
    CGFloat scrollSizeWidth = scrollSize.width;
    
    __weak typeof (UIScrollView *)weakScroll = photosScroll;
    __weak typeof (NSMutableArray *)weakPhotoArray = photosArray;
    __weak typeof (NSMutableArray *)weakPhotoViewArray = photoViewArray;
//    __weak typeof (self)weakSelf = self;
    
    UIImage *smallImage = [LCWTools scaleToSizeWithImage:aImage size:CGSizeMake(90, 90)];
    
    PhotoImageView *newImageV= [[PhotoImageView alloc]initWithFrame:CGRectMake(scrollSizeWidth,0, 90, 90) image:smallImage deleteBlock:^(UIImageView *deleteImageView, UIImage *deleteImage) {
        
        
        int deleteIndex = (int)[weakPhotoViewArray indexOfObject:deleteImageView];
        [weakPhotoArray removeObjectAtIndex:deleteIndex];
        
        [weakPhotoViewArray removeObject:deleteImageView];
        
        [deleteImageView removeFromSuperview];
        
        weakScroll.contentSize = CGSizeMake(weakPhotoViewArray.count * (90 + 15), weakScroll.contentSize.height);
        
        [UIView animateWithDuration:0.5 animations:^{
            
            for (int i = 0; i < photoViewArray.count; i ++) {
                PhotoImageView *newImageV = (PhotoImageView *)[photoViewArray objectAtIndex:i];
                CGRect aFrame = newImageV.frame;
                aFrame.origin.x = (90 + 15) * i;
                newImageV.frame = aFrame;
            }
            
        }];
        
    }];
    
    //有可能是图片的网络地址
    
    if (imageUrl) {
        
        [newImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"detail_test.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }else
    {
        [photosArray addObject:aImage];
        
        aImage = nil;
    }
    
    [photosScroll addSubview:newImageV];
    
    [photoViewArray addObject:newImageV];
    
    newImageV = nil;
    
    scrollSize.width = photoViewArray.count * (90 + 15);
    photosScroll.contentSize = scrollSize;
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
            
            [weakSelf clickToAlbum2:nil];
        }
        
    }];
}

- (IBAction)tapToHiddenKeyboard:(id)sender {
    
    [self.inputView resignFirstResponder];
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

//打开相册

- (IBAction)clickToAlbum2:(id)sender {
    
    
    if (photosArray.count >= 9) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"最多选择9张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (!imagePickerController)
    {
        imagePickerController = nil;
    }
    
    
    imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.assters = photosArray;
    imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    
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
    
    NSMutableArray * allImageArray = [NSMutableArray array];
    
    //    NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
    
    for (int i = 0;i < mediaInfoArray.count;i++)
    {
        UIImage * image = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImage * newImage = image;
        [allImageArray addObject:newImage];
        
        [self updateScrollViewAndPhotoButton:newImage imageUrl:nil];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)imagePickerControllerWillFinishPickingMedia:(QBImagePickerController *)imagePickerController
{
    
}
#pragma mark -
#pragma mark UIScrollView delegate methods

//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
//{
//    CGFloat pageWidth = photosScroll.bounds.size.width ;
//    float fractionalPage = photosScroll.contentOffset.x / pageWidth ;
//    NSInteger nearestNumber = lround(fractionalPage) ;
//    
//    if (pageControl.currentPage != nearestNumber)
//    {
//        pageControl.currentPage = nearestNumber ;
//        
//        // if we are dragging, we want to update the page control directly during the drag
//        if (photosScroll.dragging)
//            [pageControl updateCurrentPageDisplay] ;
//    }
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
//{
//    // if we are animating (triggered by clicking on the page control), we update the page control
//    [pageControl updateCurrentPageDisplay] ;
//}


#pragma - mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
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
//    //限高 120
//    
//    if (textView.height <= 120 && textView.contentSize.height <= 120) {
//        
//        textView.height = textView.contentSize.height;
//        
//        if (haveImage == NO) {
//            
//            //            self.inputView.bottom = current_KeyBoard_Y - 64 - 20;
//            //
//            //
//            //            self.imageView.center = _inputView.center;
//            
//            self.inputView.center = self.imageView.center;
//            
//        }else
//        {
//            
//            self.inputView.bottom = current_KeyBoard_Y - 64 - 20;
//            
//            //            self.imageView.bottom = self.inputView.top - 20;
//            
//            self.photoButton.top = self.imageView.bottom + 10;
//            
//            //            self.backScroll.contentSize = CGSizeMake(_backScroll.width, _backScroll.height + _photoButton.bottom);
//        }
//    }
}


@end

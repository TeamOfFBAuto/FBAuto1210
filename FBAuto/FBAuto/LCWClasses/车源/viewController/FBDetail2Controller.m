//
//  FBDetail2Controller.m
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBDetail2Controller.h"
#import "FBPhotoBrowserController.h"
#import "DDPageControl.h"
#import "ClickImageView.h"
#import "LShareSheetView.h"
#import "UserHomeController.h"
#import "FBFriendsController.h"
#import "DXAlertView.h"

#import <ShareSDK/ShareSDK.h>

#import "FBChatViewController.h"

#import "JubaoViewController.h"

#import "CarDetailModel.h"

@interface FBDetail2Controller ()
{
    DDPageControl *pageControl;
    NSArray *imageUrlsArray;
    
    NSString *userId;//用户id
    
    MBProgressHUD *loading;
    
    LCWTools *tool;
}

@end

@implementation FBDetail2Controller

@synthesize bigBgScroll,photosScroll;
@synthesize firstBgView,thirdBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bigBgScroll.top = 0;
    self.bigBgScroll.height = DEVICE_HEIGHT - 75 - 64;
        
    loading = [LCWTools MBProgressWithText:@"加载中..." addToView:self.view];
    
    [self getSingleCarInfoWithId:self.infoId];
    
    if (self.isHiddenUeserInfo) {
        thirdBgView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    NSLog(@"dealloc %@",self);
    [tool cancelRequest];
    
    pageControl = nil;
    imageUrlsArray = nil;
    
    self.firstBgView = nil;
    self.thirdBgView = nil;
    self.bigBgScroll = nil;
    self.photosScroll = nil;
    
    //参数
    self.car_modle_label = nil;
    self.car_realPrice_label = nil;
    self.car_guidePrice_label = nil;
    self.car_timelimit_label = nil;
    self.car_outColor_Label = nil;
    self.car_inColor_label = nil;
    self.car_standard_label = nil;
    self.car_time_label = nil;
    self.car_detail_label = nil;
    self.build_time_label = nil;
    
    //商家信息
    self.headImage = nil;
    
    self.nameLabel = nil;
    self.saleTypeBtn = nil;//商家类型
    self.phoneNumLabel = nil;
    self.addressLabel = nil;
}


#pragma mark - 创建视图

- (void)createViewsWithDetailModel:(CarDetailModel *)aModel
{
    CGFloat label_Width = DEVICE_WIDTH - 92 - 10;
    
    NSArray *items = @[@"车       型:",@"价       格:",@"库       存:",@"外观颜色:",@"内饰颜色:",@"版       本:",@"生产日期:",@"配       置:",@"车辆详情:"];
    
    CGFloat aHeight = 0.f;
    CGFloat aTop = self.firstBgView.bottom + 25;
    for (int i = 0; i < items.count; i ++) {
        
        //标题
        UILabel *t_Label = [self createLabelFrame:CGRectMake(10,aTop, 92, 20) text:[items objectAtIndex:i] alignMent:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        t_Label.font = [UIFont boldSystemFontOfSize:14];
        [self.bigBgScroll addSubview:t_Label];
        t_Label.tag = 100 + i;
        
        //内容
        UILabel *aLabel = [self createLabelFrame:CGRectMake(92, aTop, label_Width, 20) text:@"" alignMent:NSTextAlignmentLeft textColor:[UIColor grayColor]];
        [self.bigBgScroll addSubview:aLabel];
        aLabel.numberOfLines = 0;
        aLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        aLabel.backgroundColor = [UIColor orangeColor];
        aLabel.tag = 110 + i;
        
        if (i == 0) {
            aLabel.text = aModel.car_name;
            aHeight = [LCWTools heightForText:aModel.car_name width:label_Width font:14];
            aLabel.height = aHeight;
            
        }else if (i == 1){
            aLabel.text = [NSString stringWithFormat:@"%@万元",aModel.price];
            
        }else if (i == 2){
            aLabel.text = aModel.spot_future;
        }else if (i == 3){
            aLabel.text = aModel.color_out;
        }else if (i == 4){
            aLabel.text = aModel.color_in;
        }else if (i == 5){
            aLabel.text = aModel.carfrom;
        }else if (i == 6){
//            aLabel.text = [LCWTools timechange2:aModel.dateline];
            aLabel.text = aModel.build_time;
            
        }else if (i == 7){
            
            //车辆配置
    
            NSString *peizhi_select;
    
            NSArray *peizhi = aModel.peizhi_info;
            NSMutableArray *arr = [NSMutableArray array];
            if ([peizhi isKindOfClass:[NSArray class]]) {
    
                for (NSDictionary *aDic in peizhi) {
                    [arr addObject:[LCWTools NSStringRemoveSpace:[aDic objectForKey:@"nodename"]]];
                }
            }
    
            NSString *peizhi_cumtom = aModel.custom_peizhi;
    
            if ([LCWTools NSStringRemoveSpace:peizhi_cumtom].length > 0) {
                [arr addObject:peizhi_cumtom];
            }
    
            peizhi_select = [arr componentsJoinedByString:@","];
            
            if ([peizhi_select isEqualToString:@"null"]) {
                peizhi_select = @"";
            }
            
            aLabel.text = peizhi_select;
            
            aLabel.height = [LCWTools heightForText:peizhi_select width:label_Width font:14];
            
            aTop = aLabel.bottom + 15;
            
        }else if (i == 8){
            
            NSString *detail = @"";
            if (aModel.cardiscrib.length > 0) {
                detail = [NSString stringWithFormat:@"%@  联系请说是在今日车市看到的信息,谢谢!",aModel.cardiscrib];
            }else
            {
                detail = [NSString stringWithFormat:@"联系请说是在今日车市看到的信息,谢谢!"];
            }
            aLabel.text = detail;
            aLabel.height = [LCWTools heightForText:detail width:label_Width font:14];
        }
        
        
        //记录label y坐标
        aTop = aLabel.bottom + 15;
    }
    
    
    //商家信息

    self.thirdBgView.hidden = NO;

    // 线

    self.lineView.hidden = NO;

    //调整商家名字显示长度

    NSString *saleName = aModel.username;

    CGFloat nameWidth = [LCWTools widthForText:saleName font:12];

    nameWidth = (nameWidth <= 110) ? nameWidth : 110;
    self.nameLabel.width = nameWidth;

    self.nameLabel.text = saleName;
    self.saleTypeBtn.left = self.nameLabel.right + 5;


    self.saleTypeBtn.titleLabel.text = aModel.usertype;//商家类型
    self.phoneNumLabel.text = [LCWTools NSStringNotNull:aModel.phone];

    //调整地址显示长度

    NSString *address = [NSString stringWithFormat:@"%@%@",aModel.province,aModel.city];
    CGFloat aWidth = [LCWTools widthForText:address font:10];

    aWidth = (aWidth <= 140)?aWidth : 140;

    self.addressLabel.width = aWidth;

    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",aModel.province,aModel.city];

    NSString *headImage1 = [LCWTools NSStringNotNull:aModel.headimage];

    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headImage1] placeholderImage:DEFAULT_HEAD_IMAGE];

    userId = aModel.uid;//用户id

    //保存name 对应id

    [FBChatTool cacheUserName:aModel.username forUserId:userId];
    [FBChatTool cacheUserHeadImage:headImage1 forUserId:userId];

    //车辆图片

    NSArray *image = aModel.image;
    NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:image.count];

    for (NSDictionary *aImageDic in image) {
        
        NSString *url = [aImageDic objectForKey:@"link"];
        [imageUrls addObject:url];
    }
    
    [self createFirstSectionWithImageUrls:imageUrls];
    
}

- (UILabel *)createLabelFrame:(CGRect)aFrame text:(NSString *)text alignMent:(NSTextAlignment)align textColor:(UIColor *)color
{
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:aFrame];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = text;
    priceLabel.textAlignment = align;
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = color;
    return priceLabel;
}

#pragma - mark 网络请求

- (void)getSingleCarInfoWithId:(NSString *)carId
{
    [loading show:YES];
    
    NSString *url = [NSString stringWithFormat:FBAUTO_CARSOURCE_SINGLE_SOURE,carId,[GMAPI getUid]];
    
    NSLog(@"单个车源信息 %@",url);
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(loading)weakLoading = loading;
    tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestNormalCompletion:^(NSDictionary *result, NSError *erro) {
        
        [weakLoading hide:YES];
        
        NSLog(@"单个车源发布 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
    
        NSDictionary *datainfo = [result objectForKey:@"datainfo"];
        
        CarDetailModel *detailModel = [[CarDetailModel alloc]initWithDictionary:datainfo];
        
        [weakSelf createViewsWithDetailModel:detailModel];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        
        [weakLoading hide:YES];
        
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:[failDic objectForKey:ERROR_INFO] contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        
        alert.leftBlock = ^(){
            NSLog(@"确定");
            
        };
        alert.rightBlock = ^(){
            NSLog(@"取消");
            
        };
    }];
}

#pragma - mark 图片部分

- (void)createFirstSectionWithImageUrls:(NSArray *)imageUrls
{
    imageUrlsArray = imageUrls;
    
    CGFloat aWidth = (photosScroll.width - 14)/ 3;
    
    for (int i = 0; i < imageUrls.count; i ++) {
        
        ClickImageView *clickImage = [[ClickImageView alloc]initWithFrame:CGRectMake((aWidth + 7) * i, 0, aWidth, 80) target:self action:@selector(clickToBigPhoto:)];
        
        [clickImage sd_setImageWithURL:[NSURL URLWithString:[imageUrls objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"detail_test.jpg"]];
        
        clickImage.tag = 100 + i;
        
        [photosScroll addSubview:clickImage];
        
    }
    
    photosScroll.contentSize = CGSizeMake(aWidth * imageUrls.count + 7 * (imageUrls.count - 1), 80);
    
    [self createPageControlSumPages:(int)imageUrls.count];
    
    if (imageUrls.count <= 2) {
        
        CGRect aFrame = photosScroll.frame;
        aFrame.size.width = aWidth * imageUrls.count;
        photosScroll.frame = aFrame;
        
        photosScroll.center = CGPointMake((DEVICE_WIDTH - 20)/2.f, photosScroll.center.y);
    }
    
    self.bigBgScroll.contentSize = CGSizeMake(self.view.width,[self labelWithTag:118].bottom + 10);

}


#pragma - mark 创建 PageControl

- (void)createPageControlSumPages:(int)sum
{
    if (sum % 3 == 0) {
        sum = sum / 3;
    }else
    {
        sum = (sum / 3) + 1;
    }
    
    
    pageControl = [[DDPageControl alloc] init] ;
	[pageControl setCenter: CGPointMake(firstBgView.center.x, firstBgView.height-10.0f)] ;
    //	[pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor: [UIColor colorWithHexString:@"ff9c00"]];
	[pageControl setOffColor: [UIColor colorWithHexString:@"b4b4b4"]] ;
	[pageControl setIndicatorDiameter: 9.0f] ;
	[pageControl setIndicatorSpace: 5.0f] ;
	[firstBgView addSubview: pageControl] ;
    
    //    pageControl.hidden = YES;
    
    [pageControl setNumberOfPages:sum];
	[pageControl setCurrentPage: 0];
}


- (UILabel *)labelWithTag:(int)aTag
{
    return (UILabel *)[self.view viewWithTag:aTag];
}

#pragma - mark click 事件

/**
 *  http://fbautoapp.fblife.com/resource/photo/dc/0a/thumb_50_ori.jpg
 *
 *  @param btn <#btn description#>
 */
- (void)clickToBigPhoto:(ClickImageView *)btn
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *url in imageUrlsArray) {
        
        NSMutableString *str = [NSMutableString stringWithString:url];
        
        [str replaceOccurrencesOfString:@"small" withString:@"ori" options:0 range:NSMakeRange(0, str.length)];
        
        [arr addObject:str];
        
    }
    
    FBPhotoBrowserController *browser = [[FBPhotoBrowserController alloc]init];
    browser.imagesArray = arr;
    browser.showIndex = (int)btn.tag - 100;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	CGFloat pageWidth = photosScroll.bounds.size.width ;
    float fractionalPage = photosScroll.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (pageControl.currentPage != nearestNumber)
	{
		pageControl.currentPage = nearestNumber ;
		
		// if we are dragging, we want to update the page control directly during the drag
		if (photosScroll.dragging)
			[pageControl updateCurrentPageDisplay] ;
	}
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[pageControl updateCurrentPageDisplay] ;
    
//    NSLog(@"%f",aScrollView.contentOffset.x);
}

#pragma - mark 点击事件

- (IBAction)clickToDial:(id)sender {
    
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"是否立即拨打电话" contentText:nil leftButtonTitle:@"拨打" rightButtonTitle:@"取消" isInput:NO];
    [alert show];
    
    alert.leftBlock = ^(){
        NSLog(@"确定");
        
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.phoneNumLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    };
    alert.rightBlock = ^(){
        NSLog(@"取消");
        
    };
}
- (IBAction)clickToChat:(id)sender {
    
    NSString *current = [[NSUserDefaults standardUserDefaults]stringForKey:USERID];
    if ([userId isEqualToString:current]) {
        
        [LCWTools showDXAlertViewWithText:@"本人发布信息"];
        return;
    }
    [FBChatTool chatWithUserId:userId userName:self.nameLabel.text target:self];
    
}

- (IBAction)clickToPersonal:(id)sender {
    
    UserHomeController *personal = [[UserHomeController alloc]init];
    personal.title = self.nameLabel.text;
    personal.userId = userId;
    [self.navigationController pushViewController:personal animated:YES];
}

//举报
- (void)clickToJubao:(UIButton *)sender
{
    JubaoViewController *jubao = [[JubaoViewController alloc]init];
    jubao.cid = self.infoId;//test jubao
    [self.navigationController pushViewController:jubao animated:YES];
}

//收藏
- (void)clickToCollect:(UIButton *)sender
{
    NSLog(@"收藏");
    
    // ‘1’ 车源收藏 ‘2’ 寻车收藏
    NSString *url = [NSString stringWithFormat:FBAUTO_COLLECTION,[GMAPI getAuthkey],self.carId,1,self.infoId];
    
    NSLog(@"添加收藏 %@",url);
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"添加收藏 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        int errcode = [[result objectForKey:@"errcode"]integerValue];
        if (errcode == 0) {
            
            self.collectButton.selected = YES;
        }
        
        [LCWTools showDXAlertViewWithText:[result objectForKey:@"errinfo"]];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
    }];

    
}

//分享
- (void)clickToShare:(UIButton *)sender
{
    NSLog(@"分享");
    
    __weak typeof(self) weakSelf = self;
    
    LShareSheetView *shareView = [[LShareSheetView alloc]initWithFrame:self.view.frame];
    [shareView actionBlock:^(NSInteger buttonIndex, NSString *shareStyle) {
        
//        NSArray *text =  @[@"微信",@"QQ",@"朋友圈",@"微博",@"站内好友"];
        
        NSString *title = [self labelWithTag:110].text;
        
        NSString *contentText = [NSString stringWithFormat:@"我在今日车市上发了一辆新车，有兴趣的来看(%@）。",title];
        
        NSString *shareUrl = [NSString stringWithFormat:FBAUTO_SHARE_CAR_SOURCE,weakSelf.infoId];
        NSString *contentWithUrl = [NSString stringWithFormat:@"%@%@",contentText,shareUrl];
        
        ClickImageView *clickImage = (ClickImageView *)[photosScroll viewWithTag:100];
        
        UIImage *aImage = clickImage.image;
        
        buttonIndex -= 100;
        
        
        NSLog(@"share %d %@",buttonIndex,shareStyle);
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"微信");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeWeixiSession];
            }
                break;
            case 1:
            {
                NSLog(@"QQ");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeQQ];
            }
                break;
            case 2:
            {
                NSLog(@"朋友圈");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeWeixiTimeline];
            }
                break;
            case 3:
            {
                NSLog(@"微博");

                [LCWTools shareText:contentWithUrl title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeSinaWeibo];
            }
                break;
            case 100:
            {
                NSLog(@"站内好友");
                
                FBFriendsController *friend = [[FBFriendsController alloc]init];
                friend.isShare = YES;
                //分享的内容  {@"text",@"infoId"}
                
                NSString *infoId = [NSString stringWithFormat:@"%@,%@",weakSelf.infoId,weakSelf.carId];
                friend.shareContent = @{@"text": contentText,@"infoId":infoId,SHARE_TYPE_KEY:SHARE_CARSOURCE};
                [self.navigationController pushViewController:friend animated:YES];
                
            }
                break;
            case 4:
            {
                NSLog(@"QQ空间");
                
                [LCWTools shareText:contentWithUrl title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeQQSpace];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - 发送短信

//短信

-(void)showSMSPicker:(NSString *)phoneNumber smsBody:(NSString *)smsBody{
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            
            [self displaySMSComposerSheet:phoneNumber smsBody:smsBody];
        }
        else {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持短信功能" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        
    }
}

-(void)displaySMSComposerSheet:(NSString *)phoneNumber smsBody:(NSString *)smsBody

{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    
    //收件人
    NSArray *receiveArr = [NSArray arrayWithObjects:phoneNumber, nil];
    [picker setRecipients:receiveArr];
    //短信内容
    picker.body=smsBody;
    
    [self presentViewController:picker animated:YES completion:Nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    
    {
            
        case MessageComposeResultCancelled:
            
            NSLog(@"Result: 取消短信发送");
            break;
            
        case MessageComposeResultSent:
            NSLog(@"Result: 短信发送成功");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"Result: 短信发送失败");
            break;
        default:
            break;
            
    }
    //退出发短信界面
    [self dismissViewControllerAnimated:YES completion:Nil];
}

@end

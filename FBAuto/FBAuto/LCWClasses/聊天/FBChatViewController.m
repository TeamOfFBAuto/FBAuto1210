//
//  FBChatViewController.m
//  TestIMKIt
//
//  Created by lichaowei on 14-9-20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "FBChatViewController.h"
#import "RCPreviewViewController.h"
#import "GuserZyViewController.h"
#import "DXAlertView.h"

#import "UserHomeController.h"

@interface FBChatViewController ()

@end

@implementation FBChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    // 设置用户信息提供者。
//    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:NO];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserInfo:) name:NOTIFICATION_UPDATE_USERINFO object:nil];
    
    
    [super viewWillAppear:animated];
    
//    [self getPersonalInfo:self.currentTarget];
}
-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_UPDATE_USERINFO object:nil];
}

-(void)sendDebugRichMessage {
    
    RCRichContentMessage *message = [[RCRichContentMessage alloc] init];
    message.title = @"Yosemite崩溃的修复方法";
    message.digest = @"在新的优胜美地";
//    message.imageURL = @"http://images.macx.cn/forum/201410/18/051336drp3zwrrh35w5p4e.jpg#id=11";
    message.extra = @"11";
    
    [[RCIM sharedRCIM] sendMessage:self.conversationType
                          targetId:self.currentTarget
                           content:message
                          delegate:self];
}

- (void)updateUserInfo:(NSNotification *)notification
{
    [self.chatListTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.chatListTableView.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [rightButton addTarget:self action:@selector(clickToHome:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"shouye48_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIButton *rightButton2 =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [rightButton2 addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton2 setImage:[UIImage imageNamed:@"tianjia44_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item2=[[UIBarButtonItem alloc]initWithCustomView:rightButton2];
    self.navigationItem.rightBarButtonItems = @[save_item,save_item2];
    
    self.enablePOI = YES;
    
    [self sendDebugRichMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBarButtonItemPressed:(id)sender
{
    [super leftBarButtonItemPressed:sender];
}

-(void)rightBarButtonItemPressed:(id)sender{
//    DemoChatsettingViewController *temp = [[DemoChatsettingViewController alloc]init];
//    temp.targetId = self.currentTarget;
//    temp.conversationType = self.conversationType;
//    temp.portraitStyle = UIPortraitViewRound;
//    [self.navigationController pushViewController:temp animated:YES];
}

-(void)showPreviewPictureController:(RCMessage*)rcMessage{
    
    RCPreviewViewController *temp=[[RCPreviewViewController alloc]init];
    temp.rcMessage = rcMessage;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:temp];
    
    //导航和原有的配色保持一直
    UIImage *image= [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    [self presentViewController:nav animated:YES completion:nil];
}

-(void)onBeginRecordEvent{
    NSLog(@"录音开始");
}
-(void)onEndRecordEvent{
    NSLog(@"录音结束");
}


#pragma - mark  click事件

- (void)clickToHome:(UIButton *)btn
{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    UserHomeController *personal = [[UserHomeController alloc]init];
    personal.title = self.currentTargetName;
    personal.userId = self.currentTarget;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)clickToAdd:(UIButton *)btn
{
    
    [self addFriend:self.currentTarget];
    
}

/**
 *  添加好友
 *
 *  @param friendId userId
 */
- (void)addFriend:(NSString *)friendId
{
    NSLog(@"provinceId %@",friendId);
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_ADD,[GMAPI getAuthkey],friendId]isPost:NO postData:nil];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@ erro %@",result,[result objectForKey:@"errinfo"]);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            //            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:erroInfo contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定" isInput:NO];
            [alert show];
            
            alert.leftBlock = ^(){
                NSLog(@"确定");
            };
            alert.rightBlock = ^(){
                NSLog(@"取消");
                
            };
            
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
    }];
}


@end

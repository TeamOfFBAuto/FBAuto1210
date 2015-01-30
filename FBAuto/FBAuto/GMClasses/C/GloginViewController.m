//
//  GloginViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GloginViewController.h"
#import "GloginView.h"//登录界面view
#import "GzhuceViewController.h"//注册
#import "GfindPasswViewController.h"//找回密码
#import "RCIM.h"
#import "MBProgressHUD.h"
#import "DXAlertView.h"

//新版注册页面

#import "UserRegisterController.h"

@interface GloginViewController ()
{
    UIActivityIndicatorView *j;
    
    UIActivityIndicatorView *loading;
}

@end

@implementation GloginViewController



-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


//-(void)viewDidAppear:(BOOL)animated{
//
//    [super viewDidAppear:animated];
//    //隐藏navigationBar
//    self.navigationController.navigationBarHidden = YES;
//
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.button_back.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%s",__FUNCTION__);
    
    GloginView *gloginView = [[GloginView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.gloginView = gloginView;
    [self.view addSubview:gloginView];
    
    gloginView.userTf.text = [LCWTools cacheForKey:LOGIN_PHONE];
    gloginView.passWordTf.text = [LCWTools cacheForKey:LOGIN_PASS];
    
    
    __weak typeof (self)bself = self;
    __weak typeof (gloginView)bgloginView = gloginView;
    
    //设置跳转注册block
    [gloginView setZhuceBlock:^{
        [bgloginView Gshou];
        [bself pushToZhuceVC];
    }];
    
    //设置找回密码block
    [gloginView setFindPassBlock:^{
        [bgloginView Gshou];
        [bself pushToFindPassWordVC];
    }];
    
    //数据加载菊花
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loading.center = CGPointMake(DEVICE_WIDTH / 2.f, 235);
    [self.view addSubview:loading];
    
    //登录
    [gloginView setDengluBlock:^(NSString *usern, NSString *passw) {
        
        NSLog(@"--%@     --%@",usern,passw);
        
        if (usern.length ==0 && passw.length == 0) {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户名和密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }else if (usern.length == 0 || passw.length == 0){
            if (usern.length == 0) {
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
            }else if (passw.length == 0){
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
            }
        }else{
            [bself dengluWithUserName:usern pass:passw];
        }
        
    }];
    
}

#pragma mark - 登录

-(void)dengluWithUserName:(NSString *)name pass:(NSString *)passw{
    
    [loading startAnimating];
    
    //保存用户手机号
    [LCWTools cache:name ForKey:USERPHONENUMBER];
    [LCWTools cache:name ForKey:LOGIN_PHONE];
    
    NSString *deviceToken = [GMAPI getDeviceToken] ? [GMAPI getDeviceToken] : @"testToken";
    
    NSString *str = [NSString stringWithFormat:FBAUTO_LOG_IN,name,passw,deviceToken];
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:str isPost:NO postData:nil];
    
    __weak typeof(self)weakSelf = self;

    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSDictionary *datainfo = [result objectForKey:@"datainfo"];
        NSString *userid = [datainfo objectForKey:@"uid"];
        NSString *username = [datainfo objectForKey:@"name"];
        NSString *authkey = [datainfo objectForKey:@"authkey"];
        
        [weakSelf loginRongCloudWithUserId:userid name:username headImageUrl:[LCWTools headImageForUserId:userid] pass:passw authkey:authkey];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [loading stopAnimating];
        NSString *errinfo = @"登录失败";
        int errocode = [failDic[@"errocode"]intValue];
        if (errocode == 3) {
            
            errinfo = @"用户名或密码错误!";
        }else
        {
            errinfo = failDic[ERROR_INFO];
        }
        
        [LCWTools showMBProgressWithText:errinfo addToView:self.view];
        
    }];
}

#pragma mark - 融云获取token

- (void)loginRongCloudWithUserId:(NSString *)userId
                            name:(NSString *)name
                    headImageUrl:(NSString *)imageUrl
                            pass:(NSString *)pass
                         authkey:(NSString *)authkey
{
    NSString *url = [NSString stringWithFormat:FBAUTO_RONGCLOUD_TOKEN,userId,name,imageUrl];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"融云 result%@",result);
        int code = [[result objectForKey:@"code"]integerValue];
        NSString *errorMessage = [result objectForKey:@"errorMessage"];
        
        if (code == 200) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = [result objectForKey:@"userId"];
            NSString *loginToken = [result objectForKey:@"token"];
            
            [defaults setObject:userId forKey:USERID];
            [defaults setObject:name forKey:USERNAME];
            [defaults setObject:authkey forKey:USERAUTHKEY];
            [defaults setObject:pass forKey:USERPASSWORD];
            
            [defaults setObject:loginToken forKey:RONGCLOUD_TOKEN];
            
            [LCWTools cache:pass ForKey:LOGIN_PASS];
            
            typeof(self) __weak weakSelf = self;
            [RCIM connectWithToken:loginToken completion:^(NSString *userId) {
                
                NSLog(@"登录成功! %@",userId);
                
                [defaults setBool:YES forKey:LOGIN_SUCCESS];
                
                [loading stopAnimating];
                
                [defaults synchronize];
                
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                
            } error:^(RCConnectErrorCode status) {
                
                [loading stopAnimating];
                
                NSLog(@"%@",[NSString stringWithFormat:@"登录失败！\n Code: %d！",status]);
                    
                [defaults setBool:NO forKey:LOGIN_SUCCESS];
                
                [defaults synchronize];

                
            }];
            
            
        }else
        {
            [loading stopAnimating];
            
            [LCWTools showMBProgressWithText:errorMessage addToView:self.view];
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        
        [loading stopAnimating];
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        
    }];

}



#pragma mark - 跳转到注册界面
-(void)pushToZhuceVC{
//    GzhuceViewController *gzhuceVc = [[GzhuceViewController alloc]init];
//    [self.navigationController pushViewController:gzhuceVc animated:YES];
    
    UserRegisterController *register_vc = [[UserRegisterController alloc]init];
    [self.navigationController pushViewController:register_vc animated:YES];
}

#pragma mark - 跳转找回密码界面
-(void)pushToFindPassWordVC{
    GfindPasswViewController *gfindwVc = [[GfindPasswViewController alloc]init];
    [self.navigationController pushViewController:gfindwVc animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  FBAutoAPIHeader.h
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#ifndef FBAuto_FBAutoAPIHeader_h
#define FBAuto_FBAutoAPIHeader_h

#import "UIView+Frame.h" //布局使用
#import "NSString+PinYin.h"//获取首字母
#import "UIColor+ConvertColor.h"//16进制颜色转换
#import "UIImageView+WebCache.h"
#import "EGORefreshTableHeaderView.h"//下拉刷新
#import "MBProgressHUD.h"

#import "UILabel+GautoMatchedText.h"//文字自适应高度

#import "GMAPI.h"//GODLIKE
#import "SzkAPI.h"
#import "LCWTools.h"

#import "RCIM.h"//融云
#import "FBChatTool.h"

#import "ColorModel.h"

//默认配置

#define DEFAULT_HEAD_IMAGE [UIImage imageNamed:@"defaultFace"] //默认头像

#define DEFAULT_CAR_IAMGE [UIImage imageNamed:@"detail_test.jpg"] //默认汽车图片

#define RONG_SERVICE_ID @"KEFU1413164724086" //客服号
#define RONGCLOUD_TOKEN @"RONGCLOUD_TOKEN" //用户对应的融云token

#define LOGIN_SUCCESS @"LOGIN_SUCCESS" //登录成功

#define LOGIN_PHONE @"LOGIN_PHONE"//登录手机号
#define LOGIN_PASS @"LOGIN_PASS"//登录密码

//上传图片

#define UPLOAD_HEAD_IAMGE @"gIsUpFace"//上传头像
#define UPLOAD_BANNER_IMAGE @"uploadBanner"//banner 背景图

#define FIRST_LAUNCH @"firstLaunch" //第一次启动

//保存用户信息

#define USERPHONENUMBER @"iphonenumber"

#define USERID @"userid"

#define USERNAME @"username"

#define USERAUTHKEY @"userauthkey"

#define DEVICETOKEN @"devicetoken"

#define USERPASSWORD @"userpassword"

#define FBAUTO_APPID @"904576362" //e车 appStore appid

#define KPageSize  30 //每页条数

#define CAR_UPDATE_DATE_LOCAL @"CAR_UPDATE_DATE_LOCAL" //本地-车型数据更新时间(更新成功之后与服务器时间更新一致)

#define CAR_UPDATE_CONFIG_DATE_LOCAL @"carConfigUpdateDateline"//车型配置数据更新时间

#define NOTICE_UPDATE_DATE_LOCAL @"NOTICE_UPDATE_DATE_LOCAL" //本地-通知数据更新时间(更新成功之后与服务器时间更新一致)

#define NOTICE_NEW_COUNT @"NOTICE_COUNT"//通知个数

#define NOTIFICATION_PUBLISHTUCAO_SUCCESS @"PUBLISHTUCAO_SUCCESS"//发布吐槽成功

#define NOTIFICATION_PUBLISH_LIYYAN_SUCCESS @"LIYAN_SUCCESS"//发布留言成功

///屏幕宽度
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
#pragma mark - 屏幕高度
///屏幕高度
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

//颜色

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

//通用 红色
#define COLOR_NORMAL RGBCOLOR(220, 23, 19)

//判断系统版本
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
//判断iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//int 转 string

#define NSStringFromFloat(float) [NSString stringWithFormat:@"%f",(float)]
#define NSStringFromInt(int) [NSString stringWithFormat:@"%d",(int)]


#pragma mark - 风格设置


#define FBAUTO_IMAGE_NAVIGATION [UIImage imageNamed:@"daohanglan"] //导航栏背景 红色

#define FBAUTO_IMAGE_NAVIGATION1 [UIImage imageNamed:@"daohanglan_bg_640_88@2x"] //导航栏背景 黑色

#define FBAUTO_IMAGE_BACK1 [UIImage imageNamed:@"fanhui_24_42"] //返回按钮

#define FBAUTO_IMAGE_BACK [UIImage imageNamed:@"fanhui24_40"] //返回按钮 2.0

#define FBAUTO_COLOR_MEBU [UIColor colorWithHexString:@"f4f4f4"] //menu背景颜色

#define FBAUTO_COLOR_MEBU_TEXT [UIColor blackColor] //menu text 颜色

#define FBAUTO_IMAGE_TABBAR [UIImage imageNamed:@"tabbar_bg"] //tabbar背景图



#pragma mark - 接口地址


#define FBAUTO_APPSTORE_URL @"https://itunes.apple.com/us/app/e-zu-qi-che/id904576362?l=zh&ls=1&mt=8"//APPStore下载地址


//用户相关API=================

//http://fbautotest.fblife.com
//http://fbautoapp.fblife.com

#define FBAUTO_HOST @"http://fbautotest.fblife.com"

//获取手机验证码  1：注册时获取验证码；2：重置密码时候获取验证码
#define FBAUTO_GET_VERIFICATION_CODE @"http://fbautotest.fblife.com/index.php?c=interface&a=phonecode&phone=%@&optype=%d"

////验证手机验证码
//#define FBAUTO_YANZHENG_VERIFICATION_CODE @"http://fbautotest.fblife.com/index.php?c=interface&a=checkphonecode&phone=%@&code=%@"

//用户注册
#define FBAUTO_REGISTERED @"http://fbautotest.fblife.com/index.php?c=interface&a=register&phone=%@&password=%@&name=%@&province=%d&city=%d&usertype=%d&code=%@&token=%@&fullname=%@&address=%@"

//用户登录
#define FBAUTO_LOG_IN @"http://fbautotest.fblife.com/index.php?c=interface&a=dologin&phone=%@&upass=%@&token=%@"

//融云获取token

#define FBAUTO_RONGCLOUD_TOKEN @"http://fbautotest.fblife.com/rongcloud_api.php?userid=%@&name=%@&portraituri=%@"

//用户退出登录
#define  FBAUTO_LOG_OUT @"http://fbautotest.fblife.com/index.php?c=interface&a=dologout&uid=%@"

//获取个人信息
#define FBAUTO_GET_USER_INFORMATION @"http://fbautotest.fblife.com/index.php?c=interface&a=getuser&uid=%@"

//获取个人信息 -- 加用户关系 2.0
#define FBAUTO_GET_USER_INFORMATION_NEW @"http://fbautotest.fblife.com/index.php?c=interface&a=getuser&uid=%@&authkey=%@"

//修改用户密码
#define  FBAUTO_MODIFY_PASSWORD @"http://fbautotest.fblife.com/index.php?c=interface&a=edituser&authkey=%@&password=%@&op=pass&phone=%@"

//修改个人信息-消息模式
#define  FBAUTO_MESSAGE_TYPE @"http://fbautotest.fblife.com/index.php?c=interface&a=edituser&authkey=%@&msg_visible=%d&op=msg_visib"

//修改个人信息-个人简介
#define FBAUTO_MODIFY_JIANJIE @"http://fbautotest.fblife.com/index.php?c=interface&a=edituser&authkey=%@&intro=%@&op=intro"

//修改个人信息-详细地址
#define FBAUTO_MODIFY_ADDRESS @"http://fbautotest.fblife.com/index.php?c=interface&a=edituser&authkey=%@&address=%@&op=address"

//修改个人信息-用户头像
#define FBAUTO_MODIFY_HEADER_IMAGE @"http://fbautotest.fblife.com/index.php?c=interface&a=edituser&op=headimg&authkey=%@"

//修改个人信息-背景图
#define FBAUTO_MODIFY_BANNER_IMAGE @"http://fbautotest.fblife.com/index.php?c=interface&a=adduserbg&authkey=%@"

//找回密码
#define FBAUTO_MODIFY_FIND_PASSWORD @"http://fbautotest.fblife.com/index.php?c=interface&a=resetpass&phone=%@&code=%@&password=%@"

//修改完用户信息发送的通知
#define FBAUTO_CHANGEPERSONALINFO @"changePersonalInfoMation"

//获取系统通知列表
#define FBAUTO_PERSONTZLB @"http://fbautotest.fblife.com/index.php?c=interface&a=getnoticelist"


//获取通知详细内容
#define FBAUTO_PERSONTZ @"http://fbautotest.fblife.com/index.php?c=interface&a=getnotice&nid=%@"

#define FBAUTO_NOTICE_NEW_COUNT @"http://fbautotest.fblife.com/index.php?c=interface&a=getnoticenum&fromtime=%@&endtime=%@"//时间段内通知个数

#define FBAUTO_NOTICE_TIME @"http://fbautotest.fblife.com/index.php?c=interface&a=getupdate&upfrom=noticedata"//获取通知更新时间


//好友API=================

//好友列表
#define FBAUTO_FRIEND_LIST @"http://fbautotest.fblife.com/index.php?c=interface&a=getbuddy&uid=%@" //用户id

//添加好友
#define FBAUTO_FRIEND_ADD @"http://fbautotest.fblife.com/index.php?c=interface&a=addbuddy&authkey=%@&buddyid=%@" //好友uid

//搜索好友
#define FBAUTO_FRIEND_SEARCH @"http://fbautotest.fblife.com/index.php?c=interface&a=searchbuddy&authkey=%@&keyword=%@" //关键字

//获取通讯录好友
#define FBAUTO_FRIEND_ADDRESSBOOK @"http://fbautotest.fblife.com/index.php?c=interface&a=getphonemember&authkey=%@&phone=%@&rname=%@"  //authkey : 加密的用户信息 phone : 通讯录电话，用逗号隔开 rname : 通讯录人名，用逗号隔开

//按地区获取好友
#define FBAUTO_FRIEND_AREA @"http://fbautotest.fblife.com/index.php?c=interface&a=getareabuddy&authkey=%@&province=%@&city=%@"  //province : 省份id，不能为空  city : 城市id，可以为空

//删除好友
#define FBAUTO_FRIEND_DELETE @"http://fbautotest.fblife.com/index.php?c=interface&a=delbuddy&authkey=%@&buddyid=%@"//好友uid


//车源API================

#define FBAUTO_CARSOURCE_UPDATESTATE @"http://fbautotest.fblife.com/index.php?c=interface&a=getupdate&upfrom=cardata"//车型数据是否需要更新

#define FBAUTO_CARSOURCE_CARTYPE @"http://fbautotest.fblife.com/index.php?c=interface&a=getcardata"//车型数据

#define FBAUTO_CARSOURCE_GETUPDATEDATE @"http://fbautotest.fblife.com/index.php?c=interface&a=getupcardata&fromtime=%@&endtime=%@"//根据时间获取更新车型数据

#define FBAUTO_CARSOURCE_LIST @"http://fbautotest.fblife.com/index.php?c=interface&a=getcheyuan"//车源列表

#define FBAUTO_CARSOURCE_ADD_PIC @"http://fbautotest.fblife.com/index.php?c=interface&a=addpic"//添加图片

#define FBAUTO_CARSOURCE_ADD_SOURCE @"http://fbautotest.fblife.com/index.php?c=interface&a=addcheyuan"//添加车源

#define FBAUTO_CARSOURCE_SINGLE_SOURE @"http://fbautotest.fblife.com/index.php?c=interface&a=getsinglecheyuan&cid=%@&uid=%@"//获取单个车源

#define FBAUTO_CARSOURCE_SEARCH @"http://fbautotest.fblife.com/index.php?c=interface&a=searchcheyuan&keyword=%@&page=%d&ps=%d"//搜索车源

#define FBAUTO_CARSOURCE_MYSELF @"http://fbautotest.fblife.com/index.php?c=interface&a=getmycheyuan&uid=%@&page=%d&ps=%d"//获取我的车源

#define FBAUTO_CARSOURCE_DELETE @"http://fbautotest.fblife.com/index.php?c=interface&a=delcheyuan&authkey=%@&cid=%@" //删除车源

#define FBAUTO_CARSOURCE_EDIT @"http://fbautotest.fblife.com/index.php?c=interface&a=editcheyuan"//修改车源信息

#define FBAUTO_CARSOURCE_REFRESH @"http://fbautotest.fblife.com/index.php?c=interface&a=flushcheyuan&cid=%@&authkey=%@"//刷新车源

//寻车API================

#define FBAUTO_FINDCAR_LIST @"http://fbautotest.fblife.com/index.php?c=interface&a=getxunche"//寻车列表数据

#define FBAUTO_FINDCAR_SEARCH @"http://fbautotest.fblife.com/index.php?c=interface&a=searchxunche&keyword=%@&page=%d&ps=%d" //寻车搜索

#define FBAUTO_FINCAR_MYSELF @"http://fbautotest.fblife.com/index.php?c=interface&a=getmyxunche&uid=%@&page=%d&ps=%d"//我的寻车

#define FBAUTO_FINDCAR_PUBLISH @"http://fbautotest.fblife.com/index.php?c=interface&a=addxunche"//添加寻车信息

#define FBAUTO_FINDCAR_SINGLE @"http://fbautotest.fblife.com/index.php?c=interface&a=getsinglexunche&xid=%@&uid=%@"//单个寻车信息

#define FBAUTO_FINDCAR_EDIT @"http://fbautotest.fblife.com/index.php?c=interface&a=editxunche"//编辑

#define FBAUTO_FINDCAR_DELETE @"http://fbautotest.fblife.com/index.php?c=interface&a=delxunche&authkey=%@&xid=%@"//删除寻车信息

#define FBAUTO_FINDCAR_REFRESH @"http://fbautotest.fblife.com/index.php?c=interface&a=flushxunche&xid=%@&authkey=%@" //刷新寻车

//收藏API============

#define FBAUTO_COLLECTION @"http://fbautotest.fblife.com/index.php?c=interface&a=addshoucang&authkey=%@&car=%@&stype=%d&sid=%@" //添加收藏

#define FBAUTO_MYMARKCAR @"http://fbautotest.fblife.com/index.php?c=interface&a=getshoucang&authkey=%@&page=%d&ps=%d"//我的收藏 获取收藏列表

#define FBAUTO_DELMYMARKCAR @"http://fbautotest.fblife.com/index.php?c=interface&a=delshoucang&authkey=%@&sids=%@"//删除我的收藏  sids为需要删除的id 多个用逗号隔开


// 聊天相关接口========

#define FBAUTO_CHAT_TALK_PIC @"http://fbautotest.fblife.com/index.php?c=interface&a=talkpic"//聊天发送图片
#define FBAUTO_CHAT_TALK_VOICE @"http://fbautotest.fblife.com/index.php?c=interface&a=talkvoice"//聊天发送语音

#define FBAUTO_CHAT_OFFLINE @"http://fbautotest.fblife.com/index.php?c=interface&a=pushmsg&uid=%@&optype=%@&fromuid=%@&fromphone=%@"//离线消息通知服务端

// 分享相关接口========
#define FBAUTO_SHARE_CAR_SOURCE @"http://fbautotest.fblife.com/index.php?c=web&a=singleCheyuan&cid=%@"//车源分享
#define FBAUTO_SHARE_CAR_FIND @"http://fbautotest.fblife.com/index.php?c=web&a=singleXunche&xid=%@" //寻车分享

// 吐槽 ================

#define FBATUO_TUCAO_LIST @"http://fbautotest.fblife.com/index.php?c=interface&a=getarticle&page=%d&ps=%d&authkey=%@"//吐槽列表

#define FBATUO_TUCAO_DETAIL @"http://fbautotest.fblife.com/index.php?c=interface&a=articledetail&artid=%@&ps=%d"//吐槽详情

#define FBAUTO_TUCAO_UPLOAD_IMAGE @"http://fbautotest.fblife.com/index.php?c=interface&a=addarticlepic"//吐槽发布图片

#define FBAUTO_TUCAO_PUBLISH @"http://fbautotest.fblife.com/index.php?c=interface&a=addarticle&authkey=%@&content=%@&color=%d&photo=%@"//吐槽发布

#define FBATUO_TUCAO_CommentList @"http://fbautotest.fblife.com/index.php?c=interface&a=getcomment&art_uid=%@&ctype=%@&page=%d&ps=%d"//吐槽详情 评论列表

#define FBAUTO_TUCAO_ZAN @"http://fbautotest.fblife.com/index.php?c=interface&a=dianzan&authkey=%@&artid=%@"//点赞

#define FBAUTO_TUCAO_Comment @"http://fbautotest.fblife.com/index.php?c=interface&a=addcomment&authkey=%@&content=%@&art_uid=%@&ctype=%@"//发布评论

//留言列表

#define FBAUTO_LIUYAN_LIST @"http://fbautotest.fblife.com/index.php?c=interface&a=getcomment&art_uid=%@&ctype=%d&page=%d&ps=%d"//art_uid:吐槽信息或者商家的id ctype:被评论信息的类型( 1:吐槽信息   2:商家 )
//发布留言

#define FBAUTO_LIUYAN_ADD @"http://fbautotest.fblife.com/index.php?c=interface&a=addcomment&authkey=%@&content=%@&art_uid=%@&ctype=%d" //ctype:被评论信息的类型(1:吐槽信息 2:商家)

//加关注

#define FBAUTO_ADD_CONCERN @"http://fbautotest.fblife.com/index.php?c=interface&a=addfocus&authkey=%@&buddyid=%@"

//发布举报

#define FBAUTO_ADD_JUBAO @"http://fbautotest.fblife.com/index.php?c=interface&a=addjubao&authkey=%@&cid=%@&type=%@&describe=%@&phone=%@"

//获取初始配置数据

#define FBAUTO_GET_INIT_PEIZHI @"http://fbautotest.fblife.com/index.php?c=interface&a=getinipz&uptime="//初始数据的更新时间为空

//配置更新时间
#define FBAUTO_GET_PEIZHI_UPDATE_DATELINE @"http://fbautotest.fblife.com/index.php?c=interface&a=getupdate&upfrom=peizhidata"

//配置数据增量更新
#define FBAUTO_GET_PEIZHI_NEW @"http://fbautotest.fblife.com/index.php?c=interface&a=getpeizhi&fromtime=%@&endtime=%@"

#endif

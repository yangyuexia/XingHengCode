/*!
 @header Constant.h
 @abstract 记录所有的常量
 @author .
 @version 1.00 2015/03/06  (1.00)
 */


#ifndef quanzhi_Constant_h
#define quanzhi_Constant_h

#define APPDelegate     ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define LOGIN           [QWUserDefault getBoolBy:APP_LOGIN_STATUS]
#define APP_VOICE_NOTIFICATION          @"APP_VOICE_NOTIFICATION"                               //新消息提醒声音
#define APP_VIBRATION_NOTIFICATION      @"APP_VIBRATION_NOTIFICATION"                           //新消息提醒震动
#define APP_QUESTIONPUSH_NOTIFICATION   @"APP_QUESTIONPUSH_NOTIFICATION"                        //新问题消息推送

#define KICK_OFF                        @"KICK_OFF"
#define SERVER_TIME                     @"SERVER_TIME"
#define AES_KEY                         @"Ao6IFeRFTsXuaD681snWCk"

#define SYSTEMHAVENEWMESSAGE            @"SYSTEMHAVENEWMESSAGE"
#define FIRSTINSTALL                    @"FIRSTINSTALL"
#define PRIVACYPOLICY                    @"XINGHENGPRIVACYPOLICY"

#define ISAUTOLOGIN                     @"ISAUTOLOGIN"
#define ISLOGINACCOUNTLIST              @"ISLOGINACCOUNTLIST"

#define BLUETOOTHUUIDSTRING       @"BLUETOOTHUUIDSTRING"
#define BLETONGXUNCONFIGURE       @"BLETONGXUNCONFIGURE"

#define ONLYONCELOCATION                @"YINIUONLYONCELOCATION"
#define APPLAUNCHIMAGE                  @"APPLAUNCHIMAGE"

#define zwx_dispatch_sync_main_safe(block){\
if ([NSThread isMainThread]) {\
block();\
}else{\
dispatch_sync(dispatch_get_main_queue(), block);\
}\
}\

//Method
#define NoNullStr(x)        (  ( x && (![x isEqual:[NSNull null]]) ) ? x : @"" )
//panadd end
/*****************************************************************************************************/

#define IMG_VIEW(x)         [[UIImageView alloc] initWithImage:[UIImage imageNamed:x]]

#define EmotionItemPattern          @"\\[\\w{2}\\]"
#define PlaceHolder                 @"[0|]"
#define kHyperlinkKey               @"khyperlinkkey"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X [[QWGlobalManager sharedInstance] isIphoneX]

/**
 弹框时间
 */
#define DURATION_SHORT                0.8f
#define DURATION_LONG                 1.5f

#define WRITE_RESOURCES @"/write-resources"
#define OFFLINE_RESOURCES @"/offline-resources"
#define PLUG_IN_RESOURCES @"/plug-in-resources"

#endif

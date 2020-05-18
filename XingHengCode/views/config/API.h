/*!
 @header API.h
 @abstract 所有接口地址及相关常量
 @author .
 @version 1.00 2017/01/01  (1.00)
 */


#ifndef APP_API_h
#define APP_API_h

#import "QWGlobalManager.h"

/**************************************************************************************
 *                                打包前注意切换环境                                     *
 *************************************************************************************/

//生产环境
//#define YINIU_BASE_URL                         @"http://180.76.118.239:82/hwma/"

#define YINIU_BASE_URL                         @"http://xh.sanzhou.net.cn/hwma/"


/**************************************************************************************
 *                                打包前注意切换环境                                    *
 *************************************************************************************/

#define APP_VERSION                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define DEVICE_IDD   [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define APP_UPDATE_AFTER_THREE_DAYS @"App_update_three_days"
#define APP_LAST_TIMESTAMP          @"App_last_timestamp"
#define APP_LAST_SYSTEM_VERSION     @"App_last_systemVersion"

/**************************** 接口 ****************************/

#define LoginInfo                           @"login/info"                           //登录
#define RegionInfo                          @"region/info"                          //查询地域信息
#define CtmInfo                             @"ctm/info"                             //查询个人信息
#define CtmRegister                         @"ctm/register"                         //注册
#define CtmActivate                         @"ctm/activate"                         //激活注册用户
#define CtmForgetPwdCheck                   @"ctm/forgetPwdCheck"                   //检测用户信息（忘记密码）
#define CtmChangePwd                        @"ctm/changePwd"                        //修改忘记密码
#define CtmUpdate                           @"ctm/update"                           //修改个人信息
#define CtmChangePTo                        @"ctm/changePTo"                        //修改密码
#define SysVersion                          @"edition/version"                       //版本升级
#define DeviceInit                          @"ctm/jpush"                            //初始化设备信息
#define CtmSubList                          @"ctm/subList"                          //子账号列表
#define CtmSubUpdate                        @"ctm/subUpdate"                        //子账号修改
#define CtmSubAdd                           @"ctm/subAdd"                           //子账号新增
#define CtmSubChangePwd                     @"ctm/subChangePwd"                     //子账号修改密码
#define CtmSubDelete                        @"ctm/subDelete"                        //子账号删除
#define EqpInfo                             @"eqp/info"                             //查询电池信息
#define EqpAbnormal                         @"eqp/abnormal"                         //故障数据列表
#define EqpNormal                           @"eqp/normal"                           //正常数据列表
#define DrsInfo                             @"drs/info"                             //电池故障诊断
#define EqpDetectionResult                  @"eqp/detectionResult"                  //检测结果提交
#define EqpBand                             @"eqp/band"                             //新旧电池绑定
#define CtmHasAccount                       @"ctm/hasAccount"                       //验证账号是否存在




/**************************** 接口 ****************************/

#endif

/*!
 @header Notification.h
 @abstract 所有通知常量
 @author .
 @version 1.00 2015/01/01  (1.00)
 */


#ifndef APP_Notification_h
#define APP_Notification_h

typedef NS_ENUM(NSInteger, Enum_Notification_Type)  {
    //用户
    NotifQuitOut = 1,                         //用户退出
    NotifLoginSuccess,                         //登录成功
    NotifFootBallSp,                            //竞彩足球赔率
    NotifBasketBallSp,                            //竞彩篮球赔率
    NotifLiveMiniCardAttention,                  //竞彩篮球赔率
    NotifIndexShowRedPacket,
    NotifStopIndexAnnounceTimer,
    NotifDeleteShareOrder,
    
    //抢登
    NotifCloseLiveRoom,
    NotifKickOff,
    NotifTokenValide,                       //token失效
    NotifMessageBoxShowRedDot,                 //消息盒子显示小红点

    //网络
    NotifNetworkDisconnect,                 //网络断线
    NotifNetworkReconnect,                  //网络重连
    NotifNetworkReachabilityChanged,
    
    NotifLocationNeedReload,                //需要重新刷新地址
    
    //支付
    NotifPayStatusUnknown,          //支付 状态未知，支付失败1 阿里 2 微信
    NotifPayStatusFinish,           //支付 成功
    NotifPayStatusCancle,
    
    NotifDeleteMasterPlanComment,
    NotifRefreshPlanComment,
    
    //系统
    NotifAppCheckVersion,
    Notifaaaaaaa,
    NotifrefreshHomePage,
    NotifRefreshAppayService,
    NotifIndexShowNotOpen,
    NotifRefreshShopCartData,
    NotifClassifyPageJump,
    NotifClassifyKindJump,
    NotifClassifyBrandJump,
    NotifRefreshCartNum,
    NotifFirseIndexUpdateData,
    NotimessageIMTabelUpdate,               //跟新Imtable View
    NotifChangeChildScrollenabled,
    NotifChangeParentsScrollenabled,
    NotifSwitchCity,
    NotifRefreshFoodOrder,
    NotifRefreshShopCartRecommendData,
    
    //定时器
    NotiCountDownPhoneLogin,                    //手机号登录
    NotiCountDownRegister,                      //注册
    NotiCountDownResetPassword,                 //重置密码
    NotiCountDownMobileAuth,                    //重置密码
    NotiCountDownBindBank,                      //重置密码
    NotiResetPwdTimerStop,

    //app进出后台
    NotifAppDidEnterBackground,             //到后台
    NotifAppDidBecomeActive,
    NotifAppWillEnterForeground,            //前台
        
    NotifAliPayTimerEnd,                    //支付宝支付倒计时
    NotifSendRedPacketView,
    NotifScoreImme,                          //即时比分
    NotifRefreshHomePage                          //登录后刷新首页

};
#endif


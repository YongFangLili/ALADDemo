//
//  ALADDefineHeader.h
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/2/22.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#ifndef ALADDefineHeader_h
#define ALADDefineHeader_h

/**默认app至于后台1分钟显示广告*/
#define kALAD_DefaultTimeBackgroud  60.0
/**广告默认持续3s*/
#define kALAD_DefaultTimeContineAd  3
/** 偏好设置 */
#define kALAD_UserDefault [NSUserDefaults standardUserDefaults]
/** 屏幕宽 */
#define kALAD_PHONE_WIDTH  [[UIScreen mainScreen] bounds].size.width
/** 屏幕高 */
#define kALAD_PHONE_HEIGH  ([UIApplication sharedApplication].statusBarFrame.size.height > 20 ? \
(([[UIScreen mainScreen] bounds].size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20)) : \
[[UIScreen mainScreen] bounds].size.height)
#define kALAD_CachPath    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)\
objectAtIndex:0]
/*** RGB颜色 */
#define kALAD_RGBACOLOR(R,G,B,a) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(a)]
/** 宽度比 */
#define kALAD_ScreenScaleWidth   [UIScreen mainScreen].bounds.size.width/375.0
/** 高度比 */
#define kALAD_ScreenScaleHeight  ([UIScreen mainScreen].bounds.size.height/667.0==1 ? \
1:[UIScreen mainScreen].bounds.size.height/667.0)

#endif /* ALADDefineHeader_h */

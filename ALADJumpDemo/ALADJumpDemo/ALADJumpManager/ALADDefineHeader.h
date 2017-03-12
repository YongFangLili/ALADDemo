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
#define kDefaultTimeBackgroud  90.0

//**广告默认持续3s*/
#define kDefaultTimeContineAd  3
#define kUserDefault [NSUserDefaults standardUserDefaults]
#define kCachPath    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)\
objectAtIndex:0]
#define PHONE_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGH  ([UIApplication sharedApplication].statusBarFrame.size.height > 20 ? \
(([[UIScreen mainScreen] bounds].size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20)) : \
[[UIScreen mainScreen] bounds].size.height)

/*** 广告路径 */
#define kadImagePath [kCachPath stringByAppendingPathComponent:@"AD"]
/*** 保存广告图片的文件名 */
#define kAdImageDataName @"adImageDataName"
/*** 保存广告基本信息文件名 */
#define kAdInfoDataName  @"adInfoDataName"

/// RGB颜色.
#define RGBACOLOR(R,G,B,a) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(a)]
#define kScreenScaleWidth   [UIScreen mainScreen].bounds.size.width/375.0
#define kScreenScaleHeight  ([UIScreen mainScreen].bounds.size.height/667.0==1 ? \
1:[UIScreen mainScreen].bounds.size.height/667.0)
#define PHONE_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGH  ([UIApplication sharedApplication].statusBarFrame.size.height > 20 ? \
(([[UIScreen mainScreen] bounds].size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20)) : \
[[UIScreen mainScreen] bounds].size.height)

#endif /* ALADDefineHeader_h */

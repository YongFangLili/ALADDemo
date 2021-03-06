//
//  ADvertisementManager.h
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/2/22.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALADJumpHeader.h"

@interface ADvertisementManager : NSObject


/**
 * @brief 广告manager
 */
@property (nonatomic, strong) ALADJumpManager *adManager;

/**
 * @brief 广告单例
 * @return 广告
 */
+ (instancetype)sharedADManager;

/**
 * @brief 显示广告
 */
+ (void)showAD;


/**
 * @brief 后台启动APP显示广告
 */
+ (void)showADFromBackGround;

/**
 * @brief 保存app进入后台时的时间
 */
+ (void)saveCurrentDataWhenAPPBackInGround;





@end

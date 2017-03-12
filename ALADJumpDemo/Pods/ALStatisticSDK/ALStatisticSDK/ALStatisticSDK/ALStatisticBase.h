//
//  ALStatisticBase.h
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 触发方式
 */
typedef enum StatisticTriggerType {
    /**
     *  左击.
     */
    eTriggerTypeLeftClick = 1,
    /**
     *  上滑动.
     */
    eTriggerTypeUpScroll = 3,
    /**
     *  下滑动.
     */
    eTriggerTypeDownScroll = 4,
    /**
     *  左滑动.
     */
    eTriggerTypeLeftScroll = 5,
    /**
     *  右滑动.
     */
    eTriggerTypeRightScroll = 6,
    /**
     *  上拉.
     */
    eTriggerTypeUpLoad = 7,
    /**
     *  下拉.
     */
    eTriggerTypeDownLoad = 8,
    /**
     *  页面打开.
     */
    eTriggerTypeEnterV = 9,
    /**
     *  页面关闭.
     */
    eTriggerTypeExitV = 10,
    /**
     *  压栈出栈页面跳转.
     */
    eTriggerTypeNavPushV = 15,
    
}StatisticTriggerType;


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ALStatistic.h"
#import <objc/runtime.h>
#import <objc/message.h>

/// 统计用 获取视图上文本信息.
@interface UIView (statistic)

/**
 *  统计用 获取视图上文本信息.
 *
 *  @return value
 */
- (NSString *)subViewsTextForStatistics;

@end


@interface ALStatisticBase : NSObject

/**
 *  统计项.
 *
 *  @return value
 */
+ (NSDictionary *)statisticsBase;

/**
 *  hudview.
 *
 *  @return hudview
 */
+ (MBProgressHUD *)hudview;

@end

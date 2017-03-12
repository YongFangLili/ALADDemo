//
//  ALStatistic.h
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatistic.h
 * @brief       用于埋点.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-11-08
 *
 */

#import <Foundation/Foundation.h>
#import "Aspects.h"
#import "ALStatisticBase.h"
#import "AlStatisticConst.h"
#import "ALStatisticProtocal.h"

typedef NSString *(^GetCurVCBlock)();

@interface ALStatistic : NSObject

@property (nonatomic, copy) GetCurVCBlock getCurVCBlock;

/**
 *  单例
 *
 *  @return value
 */
+ (instancetype)sharedStatistic;

/**
 *  初始化统计
 *
 *  @param delegate 代理
 */
- (void)setupStatistics:(id)delegate;

/**
 *  获取当前页面
 *
 *  @return 当前页面
 */
- (NSString *)getCurVC;

/**
 *  统计从url跳回app
 *
 *  @param url 统计项url
 */
+ (void)openURL:(NSURL *)url;

/**
 *  开启打印日至
 */
- (void)openLog;

/**
 *  上传埋点数据.
 *
 *  @param dicParam 埋点数据参数
 */
- (void)startUploadStatic:(NSDictionary *)dicParam;



@end

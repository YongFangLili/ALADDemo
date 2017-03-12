//
//  ALStatisticBase+UIControl.h
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticBase.h"

/// 用于配置control统计项.
@interface ALStatisticBase (UIControl)

/**
 *  UIControl统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsUIControlBase;

@end

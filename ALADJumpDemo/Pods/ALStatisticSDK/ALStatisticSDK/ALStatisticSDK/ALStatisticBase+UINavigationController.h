//
//  ALStatisticBase+UINavigationController.h
//  AllinmdIPhone
//
//  Created by ZhangKaiChao on 2017/2/5.
//  Copyright © 2017年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatistic.h"

@interface ALStatisticBase (UINavigationController)

/**
 *  nav统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsUINavVCBase;

@end

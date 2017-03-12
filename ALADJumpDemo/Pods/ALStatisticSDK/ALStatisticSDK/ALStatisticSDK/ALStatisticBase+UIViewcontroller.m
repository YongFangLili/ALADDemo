//
//  ALStatisticBase+UIViewcontroller.m
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticBase+UIViewcontroller.h"

@implementation ALStatisticBase (UIViewcontroller)

/**
 *  vc统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsVCBase {
    
    return @{
             // vc
             kUIViewController:@[
                     
                     @{
                         kEventSelectorOption: [@(AspectPositionBefore) stringValue],
                         kEventSelector: @"viewWillAppear:",
                         kEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                             
                             NSString * className = NSStringFromClass([[aspectInfo instance] class]);
                             if([className isKindOfClass:[UINavigationController class]] == NO) {
                                 NSString * triggerName = [NSString stringWithFormat:@"path=%@,method=viewWillAppear:",className];
                                 NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                       [NSString stringWithFormat:@"%zd",eTriggerTypeEnterV],kTriggerType,
                                                                       triggerName,kTriggerName,
                                                                       @"",kActionId,
                                                                       className,kSrcLocation,
                                                                       className,kToLocation,
                                                                       @"",kLocationId,
                                                                       @"",kRefType,
                                                                       @"",kRefId,nil];
                                 [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];;
                             }
                         }
                         },
                     
                     @{
                         kEventSelectorOption: [@(AspectPositionBefore) stringValue],
                         kEventSelector: @"viewWillDisappear:",
                         kEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                             
                             NSString * className = NSStringFromClass([[aspectInfo instance] class]);
                             if([className isKindOfClass:[UINavigationController class]] == NO) {
                                 NSString * triggerName = [NSString stringWithFormat:@"path=%@,method=viewWillDisappear:",className];
                                 NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                       [NSString stringWithFormat:@"%zd",eTriggerTypeExitV],kTriggerType,
                                                                       triggerName,kTriggerName,
                                                                       @"",kActionId,
                                                                       className,kSrcLocation,
                                                                       className,kToLocation,
                                                                       @"",kLocationId,
                                                                       @"",kRefType,
                                                                       @"",kRefId,nil];
                                 [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];
                             }
                         }
                         }
                     ]
             
             };
}

@end

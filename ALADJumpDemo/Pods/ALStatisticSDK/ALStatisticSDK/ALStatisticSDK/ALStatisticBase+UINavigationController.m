//
//  ALStatisticBase+UINavigationController.m
//  AllinmdIPhone
//
//  Created by ZhangKaiChao on 2017/2/5.
//  Copyright © 2017年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticBase+UINavigationController.h"

@implementation ALStatisticBase (UINavigationController)

/**
 *  nav统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsUINavVCBase {
    
    return @{
             // vc
             kUINavigationController:@[
                     
                     @{
                         kEventSelectorOption: [@(AspectPositionBefore) stringValue],
                         kEventSelector: @"pushViewController:animated:",
                         kEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                             
                             UIViewController * toVC = nil;
                             NSArray * arrayArguments = [aspectInfo arguments];
                             if(arrayArguments && arrayArguments.count) {
                                 toVC = arrayArguments[0];
                             }
                             //NSString * className = NSStringFromClass([[aspectInfo instance] class]);
                             NSString * triggerName = [NSString stringWithFormat:@"path=%@,method=pushViewController:animated:",
                                                       [[ALStatistic sharedStatistic] getCurVC]];
                             
                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSString stringWithFormat:@"%zd",eTriggerTypeNavPushV],kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   [[ALStatistic sharedStatistic] getCurVC],kSrcLocation,
                                                                   NSStringFromClass([toVC class]),kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];
                             
                         }
                         },
                     
                     @{
                         kEventSelectorOption: [@(AspectPositionBefore) stringValue],
                         kEventSelector: @"popViewControllerAnimated:",
                         kEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                             
                             UIViewController * toVC = nil;
                             NSArray * arrayVCS = [[aspectInfo instance] viewControllers];
                             if(arrayVCS && arrayVCS.count > 1) {
                                 toVC = arrayVCS[arrayVCS.count - 2];
                             }
                             //NSString * className = NSStringFromClass([[aspectInfo instance] class]);
                             NSString * triggerName = [NSString stringWithFormat:@"path=%@,method=popViewControllerAnimated:",
                                                       [[ALStatistic sharedStatistic] getCurVC]];
                             
                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSString stringWithFormat:@"%zd",eTriggerTypeNavPushV],kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   [[ALStatistic sharedStatistic] getCurVC],kSrcLocation,
                                                                   NSStringFromClass([toVC class]),kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];
                             
                         }
                         },
                     
                     @{
                         kEventSelectorOption: [@(AspectPositionBefore) stringValue],
                         kEventSelector: @"popToViewController:animated:",
                         kEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                             
                             UIViewController * toVC = nil;
                             NSArray * arrayArguments = [aspectInfo arguments];
                             if(arrayArguments && arrayArguments.count) {
                                 toVC = arrayArguments[0];
                             }
                             //NSString * className = NSStringFromClass([[aspectInfo instance] class]);
                             NSString * triggerName = [NSString stringWithFormat:@"path=%@,method=popToViewController:animated:",
                                                       [[ALStatistic sharedStatistic] getCurVC]];
                             
                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSString stringWithFormat:@"%zd",eTriggerTypeNavPushV],kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   [[ALStatistic sharedStatistic] getCurVC],kSrcLocation,
                                                                   NSStringFromClass([toVC class]),kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];
                             
                         }
                         },
                     
                     @{
                         kEventSelectorOption: [@(AspectPositionBefore) stringValue],
                         kEventSelector: @"popToRootViewControllerAnimated:",
                         kEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                             
                             UIViewController * toVC = nil;
                             NSArray * arrayVCS = [[aspectInfo instance] viewControllers];
                             if(arrayVCS && arrayVCS.count) {
                                 toVC = arrayVCS[0];
                             }
                             //NSString * className = NSStringFromClass([[aspectInfo instance] class]);
                             NSString * triggerName = [NSString stringWithFormat:@"path=%@,method=popToRootViewControllerAnimated:",
                                                       [[ALStatistic sharedStatistic] getCurVC]];
                             
                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSString stringWithFormat:@"%zd",eTriggerTypeNavPushV],kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   [[ALStatistic sharedStatistic] getCurVC],kSrcLocation,
                                                                   NSStringFromClass([toVC class]),kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];
                             
                         }
                         }
                     
                     ]
             
             };
}


@end

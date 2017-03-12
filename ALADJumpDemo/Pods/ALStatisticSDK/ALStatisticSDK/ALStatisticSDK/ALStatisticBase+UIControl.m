//
//  ALStatisticBase+UIControl.m
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticBase+UIControl.h"

@implementation ALStatisticBase (UIControl)

/**
 *  UIControl统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsUIControlBase {
    
    return @{
             
             kUIControl:@[
                     
                     @{
                         kEventSelectorOption: [@(AspectPositionBefore) stringValue],
                         kEventSelector: @"sendAction:to:forEvent:",
                         kEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                             
                             NSString * selName = nil;
                             id target;
                             if([aspectInfo arguments] && [[aspectInfo arguments] count]) {
                                 selName =  [aspectInfo arguments][0];
                             }
                             if ([[aspectInfo arguments] count] > 1) {
                                 target = [aspectInfo arguments][1];
                             }
                             
                             UIControl * sender = (UIControl *)[aspectInfo instance];
                             
                             NSString * triggerName = @"";

                             triggerName = [NSString stringWithFormat:@"path=%@,method=%@,flag=%zd",
                                            [[ALStatistic sharedStatistic] getCurVC],
                                            selName,
                                            sender.tag];
                             
                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSString stringWithFormat:@"%zd",eTriggerTypeLeftClick],kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   [[ALStatistic sharedStatistic] getCurVC],kSrcLocation,
                                                                   [[ALStatistic sharedStatistic] getCurVC],kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             
                             if([target conformsToProtocol:@protocol(ALStatisticUIControlProtocal)] &&
                                [target respondsToSelector:@selector(statisticUIControlDic:)]) {
                                 
                                 NSDictionary * dic =
                                 [NSDictionary dictionaryWithObjectsAndKeys:selName,kEventSelector,sender,kEventSender, nil];
                                 
                                 NSDictionary * tDic =
                                 [target performSelector:@selector(statisticUIControlDic:) withObject:dic];

                                 dicStatistic[kTriggerName] = triggerName;
                                 dicStatistic[kActionId] = tDic[kActionId];
                                 dicStatistic[kSrcLocation] = tDic[kSrcLocation];
                                 dicStatistic[kToLocation] = tDic[kToLocation];
                                 dicStatistic[kLocationId] = tDic[kLocationId];
                                 dicStatistic[kRefType] = tDic[kRefType];
                                 dicStatistic[kRefId] = tDic[kRefId];
                             }
                             
                             [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];
                             
                         }
                         }
                     
                     ]
             };
}

@end

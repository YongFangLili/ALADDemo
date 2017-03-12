//
//  ALStatisticBase+RefreshView.m
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticBase+RefreshView.h"

@implementation ALStatisticBase (RefreshView)

/**
 *  列表上下拉统计项
 *
 *  @return value
 */
+ (NSDictionary *)statisticsListViewDragRefreshBase {
    return @{
             kMJRefreshComponent:@[
                     
                     @{
                         kEventSelectorOption: [@(AspectPositionBefore) stringValue],
                         kEventSelector: @"beginRefreshing",
                         kEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                             
                             id sender = [aspectInfo instance];

                             NSString * triggerType = @"";
                             NSString * className = NSStringFromClass([sender class]);
                             if ([className rangeOfString:@"Head"].location ||
                                 [className rangeOfString:@"head"].location) {
                                 // 下拉
                                 triggerType = [NSString stringWithFormat:@"%zd",eTriggerTypeDownLoad];
                             }else if ([className rangeOfString:@"Foot"].location ||
                                       [className rangeOfString:@"foot"].location) {
                                 // 上拉
                                 triggerType = [NSString stringWithFormat:@"%zd",eTriggerTypeUpLoad];
                             }
                             
                             NSString * triggerName = [NSString stringWithFormat:@"path=%@,method=beginRefreshing",
                                                       [[ALStatistic sharedStatistic] getCurVC]];
                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   triggerType,kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   [[ALStatistic sharedStatistic] getCurVC],kSrcLocation,
                                                                   [[ALStatistic sharedStatistic] getCurVC],kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             
                             if([sender conformsToProtocol:@protocol(ALStatisticRefreshViewProtocal)] &&
                                [sender respondsToSelector:@selector(statisticRefreshViewDic:)]) {
                                 
                                 NSDictionary * dic =
                                 [NSDictionary dictionaryWithObjectsAndKeys:@"beginRefreshing",kEventSelector,sender,kEventSender, nil];
                                 
                                 NSDictionary * tDic =
                                 [sender performSelector:@selector(statisticRefreshViewDic:) withObject:dic];
                                 
                                 dicStatistic[kTriggerName] = triggerName;
                                 dicStatistic[kActionId] = tDic[kActionId];
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

//
//  ALStatistic.m
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatistic.h"
#import "ALStatisticBase+UIViewcontroller.h"
#import "ALStatisticBase+UItableView.h"
#import "ALStatisticBase+UICollectionView.h"
#import "ALStatisticBase+UIControl.h"
#import "ALStatisticBase+RefreshView.h"
#import "ALStatisticBase+UINavigationController.h"

@interface ALStatistic ()
@property (nonatomic,weak) id delegate;
@property (nonatomic,assign) BOOL openlog;
@end


@implementation ALStatistic

/**
 *  单例
 *
 *  @return value
 */
+ (instancetype)sharedStatistic {
    @synchronized(self)
    {
        static ALStatistic * sharedStatistics = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedStatistics = [[super allocWithZone:NULL] init];
        });
        return sharedStatistics;
    }
}

/**
 *  开启打印日至
 */
- (void)openLog {
    _openlog = YES;
}

/**
 *  初始化统计
 *
 *  @param delegate 代理
 */
- (void)setupStatistics:(id)delegate {
    
    _delegate = delegate;
    
    /// 启动.
    NSString * triggerName = @"method=setupStatistics:";
    
    NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%zd",eTriggerTypeEnterV],kTriggerType,
                                          triggerName,kTriggerName,
                                          @"",kActionId,
                                          NSStringFromClass([delegate class]),kSrcLocation,
                                          NSStringFromClass([delegate class]),kToLocation,
                                          @"",kLocationId,
                                          @"",kRefType,
                                          @"",kRefId,nil];
    [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];
    
    [self setupWithAllInstanceConfiguration:@[
                                              [ALStatisticBase statisticsVCBase],
                                              [ALStatisticBase statisticsListViewDragRefreshBase],
                                              [ALStatisticBase statisticsUIControlBase],
                                              [ALStatisticBase statisticsUITableViewBase],
                                              [ALStatisticBase statisticsUICollectionViewBase],
                                              [ALStatisticBase statisticsUINavVCBase]
                                              ]];
}

/**
 *  获取当前页面
 *
 */
- (NSString *)getCurVC {

    if(self.getCurVCBlock) return self.getCurVCBlock();
    return @"";
}

/**
 *  开始统计所有instance
 *
 *  @param arrayConfigs 统计项
 */
- (void)setupWithAllInstanceConfiguration:(NSArray *)arrayConfigs {
    
    for(NSDictionary * configs in arrayConfigs) {
        for (NSString *className in configs) {
            Class class = NSClassFromString(className);
            for (NSDictionary *event in configs[className]) {
                SEL selector = NSSelectorFromString(event[kEventSelector]);
                id block = event[kEventHandlerBlock];
                [class aspect_hookSelector:selector
                               withOptions:[event[kEventSelectorOption] integerValue]
                                usingBlock:block
                                     error:NULL];
            }
        }
    }
}

/**
 *  统计从url跳回app
 *
 *  @param url 统计项url
 */
+ (void)openURL:(NSURL *)url {
    
    NSString * triggerType = [NSString stringWithFormat:@"%zd",eTriggerTypeEnterV];
    NSString * triggerName = [NSString stringWithFormat:@"method=application:openURL:"];
    
    NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          triggerType,kTriggerType,
                                          triggerName,kTriggerName,
                                          @"",kActionId,
                                          [url absoluteString],kSrcLocation,
                                          @"",kToLocation,
                                          @"",kLocationId,
                                          @"",kRefType,
                                          @"",kRefId,nil];
    
    [[ALStatistic sharedStatistic] startUploadStatic:dicStatistic];
}

/**
 *  上传埋点数据.
 *
 *  @param dicParam 埋点数据参数
 */
- (void)startUploadStatic:(NSDictionary *)dicParam {
    
#if DEBUG
    if(_openlog){
        NSString * message = [NSString stringWithFormat:
                              @"triggerType:%@,triggerName:%@,actionId:%@,srcLocation:%@,\n"
                              "toLocation:%@,locationId:%@,refType:%@,refId:%@",
                              dicParam[kTriggerType],dicParam[kTriggerName],dicParam[kActionId],
                              dicParam[kSrcLocation],dicParam[kToLocation],dicParam[kLocationId],
                              dicParam[kRefType],dicParam[kRefId]
                              ];
        
        [ALStatisticBase hudview].detailsLabelText = message;
        [[ALStatisticBase hudview] show:YES];
        [[ALStatisticBase hudview] hide:YES afterDelay:1.5];
    }
#endif
    
    if([_delegate conformsToProtocol:@protocol(ALStatisticUploadProtocal)] &&
       [_delegate respondsToSelector:@selector(uploadStatistics:)]) {
        [_delegate performSelector:@selector(uploadStatistics:) withObject:dicParam];
    }
}

@end

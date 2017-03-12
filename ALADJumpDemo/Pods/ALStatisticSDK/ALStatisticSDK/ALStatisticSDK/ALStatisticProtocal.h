//
//  ALStatisticProtocal.h
//  ALStatistics
//
//  Created by ZhangKaiChao on 16/7/4.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatisticProtocal.h
 * @brief       用于统计类需要遵守的协议.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-07-04
 *
 */

#import <Foundation/Foundation.h>
/// 上传埋点数据.
@protocol ALStatisticUploadProtocal <NSObject>
@optional
/**
 *  上传埋点数据.
 *
 *  @param dicParam 埋点数据参数.
 */
- (void)uploadStatistics:(NSDictionary *)dicParam;
@end



/// 统计UIControl类需要遵守的协议.
@protocol ALStatisticUIControlProtocal <NSObject>
@optional
/**
 *  统计UIControl类需要遵守的协议
 *
 *  @param dicParam 方法名 + 执行事件的对象 的参数
 *
 *  @return 业务统计数据组成的字典
 */
- (NSDictionary *)statisticUIControlDic:(NSDictionary *)dicParam;
@end


/// 统计UITableView类需要遵守的协议.
@protocol ALStatisticUITableViewProtocal <NSObject>
@optional
/**
 *  统计UITableView类需要遵守的协议
 *
 *  @param dicParam 方法名 + 执行事件的对象 + NSIndexPath... 的参数
 *
 *  @return 业务统计数据组成的字典
 */
- (NSDictionary *)statisticUITableViewDic:(NSDictionary *)dicParam;
@end


/// 统计UICollectionView类需要遵守的协议.
@protocol ALStatisticUICollectionViewProtocal <NSObject>
@optional
/**
 *  统计UICollectionView类需要遵守的协议
 *
 *  @param dicParam 方法名 + 执行事件的对象 + NSIndexPath... 的参数
 *
 *  @return 业务统计数据组成的字典
 */
- (NSDictionary *)statisticUICollectionViewDic:(NSDictionary *)dicParam;
@end

/// 统计上下拉刷新类需要遵守的协议.
@protocol ALStatisticRefreshViewProtocal <NSObject>
@optional
/**
 *  统计上下拉刷新类需要遵守的协议
 *
 *  @param dicParam 方法名 + 执行事件的对象 的参数
 *
 *  @return 业务统计数据组成的字典
 */
- (NSDictionary *)statisticRefreshViewDic:(NSDictionary *)dicParam;
@end



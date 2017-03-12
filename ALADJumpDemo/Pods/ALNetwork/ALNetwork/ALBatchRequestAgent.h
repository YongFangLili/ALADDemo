//
//  ALBatchRequestAgent.h
//  AllinmdSocial
//
//  Created by ZhangKaiChao on 16/7/15.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALBatchRequestAgent.h
 * @brief       管理组请求ALBatchRequest.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-07-15
 *
 */

#import <Foundation/Foundation.h>

/// 管理组请求.
@class ALBatchRequest;
@interface ALBatchRequestAgent : NSObject

/**
 *  单例
 *
 *  @return id
 */
+ (ALBatchRequestAgent *)sharedInstance;

/**
 *  添加组请求
 *
 *  @param request 组请求
 */
- (void)addBatchRequest:(ALBatchRequest *)request;

/**
 *  移除组请求
 *
 *  @param request 组请求
 */
- (void)removeBatchRequest:(ALBatchRequest *)request;

@end

//
//  ALNetworkAgent.h
//  ALmdProject
//
//  Created by ZhangKaiChao on 15/11/3.
//  Copyright © 2015年 Mac_Libin. All rights reserved.
//

/**
 * @file        ALNetworkAgent.h
 * @brief       请求管理.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2015-11-03
 *
 */

#import <Foundation/Foundation.h>
#import "ALBaseRequest.h"

/// 请求管理..
@interface ALNetworkAgent : NSObject

/**
 *  单例
 *
 *  @return value
 */
+ (ALNetworkAgent *)sharedInstance;

/**
 *  添加请求
 *
 *  @param request 请求
 */
- (void)addRequest:(ALBaseRequest *)request;

/**
 *  取消请求
 *
 *  @param request 请求
 */
- (void)cancelRequest:(ALBaseRequest *)request;

/**
 *  取消全部请求
 */
- (void)cancelAllRequests;

/**
 *  请求的url
 *
 *  @param request 请求
 *
 *  @return url
 */
- (NSString *)buildRequestUrl:(ALBaseRequest *)request;


@end

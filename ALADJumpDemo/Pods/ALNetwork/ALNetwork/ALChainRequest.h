//
//  ALChainRequest.h
//  AllinmdSocial
//
//  Created by ZhangKaiChao on 16/7/15.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALChainRequest.h
 * @brief       组请求＋组请求协议(有顺序).
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-07-15
 *
 */

#import <Foundation/Foundation.h>
#import "ALChainRequestAgent.h"
#import "ALBaseRequest.h"

@class ALChainRequest;
/// 组请求协议.
@protocol ALChainRequestDelegate <NSObject>

@optional
/**
 *  组请求都完成
 *
 *  @param chainRequest 组请求
 */
- (void)chainRequestFinished:(ALChainRequest *)chainRequest;

/**
 *  组请求失败
 *
 *  @param chainRequest 组请求
 *  @param request      失败的请求
 */
- (void)chainRequestFailed:(ALChainRequest *)chainRequest failedBaseRequest:(ALBaseRequest*)request;

@end








/**
 *  每个请求的回调
 *
 *  @param chainRequest 请求所在组
 *  @param baseRequest  单个请求
 */
typedef void (^ChainCallback)(ALChainRequest *chainRequest, ALBaseRequest *baseRequest);



/// 组请求.
@interface ALChainRequest : NSObject

/**
 *  代理
 */
@property (weak, nonatomic) id<ALChainRequestDelegate> delegate;

/**
 *  成功block
 */
@property (nonatomic, copy) void (^successCompletionBlock)(ALChainRequest *);

/**
 *  失败block
 */
@property (nonatomic, copy) void (^failureCompletionBlock)(ALChainRequest *, ALBaseRequest *);


/**
 *  开始（delegate）
 */
- (void)start;

/**
 *  停止
 */
- (void)stop;

/**
 *  开始（block）
 *
 *  @param success 成功block
 *  @param failure 失败block
 */
- (void)startWithCompletionBlockWithSuccess:(void (^)(ALChainRequest * chainRequest))success
                                    failure:(void (^)(ALChainRequest * chainRequest,
                                                      ALBaseRequest * baseRequest))failure;

/**
 *  设置组请求成功和失败block
 *
 *  @param success 组请求成功block
 *  @param failure 组请求失败block
 */
- (void)setCompletionBlockWithSuccess:(void (^)(ALChainRequest * chainRequest))success
                              failure:(void (^)(ALChainRequest * chainRequest,
                                                ALBaseRequest * baseRequest))failure;

/**
 *  把block置nil来打破循环引用
 */
- (void)clearCompletionBlock;

/**
 *  添加组请求
 *
 *  @param request  请求
 *  @param sccessCallback 成功回调
 *  @param failCallback 失败回调
 */
- (void)addRequest:(ALBaseRequest *)request
   successCallback:(ChainCallback)sccessCallback
      failCallback:(ChainCallback)failCallback;

/**
 *  请求数组
 *
 *  @return value
 */
- (NSArray *)requestArray;

@end

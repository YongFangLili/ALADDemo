//
//  ALBatchRequest.h
//  AllinmdSocial
//
//  Created by ZhangKaiChao on 16/7/15.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALBatchRequest.h
 * @brief       组请求+请求协议(无顺序).
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-07-15
 *
 */

#import <Foundation/Foundation.h>
#import "ALBaseRequest.h"
#import "ALBatchRequestAgent.h"

@class ALBatchRequest;
/// 组请求协议.
@protocol ALBatchRequestDelegate <NSObject>

@optional
/**
 *  成功
 *
 *  @param batchRequest 请求组
 */
- (void)batchRequestFinished:(ALBatchRequest *)batchRequest;

/**
 *  失败
 *
 *  @param batchRequest 请求组
 */
- (void)batchRequestFailed:(ALBatchRequest *)batchRequest;
@end


/**
 *  每个请求的回调
 *
 *  @param batchRequest 请求所在组
 *  @param baseRequest  单个请求
 */
typedef void (^BatchCallback)(ALBatchRequest *batchRequest, ALBaseRequest *baseRequest);


/// 组请求.
@interface ALBatchRequest : NSObject

/**
 *  多个请求
 */
@property (strong, nonatomic, readonly) NSMutableArray * requestArray;

/**
 *  代理
 */
@property (weak, nonatomic) id<ALBatchRequestDelegate> delegate;

/**
 *  成功
 */
@property (nonatomic, copy) void (^successCompletionBlock)(ALBatchRequest *);

/**
 *  失败
 */
@property (nonatomic, copy) void (^failureCompletionBlock)(ALBatchRequest *, ALBaseRequest *);

/**
 *  tag
 */
@property (nonatomic) NSInteger tag;

/**
 *  初始化
 *
 *  @param requestArray 一组请求
 *
 *  @return id
 */
- (id)initWithRequestArray:(NSArray *)requestArray;

/**
 *  开始请求
 */
- (void)start;

/**
 *  停止请求
 */
- (void)stop;

/// block回调

/**
 *  组请求开始（block）
 *
 *  @param success 组请求成功block
 *  @param failure 组请求失败block
 */
- (void)startWithCompletionBlockWithSuccess:(void (^)(ALBatchRequest * batchRequest))success
                                    failure:(void (^)(ALBatchRequest * batchRequest,
                                                      ALBaseRequest * baseRequest))failure;

/**
 *  设置组请求成功和失败block
 *
 *  @param success 组请求成功block
 *  @param failure 组请求失败block
 */
- (void)setCompletionBlockWithSuccess:(void (^)(ALBatchRequest * batchRequest))success
                              failure:(void (^)(ALBatchRequest * batchRequest,
                                                ALBaseRequest * baseRequest))failure;

/**
 *  把block置nil来打破循环引用
 */
- (void)clearCompletionBlock;


/**
 *  添加组请求
 *
 *  @param request  请求
 *  @param successCallback 成功回调
 *  @param failCallback 失败回调
 */
- (void)addRequest:(ALBaseRequest *)request
   successCallback:(void (^)(ALBaseRequest * baseRequest))successCallback
      failCallback:(void (^)(ALBaseRequest * baseRequest))failCallback;

/**
 *  请求数组
 *
 *  @return value
 */
- (NSArray *)requestArray;

@end

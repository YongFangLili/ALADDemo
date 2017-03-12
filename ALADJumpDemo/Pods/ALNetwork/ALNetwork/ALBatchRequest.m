//
//  ALBatchRequest.m
//  ALmdSocial
//
//  Created by ZhangKaiChao on 16/7/15.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALBatchRequest.h"

@interface ALBatchRequest() <ALRequestDelegate>

@property (nonatomic) NSInteger finishedCount;

@end


@implementation ALBatchRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [[NSMutableArray alloc] init];
        _finishedCount = 0;
    }
    return self;
}

- (instancetype)initWithRequestArray:(NSArray *)requestArray {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray arrayWithArray:requestArray];
        _finishedCount = 0;
        for (ALBaseRequest * req in _requestArray) {
            if (![req isKindOfClass:[ALBaseRequest class]]) {
                return nil;
            }
        }
    }
    return self;
}

- (void)start {
    if (_finishedCount > 0) {
        return;
    }
    [[ALBatchRequestAgent sharedInstance] addBatchRequest:self];
    for (ALBaseRequest * req in _requestArray) {
        req.delegate = self;
        [req start];
    }
}

- (void)stop {
    _delegate = nil;
    [self clearRequest];
    [[ALBatchRequestAgent sharedInstance] removeBatchRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(ALBatchRequest * batchRequest))success
                                    failure:(void (^)(ALBatchRequest * batchRequest,
                                                      ALBaseRequest * baseRequest))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(ALBatchRequest * batchRequest))success
                              failure:(void (^)(ALBatchRequest * batchRequest,
                                                ALBaseRequest * baseRequest))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (void)dealloc {
    [self clearRequest];
}

#pragma mark - Network Request Delegate
- (void)requestProgress:(NSProgress *)progress request:(ALBaseRequest *)request {
}


- (void)requestFinished:(ALBaseRequest *)request {
    _finishedCount++;
    if (_finishedCount == _requestArray.count) {
        if ([_delegate respondsToSelector:@selector(batchRequestFinished:)]) {
            [_delegate batchRequestFinished:self];
        }
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [self clearCompletionBlock];
    }
}

- (void)requestFailed:(ALBaseRequest *)request {

    // Stop
    for (ALBaseRequest *req in _requestArray) {
        [req stop];
    }
    // Callback
    if ([_delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        [_delegate batchRequestFailed:self];
    }
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self,request);
    }
    // Clear
    [self clearCompletionBlock];

    [[ALBatchRequestAgent sharedInstance] removeBatchRequest:self];
}

- (void)clearRequest {
    for (ALBaseRequest * req in _requestArray) {
        [req stop];
    }
    [self clearCompletionBlock];
}

/**
 *  添加组请求
 *
 *  @param request  请求
 *  @param successCallback 成功回调
 *  @param failCallback 失败回调
 */
- (void)addRequest:(ALBaseRequest *)request
   successCallback:(void (^)(ALBaseRequest * baseRequest))successCallback
      failCallback:(void (^)(ALBaseRequest * baseRequest))failCallback {
    [_requestArray addObject:request];
    request.successCompletionBlock = successCallback;
    request.failureCompletionBlock = failCallback;
}
@end

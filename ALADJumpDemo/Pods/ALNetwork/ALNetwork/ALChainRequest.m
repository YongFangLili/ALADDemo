//
//  ALChainRequest.m
//  ALmdSocial
//
//  Created by ZhangKaiChao on 16/7/15.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALChainRequest.h"

@interface ALChainRequest()<ALRequestDelegate>

@property (strong, nonatomic) NSMutableArray *requestArray;
@property (strong, nonatomic) NSMutableArray *successCallbackArray;
@property (strong, nonatomic) NSMutableArray *failCallbackArray;
@property (assign, nonatomic) NSUInteger nextRequestIndex;
@property (strong, nonatomic) ChainCallback successEmptyCallback;
@property (strong, nonatomic) ChainCallback failEmptyCallback;

@end

@implementation ALChainRequest

- (id)init {
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
        _successCallbackArray = [NSMutableArray array];
        _failCallbackArray = [NSMutableArray array];
        _successEmptyCallback = ^(ALChainRequest *chainRequest, ALBaseRequest *baseRequest) {
        };
        _failEmptyCallback = ^(ALChainRequest *chainRequest, ALBaseRequest *baseRequest) {
        };

    }
    return self;
}

- (void)start {
    if (_nextRequestIndex > 0) {
        return;
    }
    
    if ([_requestArray count] > 0) {
        [self startNextRequest];
        [[ALChainRequestAgent sharedInstance] addChainRequest:self];
    } else {
    }
}

- (void)stop {
    [self clearRequest];
    [[ALChainRequestAgent sharedInstance] removeChainRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(ALChainRequest * chainRequest))success
                                    failure:(void (^)(ALChainRequest * chainRequest,
                                                      ALBaseRequest * baseRequest))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(ALChainRequest * chainRequest))success
                              failure:(void (^)(ALChainRequest * chainRequest,
                                                ALBaseRequest * baseRequest))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (void)addRequest:(ALBaseRequest *)request
   successCallback:(ChainCallback)sccessCallback
      failCallback:(ChainCallback)failCallback {
    [_requestArray addObject:request];
    if (sccessCallback != nil) {
        [_successCallbackArray addObject:sccessCallback];
    } else {
        [_successCallbackArray addObject:_successEmptyCallback];
    }
    
    if (failCallback != nil) {
        [_failCallbackArray addObject:failCallback];
    } else {
        [_failCallbackArray addObject:_failEmptyCallback];
    }
}

- (NSArray *)requestArray {
    return _requestArray;
}

- (BOOL)startNextRequest {
    if (_nextRequestIndex < [_requestArray count]) {
        ALBaseRequest *request = _requestArray[_nextRequestIndex];
        _nextRequestIndex++;
        request.delegate = self;
        [request start];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Network Request Delegate
- (void)requestProgress:(NSProgress *)progress request:(ALBaseRequest *)request {
}

- (void)requestFinished:(ALBaseRequest *)request {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    ChainCallback callback = _successCallbackArray[currentRequestIndex];
    callback(self, request);
    callback = nil;
    if (![self startNextRequest]) {
        if ([_delegate respondsToSelector:@selector(chainRequestFinished:)]) {
            [_delegate chainRequestFinished:self];
        }
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [[ALChainRequestAgent sharedInstance] removeChainRequest:self];
    }
}

- (void)requestFailed:(ALBaseRequest *)request {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    ChainCallback callback = _failCallbackArray[currentRequestIndex];
    callback(self, request);
    callback = nil;
    if ([_delegate respondsToSelector:@selector(chainRequestFailed:failedBaseRequest:)]) {
        [_delegate chainRequestFailed:self failedBaseRequest:request];
    }
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self,request);
    }
    [[ALChainRequestAgent sharedInstance] removeChainRequest:self];

}

- (void)clearRequest {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    if (currentRequestIndex < [_requestArray count]) {
        ALBaseRequest *request = _requestArray[currentRequestIndex];
        [request stop];
    }
    [_requestArray removeAllObjects];
    [_successCallbackArray removeAllObjects];
    [_failCallbackArray removeAllObjects];
}

@end

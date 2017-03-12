//
//  ALBaseRequest.m
//  ALmdProject
//
//  Created by ZhangKaiChao on 15/11/3.
//  Copyright © 2015年 Mac_Libin. All rights reserved.
//

#import "ALBaseRequest.h"
#import "ALNetworkAgent.h"

@implementation ALBaseRequest

- (instancetype)init{
    if(self = [super init]){
        _requestUrl = @"";
        _cdnUrl = @"";
        _baseUrl = @"";
        _requestTimeoutInterval = 60.;
        _requestMethod = ALRequestMethodGet;
        _requestSerializerType = ALRequestSerializerTypeHTTP;
        _useCDN = NO;
    }
    return self;
}

/// 重载
- (void)cacheCompleteFilter{
}

- (void)requestCompleteFilter {
}

- (void)requestFailedFilter {
}

- (NSString *)requestUrl {
    return _requestUrl;
}

- (NSString *)cdnUrl {
    return _cdnUrl;
}

- (NSString *)baseUrl {
    return _baseUrl;
}

- (NSTimeInterval)requestTimeoutInterval {
    return _requestTimeoutInterval;
}

- (id)requestArgument {
    return _requestArgument;
}

/// 公共参数.
- (NSDictionary*)baseRequestArgument {
    return _baseRequestArgument;
}

- (ALRequestMethod)requestMethod {
    return _requestMethod;
}

- (ALRequestSerializerType)requestSerializerType {
    return _requestSerializerType;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return _requestAuthorizationHeaderFieldArray;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return _requestHeaderFieldValueDictionary;
}

- (BOOL)useCDN {
    return _useCDN;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
}

- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}

- (void)start {
    [[ALNetworkAgent sharedInstance] addRequest:self];
}

/// stop
- (void)stop {
    self.delegate = nil;
    [[ALNetworkAgent sharedInstance] cancelRequest:self];
}

- (BOOL)isExecuting {
    return self.task.state == NSURLSessionTaskStateRunning;
}

- (void)startCompletionBlockWithProgress:(void (^)(NSProgress * progress))progress
                                 success:(void (^)(ALBaseRequest *request))success
                                 failure:(void (^)(ALBaseRequest *request))failure {
    [self setCompletionBlockWithProgress:progress success:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithProgress:(void (^)(NSProgress *progress))progress
                               success:(void (^)(ALBaseRequest *request))success
                               failure:(void (^)(ALBaseRequest *request))failure {
    self.progressBlock = progress;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    self.progressBlock = nil;
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (NSInteger)responseStatusCode {
    return ((NSHTTPURLResponse*)self.task.response).statusCode;
}

- (NSDictionary *)responseHeaders {
    return ((NSHTTPURLResponse*)self.task.response).allHeaderFields;
}

@end

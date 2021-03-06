//
//  ALBaseRequest.h
//  ALmdProject
//
//  Created by ZhangKaiChao on 15/11/3.
//  Copyright © 2015年 Mac_Libin. All rights reserved.
//


/**
 * @file        ALBaseRequest.h
 * @brief       请求基类.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2015-11-03
 *
 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 *  请求方法.
 */
typedef NS_ENUM(NSInteger , ALRequestMethod) {
    /**
     *  get
     */
    ALRequestMethodGet = 0,
    /**
     *  post
     */
    ALRequestMethodPost,
    /**
     *  put
     */
    ALRequestMethodPut,
};

/**
 *  请求SerializerType
 */
typedef NS_ENUM(NSInteger , ALRequestSerializerType) {
    /**
     *  http
     */
    ALRequestSerializerTypeHTTP = 0,
    /**
     *  json
     */
    ALRequestSerializerTypeJSON,
};

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

/// 请求回调协议.
@class ALBaseRequest;
@protocol ALRequestDelegate <NSObject>

@optional
/**
 *  进度.
 *
 *  @param progress 进度
 *  @param request 请求
 */
- (void)requestProgress:(NSProgress *)progress request:(ALBaseRequest *)request;

/**
 *  请求成功回调.
 *
 *  @param request 请求
 */
- (void)requestFinished:(ALBaseRequest *)request;

/**
 *  请求失败回调.
 *
 *  @param request 请求
 */
- (void)requestFailed:(ALBaseRequest *)request;

/**
 *  清除请求.
 */
- (void)clearRequest;

@end

/// 请求基类.
@interface ALBaseRequest : NSObject

/// tag.
@property (nonatomic, assign) NSInteger tag;
/// url.
@property (nonatomic, copy) NSString * requestUrl;
@property (nonatomic, copy) NSString * cdnUrl;
@property (nonatomic, copy) NSString * baseUrl;
/// time.
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
/// argument.
@property (nonatomic, strong) id requestArgument;
/// baseRequestArgument.
@property (nonatomic, strong) id baseRequestArgument;
/// method.
@property (nonatomic, assign) ALRequestMethod requestMethod;
/// serializer.
@property (nonatomic, assign) ALRequestSerializerType requestSerializerType;
/// header.
@property (nonatomic, strong) NSArray * requestAuthorizationHeaderFieldArray;
@property (nonatomic, strong) NSDictionary * requestHeaderFieldValueDictionary;
/// useCDN?.
@property (nonatomic, assign) BOOL useCDN;
/// User info
@property (nonatomic, strong) NSDictionary *userInfo;
/// task.
@property (nonatomic, strong) NSURLSessionDataTask * task;

/// request delegate
@property (nonatomic, weak) id<ALRequestDelegate> delegate;

/// response.
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, readonly) NSInteger responseStatusCode;
@property (nonatomic, strong) NSError * error;

/// block call back.
@property (nonatomic, copy) void (^successCompletionBlock)(ALBaseRequest *);
@property (nonatomic, copy) void (^failureCompletionBlock)(ALBaseRequest *);
@property (nonatomic, copy) void (^progressBlock)(NSProgress *);

/// append self to request queue
- (void)start;

/// remove self from request queue
- (void)stop;

/// execute
- (BOOL)isExecuting;

/// block回调
- (void)startCompletionBlockWithProgress:(void (^)(NSProgress *progress))progress
                                 success:(void (^)(ALBaseRequest *request))success
                                         failure:(void (^)(ALBaseRequest *request))failure;
/// 设置回调block
- (void)setCompletionBlockWithProgress:(void (^)(NSProgress *progress))progress
                               success:(void (^)(ALBaseRequest *request))success
                              failure:(void (^)(ALBaseRequest *request))failure;
/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

/// 以下方法由子类继承来覆盖默认值

/// 请求成功的回调
- (void)requestCompleteFilter;

/// 请求失败的回调
- (void)requestFailedFilter;

/// 请求的URL
- (void)setRequestUrl:(NSString *)aRequestUrl;
- (NSString *)requestUrl;

/// 请求的CdnURL
- (void)setCdnUrl:(NSString *)aCdnUrl;
- (NSString *)cdnUrl;

/// 请求的BaseURL
- (void)setBaseUrl:(NSString *)aBaseUrl;
- (NSString *)baseUrl;

/// 请求的连接超时时间，默认为60秒
- (void)setRequestTimeoutInterval:(NSTimeInterval)aRequestTimeoutInterval;
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的参数列表
- (void)setRequestArgument:(id)aRequestArgument;
- (id)requestArgument;

/// 公共参数.
- (NSDictionary*)baseRequestArgument;

/// Http请求的方法
- (void)setRequestMethod:(ALRequestMethod)aRequestMethod;
- (ALRequestMethod)requestMethod;

/// 请求的SerializerType
- (void)setRequestSerializerType:(ALRequestSerializerType)aRequestSerializerType;
- (ALRequestSerializerType)requestSerializerType;

/// 请求的Server用户名和密码
- (void)setRequestAuthorizationHeaderFieldArray:(NSArray *)aRequestAuthorizationHeaderFieldArray;
- (NSArray *)requestAuthorizationHeaderFieldArray;

/// 在HTTP报头添加的自定义参数
- (void)setRequestHeaderFieldValueDictionary:(NSDictionary *)aRequestHeaderFieldValueDictionary;
- (NSDictionary *)requestHeaderFieldValueDictionary;

/// 是否使用CDN的host地址
- (void)setUseCDN:(BOOL)useCDN;
- (BOOL)useCDN;

/// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator;

/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock;


@end

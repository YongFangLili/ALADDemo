//
//  ALADJumpDowLoader.m
//  ALADJumpDowloader
//
//  Created by liyongfang on 2017/6/23.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "ALADJumpDowLoader.h"
#import "NSString+ALADJump.h"
#import "ALADJumpCache.h"


#pragma mark -ALADJumpDownload
@interface ALADJumpDownload()
/** session */
@property (strong, nonatomic) NSURLSession *session;
/** dowLoadTask 下载任务 */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/** 下载的总长度 */
@property (nonatomic, assign) unsigned long long totalLength;
/** 当前下载的长度 */
@property (nonatomic, assign) unsigned long long currentLength;
/** 下载进程block */
@property (nonatomic, copy) ALADJumpDownloadProgressBlock progressBlock;
/** 下载url */
@property (nonatomic, strong) NSURL *url;

@end

@implementation ALADJumpDownload

@end

#pragma mark -  ALADJumpImageDownload
@interface ALADJumpImageDownload ()<NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>

/** 下载完成Block */
@property (nonatomic, copy) ALADJumpDownloadImageCompletedBlock completedBlock;

@end

@implementation ALADJumpImageDownload


-(nonnull instancetype)initWithURL:(nonnull NSURL *)url delegateQueue:(nonnull NSOperationQueue *)queue progress:(nullable ALADJumpDownloadProgressBlock)progressBlock completed:(nullable ALADJumpDownloadImageCompletedBlock)completedBlock {
    
    self = [super init];
    if (self) {
        self.url = url;
        self.progressBlock = progressBlock;
        self.completedBlock = completedBlock;
        NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 网络延迟15s
        sessionConfiguration.timeoutIntervalForRequest = 30.0;
        
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:queue];
        self.downloadTask = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:url]];
        [self.downloadTask resume];
    }
    return self;
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:data];
    // 主线程回调
    if (self.completedBlock) {
        _completedBlock(image,data,nil);
    }
    
    // 下载完成回调
    if ([self.delegate respondsToSelector:@selector(downloadFinishWithURL:)]) {
        [self.delegate downloadFinishWithURL:self.url];
    }
    [self.session invalidateAndCancel];
    self.session = nil;
}

// 下载中
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    self.currentLength = totalBytesWritten;
    self.totalLength = totalBytesExpectedToWrite;
    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
        NSLog(@"%.2llu",self.currentLength/self.totalLength);
    }
}

// 下载任务完成回调
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error) {
        NSLog(@"error=%@",error);
        if (_completedBlock) {
            _completedBlock(nil,nil, error);
            // 下载完成回调
            if ([self.delegate respondsToSelector:@selector(downloadFinishWithURL:)]) {
                [self.delegate downloadFinishWithURL:self.url];
            }
        }
        _completedBlock = nil;
    }
}

//处理HTTPS请求的
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = protectionSpace.serverTrust;
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

@end


#pragma mark - ALADJumpDowLoader
@interface ALADJumpDowLoader()<ALADJumpDownloadDelegate>
/** 下载队列 */
@property (strong, nonatomic, nonnull) NSOperationQueue *downloadImageQueue;
/** 存储的队列字典 */
@property (strong, nonatomic) NSMutableDictionary *allDownloadDict;

@end

@implementation ALADJumpDowLoader

+ (instancetype)sharedDownloader {
    
    static ALADJumpDowLoader *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance =  [[ALADJumpDowLoader alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _downloadImageQueue = [[NSOperationQueue alloc] init];
        _downloadImageQueue.maxConcurrentOperationCount = 5;
        _downloadImageQueue.name = @"com.it0203.ALADJumpDownloadImageQueue";
    }
    return self;
}

- (void)downloadImageWithURL:(NSURL *)url progress:(ALADJumpDownloadProgressBlock)progressBlock completed:(ALADJumpDownloadImageCompletedBlock)completedBlock withFilePath:(NSString *)filePath {

    if (self.allDownloadDict[url.absoluteString.xh_md5String]) { // 存在下载，不用创建
        return;
    }
    
    ALADJumpImageDownload *imageDowLoade = [[ALADJumpImageDownload alloc] initWithURL:url delegateQueue:self.downloadImageQueue progress:progressBlock completed:completedBlock];
    imageDowLoade.delegate = self;
    // 存储下载标记
    [self.allDownloadDict setObject:imageDowLoade forKey:url.absoluteString.xh_md5String];
}

- (void)downLoadImageAndCacheWithURLArray:(NSArray<NSString *> *)urlArray withFilePath:(NSString *)filePath {
    
    __weak typeof(self) weakSelf = self;
    [urlArray enumerateObjectsUsingBlock:^(NSString * _Nonnull urlString, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        // 如果本地存在，则不需要下载,不是urlString ,以及url为空时，不进行请求
        if ([ALADJumpCache getCacheImageWithURL:url WithFilePath:filePath] || ![urlString xh_isURLString] || !url) {
            return ;
        }
        // 开始下载
        [weakSelf downloadImageWithURL:url progress:^(unsigned long long total, unsigned long long current) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            
            if (!error) {
                NSLog(@"下载成功");
                // 存储数据
                [ALADJumpCache  async_saveImageData:data imageURL:url withFilePath:filePath];
            }else {
                NSLog(@"下载失败");
            }
        } withFilePath:filePath];
    }];

}

#pragma mark - ALADJumpDownloadDelegate
- (void)downloadFinishWithURL:(NSURL *)url{
    
    [self.allDownloadDict removeObjectForKey:url.absoluteString.xh_md5String];
}

#pragma mark -lazy
- (NSMutableDictionary *)allDownloadDict {
    
    if (!_allDownloadDict) {
        _allDownloadDict = [[NSMutableDictionary alloc] init];
    }
    return _allDownloadDict;
}

@end

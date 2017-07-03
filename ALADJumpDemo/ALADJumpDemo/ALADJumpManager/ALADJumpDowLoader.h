//
//  ALADJumpDowLoader.h
//  ALADJumpDowloader
//
//  Created by liyongfang on 2017/6/23.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - ALADJumpDownload

typedef void(^ALADJumpDownloadProgressBlock)(unsigned long long total, unsigned long long current);

typedef void(^ALADJumpDownloadImageCompletedBlock)(UIImage *_Nullable image, NSData * _Nullable data, NSError * _Nullable error);

@protocol ALADJumpDownloadDelegate <NSObject>

/**
 * @brief 下载完成代理方法
 */
- (void)downloadFinishWithURL:(nonnull NSURL *)url;

@end

@interface ALADJumpDownload : NSObject

/** 代理 */
@property (assign, nonatomic ,nonnull)id<ALADJumpDownloadDelegate> delegate;

@end

#pragma mark - ALADJumpImageDownload
@interface ALADJumpImageDownload : ALADJumpDownload

@end


#pragma mark - ALADJumpDowLoader
@interface ALADJumpDowLoader : NSObject

/**
 * @brief 单例
 */
+(nonnull instancetype )sharedDownloader;

/**
 * @brief 单张图片下载;
 */
- (void)downloadImageWithURL:(nonnull NSURL *)url progress:(nullable ALADJumpDownloadProgressBlock)progressBlock completed:(nullable ALADJumpDownloadImageCompletedBlock)completedBlock withFilePath:(NSString *_Nullable)filePath;

/**
 * @brief 图片数组下载
 */
- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSString *> * )urlArray withFilePath:(NSString *_Nullable)filePath;

@end



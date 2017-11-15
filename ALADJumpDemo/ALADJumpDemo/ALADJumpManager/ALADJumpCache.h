//
//  ALADJumpCache.h
//  ALADJumpDowloader
//
//  Created by liyongfang on 2017/6/23.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALADJumpCache : NSObject


/**
 *  缓存图片 - 异步
 *
 *  @param data imageData
 *  @param url  图片url
 *  @filePath   文件路径
 */
+ (void)async_saveImageData:(NSData *)data imageURL:(NSURL *)url withFilePath: (NSString *)filePath;

/**
 *  缓存广告配置信息 - 异步
 *
 *  @param adInfoDic 广告基本信息
 *  @param filePath  存储路径
 *  @filePath   文件路径
 */
+ (void)async_saveAdInfoDic:(NSDictionary *)adInfoDic withFilePath: (NSString *)filePath;

/**
 *  获取缓存图片
 *
 *  @param url 图片url
 *
 *  @return 图片
 */
+ (UIImage *)getCacheImageWithURL:(NSURL *)url WithFilePath:(NSString *)filePath;

/**
 *  获取缓存图片
 *  filePath   存储路径
 *  @return 广告基本信息
 */
+ (NSDictionary *)getADInfoDicWithFilePath:(NSString *)filePath;

/**
 *  清除广告本地缓存
 */
+(void)clearADdiskCacheWithFilePath:(NSString *)filePath;
@end

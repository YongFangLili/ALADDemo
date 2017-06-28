//
//  ALADJumpCache.m
//  ALADJumpDowloader
//
//  Created by liyongfang on 2017/6/23.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "ALADJumpCache.h"
#import "NSString+ALADJump.h"
// 存储广告文件名称
NSString * const kADInfoDataFileName             = @"adInfoDataName.plist";

@implementation ALADJumpCache

// 异步缓存图片
+(void)async_saveImageData:(NSData *)data imageURL:(NSURL *)url withFilePath: (NSString *)filePath {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self saveImageData:data imageURL:url withFilePath:filePath];
    });


}


// 保存图片
+(BOOL)saveImageData:(NSData *)data imageURL:(NSURL *)url withFilePath :(NSString *)filePath {
    
    
    NSString *savePath = [self imageFilePathWithDirFilePath:filePath withImageUrl:url.absoluteString];
    
    if (savePath) {
        if (data) {
            BOOL isOK = [[NSFileManager defaultManager] createFileAtPath:savePath contents:data attributes:nil];
            if (!isOK) NSLog(@"cache file error for URL: %@", url);
            
            return isOK;
        }
    }
    return NO;
}

+ (void)async_saveAdInfoDic:(NSDictionary *)adInfoDic withFilePath: (NSString *)filePath {
    
    
    NSString *savePath = [self ADInfoFilePathWithDirFilePath:filePath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL isSecucess = [adInfoDic writeToFile:savePath atomically:YES];
        if (isSecucess) {
            NSLog(@"保存成功");
        }else {
            NSLog(@"保存失败");
        
        }
    });
}

// 获取图片保存路径
+ (NSString *)imageFilePathWithDirFilePath:(NSString *)dirFilePath withImageUrl:(NSString *)imageUrl {
    
    NSString *fileDir = [self checkFilepathWithFilePath:dirFilePath];
    NSString *savePath = [fileDir stringByAppendingPathComponent:imageUrl.xh_md5String];
    return savePath;
}

// 获取广告信息保存路径
+ (NSString *)ADInfoFilePathWithDirFilePath:(NSString *)dirFilePath {
    
    NSString *fileDir = [self checkFilepathWithFilePath:dirFilePath];
    NSString *savePath = [fileDir stringByAppendingPathComponent:(kADInfoDataFileName).xh_md5String];
    return savePath;
}



+ (UIImage *)getCacheImageWithURL:(NSURL *)url WithFilePath:(NSString *)filePath{
    
    if (url == nil) return nil;
    NSString *savePath = [NSString stringWithFormat:@"%@/%@",[self checkFilepathWithFilePath:filePath],url.absoluteString.xh_md5String];
    NSData *data = [NSData dataWithContentsOfFile:savePath];;
    
    return [UIImage imageWithData:data];
}

+ (NSDictionary *)getADInfoDicWithFilePath:(NSString *)filePath {
    
    NSString *fileDir = [self checkFilepathWithFilePath:filePath];
    NSString *savePath = [fileDir stringByAppendingPathComponent:(kADInfoDataFileName).xh_md5String];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:savePath];
    return dic;
}


+ (NSString *)checkFilepathWithFilePath:(NSString *)filePath {
    
    // 判断文件是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return filePath;
}

+ (void)clearADdiskCacheWithFilePath:(NSString *)filePath {
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        [self checkFilepathWithFilePath:filePath];
        
//    });
}
@end

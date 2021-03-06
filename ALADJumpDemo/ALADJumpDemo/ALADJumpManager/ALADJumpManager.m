//
//  ALADJumpManager.m
//  MedplusSocial
//
//  Created by liyongfang on 2017/2/13.
//  Copyright © 2017年 北京欧创医疗技术有限公司. All rights reserved.
//

#import "ALADJumpManager.h"
#import "ALADJumpView.h"
#import "ALADDefineHeader.h"

@interface ALADJumpManager()<ALADJumpViewDelegate>

/** 上一次保存的模型数据 */
@property (nonatomic, strong) NSDictionary *oldDataDic;

/** 广告模型 */
@property (nonatomic, assign) ALADJumpAppType appType;

/** 文件路径 */
@property (nonatomic, copy) NSString *filePath;

/** 自定义Button */
@property (nonatomic, strong) UIButton *customerButton;

@end

@implementation ALADJumpManager

/**
 * @brief 添加广告视图
 * @param isShow 是否在当前界面显示广告
 */
- (void)showADJumpViewWithIsShow:(BOOL)isShow {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpUpdateALADData:)]) {
        [self.delegate ALADJumpUpdateALADData:self];
    }
    
    // 视图能在view上显示    置于后台时间没有超时  并且后台允许显示广告  文件里有没有图片
    self.oldDataDic = [self getADInfoDataWithFilePath:self.filePath];
    UIImage *image = [self getADImageDataWithFilePath:self.filePath];
    if (!self.oldDataDic || ![[self.oldDataDic objectForKey:kALADJumpIsShowKey] boolValue] || !image) {
        return;
    }
    // 判断是否显示广告
    if (isShow ) {
        
        if ([self.oldDataDic objectForKey:kALADJumpImageUrlKey]!= nil) {
            // 显示广告图片
            ALADJumpView *adJumpView = [[ALADJumpView alloc] initAdJumpViewFrame:CGRectMake(0, 0,kPHONE_WIDTH , kPHONE_HEIGH) andWithAppType:self.appType  withDataDic:self.oldDataDic withCustomerButton:self.customerButton ];
            adJumpView.filePath = [self getFilePathWithPath:_filePath withFileName:kAdImageDataName];
            adJumpView.delegate = self;
            [adJumpView showAD];
        }
    }
}

/**
 * @brief   创建广告Manager
 * @param   filePath          文件路径
 * @param   appType           app类型
 * @param   customeButton     自定义Button
 * @return  adManager
 */
- (instancetype)initALADJumpManagerWithFilePath : (NSString *)filePath
                                 andWithAPPType : (ALADJumpAppType)appType
                              withCustomerButton: (UIButton *)customeButton {
    
    if (self = [super init]) {
        _filePath = filePath;
        _appType = appType;
        _oldDataDic = [self getADInfoDataWithFilePath:_filePath];
        self.customerButton = customeButton;
    }
    return self;
}

/**
 * @brief  初始化一个自定义广告视图
 * @param  filePath 文件路径
 * @return adManager
 */
- (instancetype)initALADJumpCustomerViewWithFilePath:(NSString *)filePath {
    
    if (self = [super init]) {
        _filePath = filePath;
    }
    return self;
}

/**
 * @brief 处理广告数据
 * @param dic 网络请求得到的新model
 */
- (void)handleDataWithDic:(NSDictionary *)dic {
    
    // 图片不一样重新下载图片
    if (dic[kALADJumpLinkUrlKey] == nil || ![[dic objectForKey:kALADJumpImageUrlKey] isEqualToString:[self.oldDataDic objectForKey:kALADJumpImageUrlKey]]) {
        // 异步下载图片
        [self downloadADImageWithDataDic:dic];
    }
}

/**
 * @brief 图片下载
 * @param dic 广告数据
 */
- (void)downloadADImageWithDataDic:(NSDictionary *)dic {
    
    NSString *imageUrl = [dic objectForKey:kALADJumpImageUrlKey];
    NSURL *url = [NSURL URLWithString: [dic objectForKey:kALADJumpImageUrlKey]];
    if (imageUrl && imageUrl.length > 0 && url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //下载数据
            NSError *error = nil;
            NSData *data= [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
            UIImage * image = [UIImage imageWithData:data];
            BOOL ret = [UIImagePNGRepresentation(image) writeToFile:[self getFilePathWithPath:self.filePath withFileName:kAdImageDataName] atomically:YES];
            if (ret) {
                [self saveAdInfoDataWithData:dic];
                NSLog(@"写入图片成功");
            }else {
                [self deleteOldImageDataWithFilePath:self.filePath];
            }
        });
    }else {
        [self deleteOldImageDataWithFilePath:self.filePath];
    }
}

/**
 *  @brief  判断该路径是否存在文件
 *  @param  filePath 路径
 *  @return BOOL
 */
- (BOOL)isFileExistWithFilePath:(NSString *) filePath {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}


/**
 * @brief 获取缓存路径
 * @return 返回缓存路径
 */
- (NSString*)getFilePathWithPath:(NSString *)path withFileName:(NSString *)fileName {

    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}

/**
 * @brief 归档方法保存数据信息
 * @param dic 保存基本信息
 */
- (void)saveAdInfoDataWithData:(NSDictionary *)dic {
    
    if (dic == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BOOL isSucecess =  [dic writeToFile:[self getFilePathWithPath:self.filePath withFileName:kAdInfoDataName] atomically:YES];
        if (isSucecess) {
            NSLog(@"保存成功");
        }else {
            NSLog(@"保存失败");
        }
    });
}

/**
 * @brief  从沙盒中获取图片image
 * @param  filePath 文件路径
 * @return 广告图片数据
 */
- (UIImage *)getADImageDataWithFilePath:(NSString *)filePath{
    
    return [UIImage imageWithContentsOfFile:[self getFilePathWithPath:filePath withFileName:kAdImageDataName]];
}

/**
 * @brief  从沙盒中获取广告数据
 * @param  filePath 文件路径
 * @return 广告数据
 */
- (NSDictionary *)getADInfoDataWithFilePath:(NSString *)filePath {
    
    return [NSDictionary dictionaryWithContentsOfFile:[self getFilePathWithPath:filePath withFileName:kAdInfoDataName]];
}

/**
 * @brief 删除imageData
 * @param filePath 文件路径
 */
- (void)deleteOldImageDataWithFilePath:(NSString *)filePath {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([self isFileExistWithFilePath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }

}

#pragma mark -delegate
/**
 * @brief ALADJumpAppType 跳转
 * @param linkUrl 跳转url
 */
- (void)adJumpImageViewDidClick:(NSString *)linkUrl {
    
    //执行跳转 Block
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpViewDidClick:)]) {
        [self.delegate ALADJumpViewDidClick:linkUrl];
    }
}

/**
 * @brief 广告视图将要出现
 */
- (void)adJumpViewWillAppear {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpViewWillApear:)]) {
        [self.delegate ALADJumpViewWillApear:self];
    }
}

/**
 * @brief 广告视图将要消失
 */
- (void)adJumpViewWillDisAppear {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpViewWillDisapear:)]) {
        [self.delegate ALADJumpViewWillDisapear:self];
    }
}

/**
 * @breif 默认值处理
 * @param paramDic 参数
 * @return 参数
 */
- (NSDictionary*)handleDefaultAdParameWithParame:(NSDictionary *)paramDic {
    
    if (![paramDic objectForKey:kALADJumpContinueTimeKey]) {
        [paramDic setValue:@(kDefaultTimeContineAd) forKey:kALADJumpContinueTimeKey];
    }
    
    if (![paramDic objectForKey:kALADAppInBackgroundTimeKey]) {
        [paramDic setValue:@(kDefaultTimeBackgroud) forKey:kALADAppInBackgroundTimeKey];
    }
    
    if (![paramDic objectForKey:kALADJumpIsShowKey]) {
        [paramDic setValue:@(YES) forKey:kALADJumpIsShowKey];
    }
    
    return paramDic;
}

#pragma mark -lazy  get set方法
- (void)setAdParam:(NSDictionary *)adParam {
    
    // 默认值处理
    _adParam = [self handleDefaultAdParameWithParame:adParam];
    if (![[adParam objectForKey:kALADJumpIsShowKey] boolValue]) {
        [self deleteOldImageDataWithFilePath:self.filePath];
        return;
    }
    [self handleDataWithDic:adParam];
}

- (void)dealloc {
    NSLog(@"manager dellog 了");
}

@end

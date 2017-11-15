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
#import "ALADJumpCache.h"
#import "ALADJumpDowLoader.h"

@interface ALADJumpManager()<ALADJumpViewDelegate>

/** 上一次保存的模型数据 */
@property (nonatomic, strong) NSDictionary *oldDataDic;
/** 广告模型 */
@property (nonatomic, assign) ALADJumpAppType appType;
/** 文件路径 */
@property (nonatomic, copy) NSString *filePath;
/** 自定义Button */
@property (nonatomic, strong) UIButton *customerButton;
/** 当前的需要展示的广告Index */
@property (nonatomic, assign) NSInteger currentIndex;
/** 图片数组 */
@property (nonatomic, strong) NSArray *imageUrlArray;
/** 广告跳转链接数组 */
@property (nonatomic, strong) NSArray *linkUrlArray;
/** 广告view */
@property (nonatomic, strong)ALADJumpView *adJumpView;

@end

@implementation ALADJumpManager

/**
 * @brief 添加广告视图
 * @param isShow 是否在当前界面显示广告
 */
- (void)showADJumpViewWithIsShow:(BOOL)isShow {
    
    // 获取广告之前的数据
    self.oldDataDic = [ALADJumpCache getADInfoDicWithFilePath:self.filePath];
    // 获取上一次的图片数组Index
    self.currentIndex = [self.oldDataDic[kALADImageCurrentIndex] integerValue];
    // 获取存储的图片数组
    self.imageUrlArray = self.oldDataDic[kALADJumpImageUrlArraysKey];
    // 获取存储的linkURL数组
    self.linkUrlArray = self.oldDataDic[kALADJumpLinkUrlArraysKey];
    // 获取当前需要显示的imageUrl
    NSString *imageUrl = self.imageUrlArray[self.currentIndex];
    // 获取需要显示的adImage
    UIImage *adImage = [ALADJumpCache getCacheImageWithURL:[NSURL URLWithString:imageUrl] WithFilePath:self.filePath];
    NSString *imageLinkUrl;
    // 获取当前需要显示的广告链接
    if (self.currentIndex >= self.linkUrlArray.count) {
        imageLinkUrl = @"";
    }else {
         imageLinkUrl = self.linkUrlArray[self.currentIndex];
    }
    // 获取广告的持续时间
    NSInteger contuneTime = [self.oldDataDic[kALADJumpContinueTimeKey] integerValue];
    // 广告是否已经无效
    BOOL isValid = [[self.oldDataDic objectForKey:kALADJumpIsShowKey] boolValue];

    // 显示广告
    if (isShow && adImage && isValid && imageUrl ) {
        self.adJumpView.filePath = self.filePath;
        self.adJumpView.adContineTime = contuneTime;
        self.adJumpView.adImage = adImage;
        self.adJumpView.linkUrl = imageLinkUrl;
        self.adJumpView.delegate = self;
        self.adJumpView.customerButton = self.customerButton;
        self.adJumpView.appType = self.appType;
        [self.adJumpView showAD];
    }
    // 通知代理去下载最近的广告数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpUpdateALADData:)]) {
        [self.delegate ALADJumpUpdateALADData:self];
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
        _oldDataDic = [ALADJumpCache getADInfoDicWithFilePath:filePath];
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
    
    BOOL isUpdate = NO;
    // 如果图片数组为0，并且广告无效，移除数组
    NSArray *newImageUrlArray = [dic objectForKey:kALADJumpImageUrlArraysKey];
    NSArray *newLinkUrlArray = [dic objectForKey:kALADJumpLinkUrlArraysKey];
    if ( newImageUrlArray.count == 0 || ![[dic objectForKey:kALADJumpIsShowKey] boolValue]) {
        [ALADJumpCache clearADdiskCacheWithFilePath:self.filePath];
        return;
    }
    
    if (self.imageUrlArray.count != newImageUrlArray.count) {
        isUpdate = YES;
    }else {// 循环遍历是否已经更新了广告
        for (int i = 0; i < newImageUrlArray.count; i++) {
            
            if (![self.imageUrlArray[i] isEqualToString:newImageUrlArray[i]]) {
                isUpdate = YES;
                break;
            } else {
                isUpdate = NO;
            }
        }
        if (isUpdate == NO) {
            for (int i = 0; i < [newLinkUrlArray count]; i++) {
                if (![self.linkUrlArray[i] isEqualToString:newLinkUrlArray[i]]) {
                    isUpdate = YES;
                    break;
                } else {
                    isUpdate = NO;
                }
            }
        }
    }
    if (isUpdate) {
        // 设置currentIndex的值
        [dic setValue:@(0) forKey:kALADImageCurrentIndex];
        // 删除之前的
        [ALADJumpCache clearADdiskCacheWithFilePath:self.filePath];
        [ALADJumpCache async_saveAdInfoDic:dic withFilePath:self.filePath];
        
    }else { // 如果没有更新，增加index值
        self.currentIndex += 1;
        if (self.currentIndex >= self.imageUrlArray.count) {
            self.currentIndex = 0;
        }
        [self.oldDataDic setValue:@(self.currentIndex) forKey:kALADImageCurrentIndex];
         [ALADJumpCache async_saveAdInfoDic:self.oldDataDic withFilePath:self.filePath];
    }
    
    // 下载新的image / 下载没有下载成功的image
    [[ALADJumpDowLoader sharedDownloader] downLoadImageAndCacheWithURLArray:newImageUrlArray withFilePath:self.filePath];
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
 * @brief 更新广告信息
 */
- (void)updateALADDataInfo {
    
    // 存储dic
    NSMutableDictionary *adInfoDic = [NSMutableDictionary dictionary];
    [adInfoDic setObject:self.alADImageUrlArray forKey:kALADJumpImageUrlArraysKey];
    [adInfoDic setObject:self.alADImageLinkArray forKey:kALADJumpLinkUrlArraysKey];
    [adInfoDic setValue:@(self.alADJumpIsShow) forKey:kALADJumpIsShowKey];
    [adInfoDic setValue: @(self.alADJumpContinueTime ? self.alADJumpContinueTime : kALAD_DefaultTimeContineAd) forKey:kALADJumpContinueTimeKey];
    [adInfoDic setValue:@(self.alADAppInBackgroundTime ? self.alADAppInBackgroundTime : kALAD_DefaultTimeBackgroud) forKey:kALADAppInBackgroundTimeKey];
    [self handleDataWithDic:adInfoDic];
}

#pragma mark -lazy  get set方法
- (ALADJumpView *)adJumpView {
    
    if (!_adJumpView) {
        _adJumpView = [[ALADJumpView alloc] initWithFrame:CGRectMake(0, 0,kALAD_PHONE_WIDTH , kALAD_PHONE_HEIGH) ];
    }
    return _adJumpView;
}

- (void)dealloc {
}

@end

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
//静态图
#define imageURL1 @"http://c.hiphotos.baidu.com/image/pic/item/4d086e061d950a7b78c4e5d703d162d9f2d3c934.jpg"
#define imageURL2 @"http://d.hiphotos.baidu.com/image/pic/item/f7246b600c3387444834846f580fd9f9d72aa034.jpg"
#define imageURL3 @"http://d.hiphotos.baidu.com/image/pic/item/64380cd7912397dd624a32175082b2b7d0a287f6.jpg"
#define imageURL4 @"http://d.hiphotos.baidu.com/image/pic/item/14ce36d3d539b60071473204e150352ac75cb7f3.jpg"
#define imageURL8 @"https://img99.allinmd.cn/ad/2017/04/26/1366_1493170365933.jpg"
#define imageURL9 @"https://img99.allinmd.cn/ad/2017/01/22/1292_1485055213513.png"
#define imageURL10 @"https://img99.allinmd.cn/ad/2017/03/31/1350_1490946188888.png"

//动态图
#define imageURL5 @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg"
#define imageURL6 @"http://p1.bqimg.com/567571/4ce1a4c844b09201.gif"
#define imageURL7 @"http://p1.bqimg.com/567571/23a4bc7a285c1179.gif"

//视频链接
#define videoURL1 @"http://ohnzw6ag6.bkt.clouddn.com/video0.mp4"
#define videoURL2  @"http://120.25.226.186:32812/resources/videos/minion_01.mp4"
#define videoURL3 @"http://ohnzw6ag6.bkt.clouddn.com/video1.mp4"


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
        NSLog(@"~~~~~~~第%zd张广告",self.currentIndex);
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
            }else {
                isUpdate = NO;
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

///**
// * @breif 默认值处理
// * @param paramDic 参数
// * @return 参数
// */
//- (NSDictionary*)handleDefaultAdParameWithParame:(NSDictionary *)paramDic {
//    
//    if (![paramDic objectForKey:kALADJumpContinueTimeKey]) {
//        [paramDic setValue:@(kALAD_DefaultTimeContineAd) forKey:kALADJumpContinueTimeKey];
//    }
//    
//    if (![paramDic objectForKey:kALADAppInBackgroundTimeKey]) {
//        [paramDic setValue:@(kALAD_DefaultTimeBackgroud) forKey:kALADAppInBackgroundTimeKey];
//    }
//    
//    if (![paramDic objectForKey:kALADJumpIsShowKey]) {
//        [paramDic setValue:@(YES) forKey:kALADJumpIsShowKey];
//    }
//    
//    return paramDic;
//}

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
//- (void)setAdParam:(NSDictionary *)adParam {
//    
//    // 默认值处理
//    _adParam = [self handleDefaultAdParameWithParame:adParam];
//    [self handleDataWithDic:adParam];
//}

- (ALADJumpView *)adJumpView {
    
    if (!_adJumpView) {
        _adJumpView = [[ALADJumpView alloc] initWithFrame:CGRectMake(0, 0,kALAD_PHONE_WIDTH , kALAD_PHONE_HEIGH) ];//
//                        initAdJumpViewFrame: andWithAppType:self.appType   withCustomerButton:self.customerButton ];
    }
    return _adJumpView;
}

- (void)dealloc {
    NSLog(@"manager dellog 了");
}

@end

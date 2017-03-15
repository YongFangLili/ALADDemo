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


// 进入后台时的时间
static NSString *  const kSaveTimeWhenEnterBackgroud= @"kSaveTimeWhenEnterBackgroud";

@interface ALADJumpManager()<ALADJumpViewDelegate>

/**上一次保存的模型数据*/
@property (nonatomic, strong) NSDictionary *oldDataDic;

/**广告模型*/
@property (nonatomic, assign) ALADJumpAppType appType;

/**文件路径*/
@property (nonatomic, copy) NSString *filePath;

/**自定义广告视图*/
@property (nonatomic, strong) ALADJumpView *adCustomSubview;

/**自定义广告视图*/
@property (nonatomic, copy) BOOL(^isAllViewShowAdBlock) ();

/**是否从后台进入*/
@property (nonatomic, assign) BOOL isBackgroundIn;

/**是否有其他界面不显示广告*/
@property (nonatomic, assign) BOOL ishasViewsNotShowAd;

/** 自定义Button */
@property (nonatomic, strong) UIButton *customerButton;

@end

@implementation ALADJumpManager

- (void)showADJumpViewWithIsShow:(BOOL)isShow {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpUpdateALADData:)]) {
        [self.delegate ALADJumpUpdateALADData:self];
    }
    
    // 视图能在view上显示    至于后台时间没有超时  并且后台允许显示广告
    self.oldDataDic = [self getADData];
    if (isShow && [self isShowADView] && self.oldDataDic[kALADJumpIsShowKey]) {
        // 删除之前后台存储的时间
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSaveTimeWhenEnterBackgroud];
        self.isBackgroundIn = NO;
        if (self.oldDataDic[kALADJumpImageUrlKey] != nil) {
            // 显示广告图片
            NSString *imagefilePath = [self getFilePath:kAdImageDataName];
            ALADJumpView *adJumpView = [[ALADJumpView alloc] initAdJumpViewFrame:CGRectMake(0, 0,PHONE_WIDTH , PHONE_HEIGH) andWithAppType:self.appType  withDataDic:self.oldDataDic withCustomerButton:self.customerButton ];
            adJumpView.filePath = imagefilePath;
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
        _oldDataDic = [self getADData];
        self.customerButton = customeButton;
        [self addNotice];
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
 * @brief 添加app进入后台通知
 */
- (void)addNotice {
    
    //监控 app 活动状态，打电话/锁屏 时暂停播放
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(appDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
}

/**
 * @brief 进入后台保存时间
 * @param notice 通知
 */
- (void)appDidEnterBackground:(NSNotification *)notice {
    
    [self saveInBackgroundTime];
    self.isBackgroundIn = YES;
}

/**
 * @brief 保存广告
 */
-(void)saveInBackgroundTime {
    // 记录当前的时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kSaveTimeWhenEnterBackgroud];
}


/**
 * @brief图片下载
 * @param dic 广告模型
 */
- (void)downloadADImageWithDataDic:(NSDictionary *)dic {
    dispatch_async(dispatch_get_main_queue(), ^{
        //TODO 异步操作
        //1、下载数据
        NSError *error = nil;
        NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[kALADJumpImageUrlKey]] options:NSDataReadingUncached error:&error];
        UIImage * image = [UIImage imageWithData:data];
        BOOL ret = [UIImagePNGRepresentation(image) writeToFile:[self getFilePath:kAdImageDataName] atomically:YES];
        if (ret) {
            [self saveAdDataWithData:dic];
        }
    });
    
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
- (NSString*)getFilePath:(NSString *)fileName {

    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.filePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    NSString *filePath = [self.filePath stringByAppendingPathComponent:fileName];
    return filePath;
}


/**
 * @brief 归档方法获取model
 * @param dic 保存基本信息
 */
- (void)saveAdDataWithData:(NSDictionary *)dic {
    
    if ([NSKeyedArchiver archiveRootObject:dic toFile:[self getFilePath:kAdInfoDataName]]) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
}

/**
 * @brief  从沙盒中获取广告基本信息
 * @return Dic
 */
- (NSDictionary *)getADData{
    
    NSData *data = [NSData dataWithContentsOfFile:[self getFilePath:kAdInfoDataName]];
   return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


/**
 * @brief  获取图片image.
 * @return imageData
 */
- (UIImage *)getADImageData {
    return [UIImage imageWithContentsOfFile:[self getFilePath:kAdImageDataName]];
}

/**
 * @brief 处理广告数据
 * @param dic 网络请求得到的新model
 */
- (void)handleDataWithDic:(NSDictionary *)dic {
    
    //    // 图片不一样重新下载图片
    //    if (dic[kALADJumpLinkUrlKey] == nil || ![[self.oldDataDic objectForKey:kALADJumpImageUrlKey] isEqualToString:self.adModel.adImageUrl]) {
    // 异步下载图片
    [self downloadADImageWithDataDic:dic];
    //    }
}

/**
 * @brief 是否需要显示广告
 * 1、如果是启动app 需要显示广告
 * 2、至于后台后重启的时间是否达到了规定的时间
 * @return YES/NO
 */
- (BOOL)isShowADView {
    
    // 如果不是从后台进入不需要判断
    if (!self.isBackgroundIn) {
        // 移除当前的时间
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSaveTimeWhenEnterBackgroud];
        return YES;
    }
    
    NSTimeInterval lastMoreTime = [self.oldDataDic[kALADAppInBackgroundTimeKey] doubleValue] ? [self.oldDataDic[kALADAppInBackgroundTimeKey] doubleValue] : kDefaultTimeBackgroud;
    //3. 获取进入后台时长
    NSDate *lastInBackgroundTime = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveTimeWhenEnterBackgroud];
    NSTimeInterval interVal =[[NSDate date] timeIntervalSinceDate:lastInBackgroundTime];
    return interVal > lastMoreTime;
}

/**
 * @brief 检查是否存在广告视图
 * @return YES/NO
 */
+ (BOOL)checkIsExistAdJumpView {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[ALADJumpView class]]) {
            return YES;
        }
    }
    return NO;

}

/**
 * @brief 操作广告视图
 * @param isBringToFront 是否置于window前
 * @param isRemove       是否移除广告
 注意：二者操作取反
 */
+ (void)handleAdJumpViewWithBringToFront:(BOOL)isBringToFront orRemove:(BOOL)isRemove {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[ALADJumpView class]]) {
            if (isRemove) {
                [view removeFromSuperview];
            }else{
                if (isBringToFront) {
                    [window bringSubviewToFront:view];
                }
            }
        }
    }

}

#pragma mark -delegate
/**
 * @brief ALADJumpAppType 跳转
 * @param linkUrl 跳转url
 */
-(void)adJumpImageViewDidClick:(NSString *)linkUrl {
    //执行跳转 Block
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpViewDidClick:)]) {
        [self.delegate ALADJumpViewDidClick:linkUrl];
    }
}

/**
 * @brief 广告视图将要出现
 */
- (void)ALADJumpViewWillAppear {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpViewWillApear:)]) {
        [self.delegate ALADJumpViewWillApear:self];
    }
}

/**
 * @brief 广告视图将要消失
 */
- (void)ALADJumpViewWillDisAppear {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALADJumpViewWillDisapear:)]) {
        [self.delegate ALADJumpViewWillDisapear:self];
    }

}


#pragma mark -lazy  get set方法
-(void)setAdParam:(NSDictionary *)adParam {
    // 默认广告时长3s
    // 默认app置于后台时长90s
    _adParam = adParam;
    [self handleDataWithDic:adParam];
}
-(void)setFilePath:(NSString *)filePath{
    _filePath = (filePath == nil) ? kadImagePath : filePath;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidEnterBackgroundNotification];
}

@end

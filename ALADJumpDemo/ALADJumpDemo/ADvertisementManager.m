
//
//  ADvertisementManager.m
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/2/22.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "ADvertisementManager.h"
#import "ALADJumpHeader.h"
/** 图片目录 */
#define kadImagePath [kCachPath stringByAppendingPathComponent:@"AD"]

@interface ADvertisementManager()<ALADJumpManagerDelegate>
@end

@implementation ADvertisementManager

/**
 * @brief 显示广告
 */
+ (void)showAD {
    
    [[ADvertisementManager sharedADManager].adManager showADJumpViewWithIsShow:[self isShowAD]];
}

/**
 * @brief 后台启动APP显示广告
 */
+ (void)showADFromBackGround{
    
    if ([self isOverAddTime]) {
        // 删除之前保存的时间
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEnterBackGroundTime"];
        
        [[ADvertisementManager sharedADManager].adManager showADJumpViewWithIsShow:[self isShowAD]];
    }
}

/**
 * @brief 保存app进入后台时的时间
 */
+ (void)saveCurrentDataWhenAPPBackInGround{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"kEnterBackGroundTime"];
    
}

/**
 * @brief 是否超过广告所进入后台的时间
 */
+ (BOOL)isOverAddTime {
    
    // 判断时间
    // 判断是否超过1分钟
    NSDate *enterBackGroundDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"kEnterBackGroundTime"];
    if (enterBackGroundDate) {
        
        NSDictionary *dic = [[ADvertisementManager sharedADManager].adManager getADInfoDataWithFilePath:kadImagePath];
        NSTimeInterval lastMoreTime = [[dic objectForKey:kALADAppInBackgroundTimeKey] doubleValue];
        NSTimeInterval interVal =[[NSDate date] timeIntervalSinceDate:enterBackGroundDate];
        return interVal > lastMoreTime;
    }
    return YES;
}


/** 单例 */
static id _instance;
+ (instancetype)sharedADManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


/**
 * @brief 网络请求
 */
- (void)adRequest {
    
    NSLog(@"ad网络请求");
    NSString *adImageUrl = @"https://img99.allinmd.cn/ad/2016/03/26/1048_1458959950469.jpg";
    NSString *linkUrl = @"scene=1,type=1,category=0,keyword=关节,sort=0,tplPath=0,skipUrl=0";
    NSInteger adContitueTime = 3;
    NSInteger appInBackgroundTime = 3;
    NSMutableDictionary *adDic = [NSMutableDictionary dictionary];
    [adDic setObject:adImageUrl forKey:kALADJumpImageUrlKey];
    [adDic setObject:linkUrl forKey:kALADJumpLinkUrlKey];
    [adDic setValue:@(adContitueTime) forKey:kALADJumpContinueTimeKey];
    [adDic setValue:@(appInBackgroundTime) forKey:kALADAppInBackgroundTimeKey];
    [adDic setObject:@(YES) forKey:kALADJumpIsShowKey];
    self.adManager.adParam = adDic;
}

/**
 * @brief  当前界面是否显示AD
 * @return YES / NO
 */
+ (BOOL)isShowAD{
    
    return YES;
}


/**
 * @brief 创建浏览日志
 */
- (void)createBraouseLogRequestWithDate:(NSDate *)date{
    
    NSLog(@"进行了浏览日志请求");
}


/**
 * @brief 点击广告跳转
 */
- (void)handleJumpUrl{
    NSLog(@"跳转");
}

#pragma mark -ALADJumpManagerDelegate
-(void)ALADJumpUpdateALADData:(ALADJumpManager *)manager {
    [self adRequest];
}

- (void)ALADJumpViewWillApear:(ALADJumpManager *)manager {
    
    [self createBraouseLogRequestWithDate:[NSDate date]];
}

-(void)ALADJumpViewWillDisapear:(ALADJumpManager *)manager {
    
    [self createBraouseLogRequestWithDate:[NSDate date]];
    self.adManager = nil;
    
}

-(void)ALADJumpViewDidClick:(NSString *)linkUrl {

    [self handleJumpUrl];
}

#pragma mark-lazy
-(ALADJumpManager *)adManager{
    
    if (!_adManager) {
        
        UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 100)];
        customBtn.backgroundColor = [UIColor cyanColor];
        _adManager = [[ALADJumpManager alloc] initALADJumpManagerWithFilePath:kadImagePath andWithAPPType: eALADMedPlus withCustomerButton: nil];
        _adManager.delegate = self;
    }
    return _adManager;
}

@end

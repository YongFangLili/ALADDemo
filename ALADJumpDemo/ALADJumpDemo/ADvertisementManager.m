
//
//  ADvertisementManager.m
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/2/22.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "ADvertisementManager.h"
#import "ALADDefineHeader.h"

@interface ADvertisementManager()<ALADJumpManagerDelegate>

@end

@implementation ADvertisementManager


+ (void)showAD {
    [[ADvertisementManager sharedADManager].adManager showADJumpViewWithIsShow:YES];
}

/**
 *  单例
 */
static id _instance;
+ (instancetype)sharedADManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


/**
 *  网络请求
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
 *  是否所有的界面显示AD
 *
 *  @return YES / NO
 *
 */
- (BOOL)isAllViewShowAD{
    
    return YES;
}


/**
 *  创建浏览日志
 */
- (void)createBraouseLogRequestWithDate:(NSDate *)date{
    
    NSLog(@"进行了浏览日志请求");
}


/**
 *  点击广告跳转
 */
- (void)handleJumpUrl{
    
    NSLog(@"跳转");
}

#pragma mark -ALADJumpManagerDelegate

- (void)ALADJumpViewWillApear:(ALADJumpManager *)manager {
    
    [self createBraouseLogRequestWithDate:[NSDate date]];
    
}

-(void)ALADJumpViewWillDisapear:(ALADJumpManager *)manager {
    
    [self createBraouseLogRequestWithDate:[NSDate date]];
    
}

-(void)ALADJumpViewDidClick:(NSString *)linkUrl {

}

-(ALADJumpManager *)adManager{
    
    if (!_adManager) {
        
        UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 100)];
        customBtn.backgroundColor = [UIColor cyanColor];
        _adManager = [[ALADJumpManager alloc] initALADJumpManagerWithFilePath:kadImagePath
                                                    andWithAPPType: eALADMedPlus
                                                withCustomerButton: nil
                                                 ];
        _adManager.delegate = self;
    }
    return _adManager;
}








@end

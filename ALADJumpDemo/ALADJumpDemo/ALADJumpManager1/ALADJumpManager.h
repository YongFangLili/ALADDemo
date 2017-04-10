//
//  ALADJumpManager.h
//  MedplusSocial
//
//  Created by liyongfang on 2017/2/13.
//  Copyright © 2017年 北京欧创医疗技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALADJumEnum.h"
#import "ALADJumpView.h"
#import "ALADJumpHeader.h"
@class ALADJumpManager;

@protocol ALADJumpManagerDelegate <NSObject>
/**
 * @brief 更新广告数据
 * @param manager manager
 */
- (void)ALADJumpUpdateALADData:(ALADJumpManager *)manager;

/**
 * @brief 广告视图即将显示
 * @param manager manager
 */
- (void)ALADJumpViewWillApear:(ALADJumpManager *)manager;

/**
 * brief 广告视图即将消失
 * @param manager manager
 */
- (void)ALADJumpViewWillDisapear:(ALADJumpManager *)manager;

/**
 * @brief 广告点击
 * @param linkUrl 点击 url
 */
- (void)ALADJumpViewDidClick:(NSString*)linkUrl;

@end

@interface ALADJumpManager : NSObject

/** 广告所需传入的参数 更新完成后必须传入参数
 图片下载地址              kALADJumpImageUrlKey
 广告跳转                 kALADJumpLinkUrlKey
 广告持续时间              kALADJumpLinkUrlKey
 广告持续时间              kALADJumpContinueTimeKey
 程序置于后台多长时间显示    kALADAppInBackgroundTimeKey
 是否显示广告              kALADJumpIsShowKey
 */
@property (nonatomic, strong) NSDictionary *adParam;

/** delegate */
@property (nonatomic, weak) id<ALADJumpManagerDelegate>delegate;

/**
 * @brief   创建广告Manager
 * @param   filePath          文件路径
 * @param   appType           app类型
 * @param   customeButton     自定义Button
 * @return  adManager
 */
- (instancetype)initALADJumpManagerWithFilePath : (NSString *)filePath
                                 andWithAPPType : (ALADJumpAppType)appType
                              withCustomerButton: (UIButton *)customeButton;


/**
 * @brief 初始化自定义广告视图.
 * 此时manager仅仅只进行数据的逻辑处理.
 */
- (instancetype)initALADJumpCustomerViewWithFilePath:(NSString *)filePath;

/**
 * @brief 添加广告视图
 * @param isShow 是否在当前界面显示广告
 */
- (void)showADJumpViewWithIsShow:(BOOL)isShow;

/**
 * @brief  从沙盒中获取图片image
 * @param  filePath 文件路径
 * @return 广告图片数据
 */
- (UIImage *)getADImageDataWithFilePath:(NSString *)filePath;

/**
 * @brief  从沙盒中获取广告数据
 * @param  filePath 文件路径
 * @return 广告数据
 */
- (NSDictionary *)getADInfoDataWithFilePath:(NSString *)filePath;

/**
 * @brief 删除imageData
 * @param filePath 文件路径
 */
- (void)deleteOldImageDataWithFilePath:(NSString *)filePath;


@end

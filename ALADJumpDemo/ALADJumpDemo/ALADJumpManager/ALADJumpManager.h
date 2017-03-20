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

/** 广告所需传入的参数 */
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
 * @brief 从沙盒中获取图片image.
 */
- (UIImage *)getADImageData;

/**
 * @brief 从沙盒中获取广告数据模型
 * @return ALADModel 广告数据模型
 */
- (NSDictionary *)getADData;

/**
 * @brief 保存广告数据
 * @param dic 数据字典
 */
- (void)saveAdDataWithData:(NSDictionary *)dic;

/**
 * @brief 删除imageData
 */
- (void)deleteOldImageData;

/**
 * @brief 检查是否存在广告视图
 * @return YES/NO
 */
+ (BOOL)checkIsExistAdJumpView;

/**
 * @brief 操作广告视图
 * @param isBringToFront 是否置于window前
 * @param isRemove       是否移除广告
 * 注意：二者操作取反
 */
+ (void)handleAdJumpViewWithBringToFront:(BOOL)isBringToFront orRemove:(BOOL)isRemove;

@end

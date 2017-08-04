//
//  ALADJumpView.h
//  MedplusSocial
//
//  Created by liyongfang on 2017/2/13.
//  Copyright © 2017年 北京欧创医疗技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALADJumpView.h"
#import "ALADJumEnum.h"
#import "ALADJumpConstant.h"

@class ALADJumpView,ALADJumpViewController;
@protocol ALADJumpViewDelegate <NSObject>
/**
 * @brief 点击广告图事件
 * @param linkUrl 广告跳转字段
 */
- (void)adJumpImageViewDidClick:(NSString *)linkUrl;

/**
 * @brief 广告即将显示
 */
- (void)adJumpViewWillAppear;

/**
 * @brief 广告即消失
 */
- (void)adJumpViewWillDisAppear;
@end


@interface ALADJumpView : UIWindow

/** ad数据 */
@property (nonatomic, strong) UIImage *adImage;
/** linkUrl跳转 */
@property (nonatomic, copy) NSString *linkUrl;
/** 广告持续时长 */
@property (nonatomic, assign) NSInteger adContineTime;
/**记录当前的秒数*/
@property (nonatomic,assign) NSInteger  count;
/**存放图片文件路径*/
@property (nonatomic, copy) NSString *filePath;
/**app类型*/
@property (nonatomic, assign) ALADJumpAppType appType;
/**自定义button类型*/
@property (nonatomic, strong) UIButton *customerButton;
/**代理*/
@property (nonatomic, weak) id<ALADJumpViewDelegate>delegate;
/** 跳转VC */
@property (nonatomic, strong) ALADJumpViewController *adJumpVC;

/**
 * @brief 显示广告
 */
- (void)showAD;




@end

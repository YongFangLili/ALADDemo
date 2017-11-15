//
//  ALADJumpViewController.h
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/7/3.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALADJumpHeader.h"

@protocol ALADJumpViewControllerDelegate <NSObject>

/* @brief 点击广告图事件
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

@interface ALADJumpViewController : UIViewController

/** 自定义button */
@property (nonatomic, strong) UIButton * customerButton;
/** 广告类型 */
@property (nonatomic, assign) ALADJumpAppType appType;
/** adimage图 */
@property (nonatomic, strong) UIImage *adImage;
/** 跳转链接 */
@property (nonatomic, copy) NSString *linkUrl;
/** 广告持续秒数 */
@property (nonatomic, assign) NSInteger adContineTime;
/**记录当前的秒数*/
@property (nonatomic,assign) NSInteger  count;
/**存放图片文件路径*/
@property (nonatomic, copy) NSString *filePath;
/**代理*/
@property (nonatomic, weak) id<ALADJumpViewControllerDelegate>delegate;

@end

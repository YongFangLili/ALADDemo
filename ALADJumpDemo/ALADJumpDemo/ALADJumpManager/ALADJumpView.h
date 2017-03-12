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
@class ALADJumpView;
@protocol ALADJumpViewDelegate <NSObject>
/**
 点击广告图事件
 @param linkUrl 广告模型
 */
-(void)adJumpImageViewDidClick:(NSString *)linkUrl;

- (void)ALADJumpViewWillAppear;

- (void)ALADJumpViewWillDisAppear;
@end

@interface ALADJumpView : UIView

/** ad数据 */
@property (nonatomic, strong) NSDictionary *adDic;

/**记录当前的秒数*/
@property (nonatomic,assign) NSInteger  count;

/**存放文件路径*/
@property (nonatomic, copy) NSString *filePath;

/**代理*/
@property (nonatomic, weak) id<ALADJumpViewDelegate>delegate;



- (instancetype)initAdJumpViewFrame: (CGRect)frame
                     andWithAppType: (ALADJumpAppType)appType
                        withDataDic: (NSDictionary *)dataDic
                 withCustomerButton: (UIButton *)customerButton;

/**显示广告*/
- (void)showAD;

/**广告页消失*/
- (void)dismissAD;

/**广告页跳转*/
- (void)handleJumpUrl;


@end

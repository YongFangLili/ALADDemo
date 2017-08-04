//
//  ALADJumpView.m
//  MedplusSocial
//
//  Created by liyongfang on 2017/2/13.
//  Copyright © 2017年 北京欧创医疗技术有限公司. All rights reserved.
//

#import "ALADJumpView.h"
#import "ALADJumpManager.h"
#import "ALADDefineHeader.h"
#import "ALADJumpCache.h"
#import "ALADJumpViewController.h"

@interface ALADJumpView() <ALADJumpViewControllerDelegate>

//@property (nonatomic, strong) UIButton * customerButton;

@end

@implementation ALADJumpView

//- (instancetype)initAdJumpViewFrame: (CGRect)frame
//                     andWithAppType: (ALADJumpAppType)appType
//                 withCustomerButton: (UIButton *)customerButton {
//
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
//        // 设置window的优先级 比状态栏低一级
//        self.adJumpVC = [[ALADJumpViewController alloc] init];
//        self.adJumpVC.delegate = self;
//        self.adJumpVC.appType = appType;
//        self.windowLevel = UIWindowLevelStatusBar -1;
//        self.rootViewController = self.adJumpVC;
//        self.adJumpVC.customerButton = customerButton;
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelStatusBar -1;
        self.adJumpVC = [[ALADJumpViewController alloc] init];
        self.adJumpVC.delegate = self;
        self.rootViewController = self.adJumpVC;
    }
    return self;
}

/**
 * @brief 显示广告到window上
 */
- (void)showAD {
    
    self.adJumpVC.adImage = self.adImage;
    self.adJumpVC.linkUrl  = self.linkUrl;
    self.adJumpVC.adContineTime = self.adContineTime;
    self.adJumpVC.adImage = self.adImage;
    self.adJumpVC.appType = self.appType;
    [self makeKeyAndVisible];
}


#pragma delegate
- (void)adJumpImageViewDidClick:(NSString *)linkUrl {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adJumpImageViewDidClick:)]) {
        [self.delegate adJumpImageViewDidClick:linkUrl];
    }
}

- (void)adJumpViewWillAppear {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adJumpViewWillAppear)]) {
        [self.delegate adJumpViewWillAppear];
    }
}

- (void)adJumpViewWillDisAppear {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adJumpViewWillDisAppear)]) {
        [self.delegate adJumpViewWillDisAppear];
        self.adJumpVC = nil;
    }
}

#pragma mark -getters and setters

- (void)dealloc {
    
    NSLog(@"window广告view dellog了");
}
@end

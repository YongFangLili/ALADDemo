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

@interface ALADJumpView()
/** 广告图片 */
@property (nonatomic, strong) UIImageView *adImageView;

/** 显示倒计时button */
@property (nonatomic, strong) UIButton *timerButton;

/** 定时器 */
@property (nonatomic, strong) NSTimer *countTimer;

/** 自定义button */
@property (nonatomic, strong) UIButton * customerButton;

/** 自定义视图 */
@property (nonatomic, assign) ALADJumpView *adCustomerView;


@end

@implementation ALADJumpView

- (instancetype)initAdJumpViewFrame: (CGRect)frame
                     andWithAppType: (ALADJumpAppType)appType
                        withDataDic: (NSDictionary *)dataDic
                 withCustomerButton: (UIButton *)customerButton {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 设置window的优先级
        self.windowLevel = UIWindowLevelAlert + UIWindowLevelAlert;
        _adDic = dataDic;
        if (customerButton) {
            _customerButton = customerButton;
        }else{
        }
        [self setUpUIWithAppType:appType];
    }
    return self;
}

/**
 * @brief 创建 UI
 * @param appType APP类型
 */
- (void)setUpUIWithAppType:(ALADJumpAppType)appType {
    
    [self addSubview:self.adImageView];
    // imageView
    self.adImageView.frame = CGRectMake(0, 0, kPHONE_WIDTH, kPHONE_HEIGH);
    [self addSubview:self.timerButton];
    [self.timerButton setTitle:[NSString stringWithFormat:@"跳过 %ld",[[self.adDic objectForKey:kALADJumpContinueTimeKey] integerValue]] forState:UIControlStateNormal];
    [self makeKeyAndVisible];
}

/**
 * @brief 显示广告到window上
 */
- (void)showAD {
    
    self.adImageView.image = [UIImage imageWithContentsOfFile:self.filePath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(adJumpViewWillAppear)]) {
        [self.delegate adJumpViewWillAppear];
    }
    // 开始倒计时
    [self startTimer];
}

/**
 * @brief 广告跳转
 */
- (void)handleJumpUrl {
    
    if (self.adDic[kALADJumpLinkUrlKey] == nil) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(adJumpImageViewDidClick:)]) {
        [self.delegate adJumpImageViewDidClick:self.adDic[kALADJumpLinkUrlKey]];
    }
    [self dismissAD];
}

/**
 * @brief 开启定时器
 */
- (void)startTimer {
    
    // 默认为3秒
    NSInteger time = [self.adDic[kALADJumpContinueTimeKey] integerValue];
    self.count = time ? time : kDefaultTimeContineAd;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

/**
 * @brief 定时器响应.
 */
- (void)countDownEventHandle {
    
    self.count--;
    if (_count > 0) {
        [self.timerButton setTitle:[NSString stringWithFormat:@"跳过 %ld",(long)_count] forState:UIControlStateNormal];
    }
    if (_count == 0) {
        [self dismissAD];
    }
}

/**
 @brief 移除广告视图
 */
- (void)dismissAD {
    
    NSLog(@"点击了广告");
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(adJumpViewWillDisAppear)]) {
            [self.delegate adJumpViewWillDisAppear];
        }
    }];
}

#pragma mark -getters and setters
- (void)setCount:(NSInteger)count {
    
    _count = count;
    if (_count > 0 && self.adCustomerView) {
         self.adCustomerView.count = count;
    }
}

- (NSTimer *)countTimer {
    
    if (_countTimer == nil) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownEventHandle) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (UIImageView *)adImageView {
    
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.backgroundColor = [UIColor whiteColor];
        _adImageView.contentMode = UIViewContentModeScaleAspectFit;
        _adImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleJumpUrl)];
        [_adImageView addGestureRecognizer:clickTap];
    }
    return _adImageView;
}

- (UIButton *)timerButton {
    
    if (!_timerButton) {
        
        if (self.customerButton) {
            _timerButton = self.customerButton;
        }else{
            _timerButton = [[UIButton alloc] init];
             _timerButton.layer.cornerRadius = 2.0;
            _timerButton.layer.masksToBounds = YES;
            [_timerButton setTitleColor:kRGBACOLOR(98, 111, 140, 1) forState:UIControlStateNormal];
            [_timerButton setBackgroundColor:kRGBACOLOR(240, 245, 248, 0.7)];
            CGSize buttonSize = CGSizeMake( 55.0 * kScreenScaleWidth, 25 * kScreenScaleHeight);
            _timerButton.frame = CGRectMake(kPHONE_WIDTH-buttonSize.width -17 * kScreenScaleWidth, 22 * kScreenScaleHeight, buttonSize.width, buttonSize.height);
            [_timerButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        }
        [_timerButton addTarget:self action:@selector(dismissAD) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timerButton;
}

- (void)dealloc {
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    NSLog(@"父类广告viewdellog了");
}


@end

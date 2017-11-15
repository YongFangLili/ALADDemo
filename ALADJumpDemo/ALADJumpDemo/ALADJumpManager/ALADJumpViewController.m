//
//  ALADJumpViewController.m
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/7/3.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "ALADJumpViewController.h"

@interface ALADJumpViewController ()

/** 广告图片 */
@property (nonatomic, strong) UIImageView *adImageView;
/** 显示倒计时button */
@property (nonatomic, strong) UIButton *timerButton;
/** 定时器 */
@property (nonatomic, strong) NSTimer *countTimer;

@end

@implementation ALADJumpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.timerButton setTitle:[NSString stringWithFormat:@"跳过 %ld",(long)self.adContineTime] forState:UIControlStateNormal];
    [self startTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if ([self.delegate respondsToSelector:@selector(adJumpViewWillAppear)]) {
        [self.delegate adJumpViewWillAppear];
    }
}

/**
 * @brief 广告跳转
 */
- (void)handleJumpUrl {
    
    if (self.linkUrl == nil) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(adJumpImageViewDidClick:)]) {
        [self.delegate adJumpImageViewDidClick:self.linkUrl];
    }
    [self dismissAD];
}

/**
 * @brief 开启定时器
 */
- (void)startTimer {
    
    // 默认为3秒
    NSInteger time = self.adContineTime;
    _count = time ? time : kALAD_DefaultTimeContineAd;
    if (_count == 0) {
        _count = kALAD_DefaultTimeContineAd;
    }
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

/**
 * @brief 定时器响应.
 */
- (void)countDownEventHandle {
    
    _count--;
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
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
         [self.view.window resignKeyWindow];
        if ([self.delegate respondsToSelector:@selector(adJumpViewWillDisAppear)]) {
            [self.delegate adJumpViewWillDisAppear];
        }
    }];
}

#pragma mark -getters and setters

- (void)setAppType:(ALADJumpAppType)appType {
    
    _appType = appType;
    switch (appType) {
        case eALADAllimd:
        case eALADMedPlus:
        case eALADYding:
        {
            [self.view addSubview:self.adImageView];
            self.adImageView.frame = CGRectMake(0, 0, kALAD_PHONE_WIDTH, kALAD_PHONE_HEIGH);
        }
            break;
        default:
            [self.view addSubview:self.adImageView];
            self.adImageView.frame = CGRectMake(0, 0, kALAD_PHONE_WIDTH, kALAD_PHONE_HEIGH);
            break;
    }
    
    [self.view addSubview:self.timerButton];
    [self.timerButton setTitle:[NSString stringWithFormat:@"跳过 %ld",(long)self.adContineTime] forState:UIControlStateNormal];
}

- (void)setAdImage:(UIImage *)adImage {
    
    _adImage = adImage;
    self.adImageView.image = adImage;
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
            [_timerButton setTitleColor:kALAD_RGBACOLOR(98, 111, 140, 1) forState:UIControlStateNormal];
            [_timerButton setBackgroundColor:kALAD_RGBACOLOR(240, 245, 248, 0.7)];
            CGSize buttonSize = CGSizeMake( 55.0 * kALAD_ScreenScaleWidth, 25 * kALAD_ScreenScaleHeight);
            _timerButton.frame = CGRectMake(kALAD_PHONE_WIDTH-buttonSize.width -17 * kALAD_ScreenScaleWidth, 22 * kALAD_ScreenScaleHeight, buttonSize.width, buttonSize.height);
            [_timerButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        }
        [_timerButton addTarget:self action:@selector(dismissAD) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timerButton;
}

- (void)dealloc {
    
    [_countTimer invalidate];
    _countTimer = nil;
}

@end

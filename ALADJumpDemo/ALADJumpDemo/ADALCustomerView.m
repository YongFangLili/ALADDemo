
//
//  ADALCustomerView.m
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/2/24.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "ADALCustomerView.h"
#import "ALADJumpHeader.h"
/** 图片目录 */
#define kadImagePath [kCachPath stringByAppendingPathComponent:@"AD"]

static NSInteger  const adTime = 3;
static CGFloat const btnWidth = 60.0f;
static  CGFloat const btnHeight = 30.0f;

@interface ADALCustomerView()
/** 广告图片 */
@property (nonatomic,strong) UIImageView * imgVAD;
/** 广告下部唯医图片 */
@property (nonatomic,strong) UIImageView * imgVBack;
/** 记录时间 */
@property (nonatomic,strong) UIButton * btnCount;
/** 定时器 */
@property (nonatomic,strong) NSTimer  * countTimer;
/** 记录当前秒数 */
@property (nonatomic,assign) NSInteger  count;
/** 进入时间 */
@property (nonatomic , copy) NSString *enterTime;
/**ALADmanager */
@property (nonatomic, strong) ALADJumpManager *adManager;

@end
@implementation ADALCustomerView

/**
 * @brief 显示广告.
 */
- (void)showAD {
    
    if ([self isShowAd]) {
        [self startTimer];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [window bringSubviewToFront:self];
    }
    // 更新数据源
    [self updateADData];
}

/**
 * @brief 是否显示广告.
 */
- (BOOL)isShowAd {
    
   
//    if (dic[kALADJumpIsShowKey] && dic[kALADJumpImageUrlKey] && adImage) {
//        self.imgVAD.image = adImage;
//        return YES;
//    }
    return NO;
}

/**
 * @brief 更新广告数据
 */
- (void)updateADData {
    
    NSLog(@"ad网络请求");
    NSString *adImageUrl = @"https://img99.allinmd.cn/ad/2016/03/26/1048_1458959950469.jpg";
    NSString *linkUrl = @"scene=1,type=1,category=0,keyword=关节,sort=0,tplPath=0,skipUrl=0";
    NSInteger adContitueTime = 10;
    NSInteger appInBackgroundTime = 3;
    NSMutableDictionary *adDic = [NSMutableDictionary dictionary];
    
//    [adDic setObject:adImageUrl forKey:kALADJumpImageUrlKey];
//    [adDic setObject:linkUrl forKey:kALADJumpLinkUrlKey];
    [adDic setValue:@(adContitueTime) forKey:kALADJumpContinueTimeKey];
    [adDic setValue:@(appInBackgroundTime) forKey:kALADAppInBackgroundTimeKey];
    [adDic setObject:@(YES) forKey:kALADJumpIsShowKey];
    // 存储广告
    self.adManager.adParam = adDic;
}

/**
 * @brief 开始定时器
 */
- (void)startTimer {
    
    _count = adTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        [self addSubview:_imgVAD];
        [self addSubview:_btnCount];
       
        _imgVAD.backgroundColor = [UIColor cyanColor];
    }
    return self;
}

/**
 * @brief 初始化 UI
 */
- (void)setUpUI {
    //广告图片
    _imgVAD= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height)];
    _imgVAD.userInteractionEnabled = YES;
    _imgVAD.backgroundColor =  [UIColor yellowColor];
    
    _imgVAD.contentMode = UIViewContentModeScaleAspectFill;
    _imgVAD.clipsToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesHandle:)];
    [_imgVAD addGestureRecognizer:tap];
    //2.跳过按钮
    _btnCount = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCount.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-btnWidth-24, btnHeight, btnWidth, btnHeight);
    [_btnCount addTarget:self action:@selector(dismissAD) forControlEvents:UIControlEventTouchUpInside];
    _btnCount.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnCount setTitle:[NSString stringWithFormat:@"跳过 %ld",(long)adTime] forState:UIControlStateNormal];
    [_btnCount setBackgroundImage:[UIImage imageNamed:@"home_page_skip.png"] forState:UIControlStateNormal];
    _btnCount.layer.cornerRadius = 4;
}

/**
 *  @brief 广告页面的点击.
 */
- (void)tapGesHandle:(UITapGestureRecognizer *)tap {
    
    [self dismissAD];
}

/**
 *  @brief 定时器响应.
 */
- (void)countDownEventHandle {
    
    _count--;
    [_btnCount setTitle:[NSString stringWithFormat:@"跳过 %ld",(long)_count] forState:UIControlStateNormal];
    if (_count == 1) {
        
        [self dismissAD];
    }
}

/**
 *  @brief 使广告页消失.
 */
- (void) dismissAD {
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark - 懒加载
- (UIImageView *)imgVBack {
    
    if (!_imgVBack) {
        _imgVBack = [[UIImageView alloc]init];
        _imgVBack.image = [UIImage imageNamed:@"home_page_ad"];
        [self addSubview:_imgVBack];
    }
    return _imgVBack;
    
}
- (NSTimer *)countTimer {
    
    if (_countTimer == nil) {
        
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownEventHandle) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (ALADJumpManager *)adManager {
    
    if (!_adManager) {
        _adManager = [[ALADJumpManager alloc] initALADJumpCustomerViewWithFilePath:kALAD_CachPath];
    }
    return _adManager;
}

@end

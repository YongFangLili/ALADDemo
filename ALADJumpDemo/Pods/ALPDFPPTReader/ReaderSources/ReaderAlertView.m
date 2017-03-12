//
//  ReaderAlertView.m
//  customAlertViewDemo
//
//  Created by liyongfang on 16/7/1.
//  Copyright © 2016年 liyongfang. All rights reserved.
//

#import "ReaderAlertView.h"

#define Off_Set -5
#define Alpha_Value 1
#define RGBACOLOR(R,G,B,a) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(a)]
/// 屏幕宽高.
#define PHONE_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGHT        [[UIScreen mainScreen] bounds].size.height
#define kScreenScaleWidth   [UIScreen mainScreen].bounds.size.width/375.0
#define kScreenScaleHeight  ([UIScreen mainScreen].bounds.size.height/667.0==1 ? \
1:[UIScreen mainScreen].bounds.size.height/667.0)

static CGFloat const pubAlpha = 1.0f;
static CGFloat const backGroundAlpha = 0.6f;
static CGFloat const animationTime = 0.3f;
@interface ReaderAlertView()
/**
 *  背景view
 */
@property (nonatomic, strong) UIView * backgroundView;
/**
 *  buttonview
 */
@property (nonatomic, strong) UIView * buttonView;
/**
 *  提示标题label
 */
@property (nonatomic, strong) UILabel * titleLabel;
/**
 *  提示view
 */
@property (nonatomic, strong) UIView * messageView;
/**
 *  提示信息label
 */
@property (nonatomic, strong) UILabel * messageLabel;
/**
 *  取消按钮
 */
@property (nonatomic, strong) UIButton * cancelButton;
/**
 *  确认按钮
 */
@property (nonatomic, strong) UIButton * configButton;
/**
 *  横线
 */
@property (nonatomic, strong) UIView * sepLineHor;
/**
 *  竖线
 */

@property (nonatomic, strong) UIView * sepLineVer;
/**
 *  标题
 */

@property (nonatomic, copy) NSString *title;
/**
 *  提示信息
 */

@property (nonatomic, copy) NSString  *messageTitle;

@end


@implementation ReaderAlertView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        UIBezierPath *parth = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:3.0];
        self.layer.shadowPath = parth.CGPath;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 5;
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1,1);
        self.layer.shadowOpacity = 0.5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    [self addSubview:self.messageView];
    [self.messageView addSubview:self.titleLabel];
    [self.messageView addSubview:self.messageLabel];
    [self addSubview: self.buttonView];
    [self.buttonView addSubview:self.sepLineHor];
    [self.buttonView addSubview:self.self.sepLineVer];
    [self.buttonView addSubview:self.cancelButton];
    [self.buttonView addSubview:self.configButton];
    
    return self;
    
}
-(void)layoutSubviews{
    [self setViewsFrame];
    [super layoutSubviews];
    
}

- (void)setAlertTitle:(NSString *)alterTitle Message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle configButtonTitle:(NSString *)configButtonTitle {
    
    self.title = alterTitle;
    self.messageTitle = message;
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self.configButton setTitle:configButtonTitle forState:UIControlStateNormal];
    
}

- (void)setCancelButtonTitleColor:(UIColor *)color andFont:(UIFont *)titleFont{
    
    if (color) {
        [self.cancelButton setTitleColor:color forState:UIControlStateNormal];
    }
    if (titleFont) {
        self.cancelButton.titleLabel.font = titleFont;
    }


}
- (void)setConfigButtonTitleColor:(UIColor *)color andFont:(UIFont *)titleFont{
    
    if (color) {
        [self.configButton setTitleColor:color forState:UIControlStateNormal];
    }
    if (titleFont) {
        self.configButton.titleLabel.font = titleFont;
    }

}


-(void)setMessageTitleFont:(UIFont *)messageTitleFont andMessageTitleColor:(UIColor *)messageTitleColor andMessageFont:(UIFont *)messageFont andMessageColor:(UIColor *)messageColor{
    if (messageTitleFont) {
        self.titleLabel.font = messageTitleFont;
    }
    if (messageTitleColor) {
        self.titleLabel.textColor = messageTitleColor;
    }
    
    if (messageFont) {
        self.messageLabel.font = messageFont;
    }
    if (messageColor) {
        self.messageLabel.textColor = messageColor;
    }
}

/**
 * 显示弹框
 */
- (void)show{
    self.backgroundView.alpha = 0.0f;
    self.alpha = 0.0f;
//    [self setViewsFrame];
    [self layoutIfNeeded];
    [UIView animateWithDuration:animationTime animations:^{
        self.backgroundView.alpha = backGroundAlpha;
        self.alpha = 1.0f;
    }completion:^(BOOL finished) {
        self.isShow = YES;
    }];
}

/**
 *  设置子控件frame
 */
-(void)setViewsFrame{
    
    CGFloat sideMargin = 35;
    CGFloat AlertWidth = 270;
    CGFloat labelWidth = AlertWidth - 2 * sideMargin;
    CGFloat yOffset = 20;
    CGFloat buttonHeight = 50;
    CGFloat sepLineHeight = 0.5;
    CGFloat sideButton = 3;
    
    // 获取label文字高度
    CGSize sizeThatFitsMessage = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
    CGSize sizeThatFitsTitle = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundView.frame = CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGHT);
    
    self.frame = CGRectMake(0, 0, AlertWidth, yOffset +10 + buttonHeight/ 2 +buttonHeight + sizeThatFitsTitle.height + sizeThatFitsMessage.height);
    
    CGPoint center = self.center;
    center = [[UIApplication sharedApplication].keyWindow center];
    self.center = center;

    self.messageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    self.titleLabel.frame = CGRectMake(sideMargin, yOffset, labelWidth , sizeThatFitsTitle.height);

    self.messageLabel.frame = CGRectMake(sideMargin, yOffset + sizeThatFitsTitle.height + 10, labelWidth, sizeThatFitsMessage.height);
    
    self.buttonView.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame) + 25, AlertWidth, buttonHeight);
    
    self.sepLineVer.frame = CGRectMake(0, 0, self.buttonView.bounds.size.width, sepLineHeight);
    self.sepLineHor.frame = CGRectMake(self.buttonView.center.x - sepLineHeight / 2, 0, sepLineHeight, self.buttonView.bounds.size.height);
    
    self.cancelButton.frame = CGRectMake(sideButton, sepLineHeight, self.buttonView.bounds.size.width / 2 - sideButton * 2, buttonHeight);
    self.configButton.frame = CGRectMake(self.buttonView.center.x + sideButton, sepLineHeight, self.buttonView.bounds.size.width / 2 - sideButton * 2, buttonHeight);
}

/**
 *  弹框消失
 */
- (void)dismiss{
    
    [UIView animateWithDuration:animationTime animations:^{
        self.backgroundView.alpha = 0.0f;
        self.alpha = 0.0f;
    }completion:^(BOOL finished) {
        self.isShow = NO;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self superview]) {
            [self removeFromSuperview];
        }
        if ([self.backgroundView superview]) {
            [self.backgroundView removeFromSuperview];
        }
    });


}

-(void)setTitle:(NSString *)title{
    
    _title = title;
    
    UIFont *titleFont = [UIFont systemFontOfSize:17];//kFontSiYuan_Medium(17 * kScreenScaleHeight);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSFontAttributeName: titleFont
                                 };
    
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;


}

-(void)setMessageTitle:(NSString *)messageTitle{
    
    _messageTitle = messageTitle;
    UIFont *messageFont = [UIFont systemFontOfSize:14];//kFontSiYuan_Normal(14 * kScreenScaleHeight);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSFontAttributeName: messageFont
                                 };
    
    self.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:messageTitle attributes:attributes];
}

#pragma mark - lazy

- (UIView *)sepLineHor {
    if (!_sepLineHor) {
        _sepLineHor = [[UIView alloc] init];
        _sepLineHor.backgroundColor = RGBACOLOR(219.f, 219.f, 219.f, 1.0f);
    }
    return _sepLineHor;
}

- (UIView *)sepLineVer {
    if (!_sepLineVer) {
        _sepLineVer = [[UIView alloc] init];
        _sepLineVer.backgroundColor = RGBACOLOR(219.f, 219.f, 219.f, 1.0f);
    }
    return _sepLineVer;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        _backgroundView.alpha = backGroundAlpha;
    }
    return _backgroundView;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
        _buttonView.backgroundColor = [UIColor whiteColor];
    }
    return _buttonView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGBACOLOR(51, 51, 51, 1.0);
        
//        _titleLabel.font = kFontSiYuan_Medium(17 * kScreenScaleHeight);
        _titleLabel.numberOfLines = 0;
        _backgroundView.alpha = pubAlpha;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _titleLabel;
}

- (UIView *)messageView {
    if (!_messageView) {
        _messageView = [[UIView alloc] init];
        _messageView.backgroundColor = [UIColor whiteColor];
        _messageLabel.alpha = pubAlpha;
    }
    return _messageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor whiteColor];
//        _messageLabel.textAlignment = NSTextAlignmentCenter;
//        _messageLabel.font = kFontSiYuan_Normal(14 * kScreenScaleHeight);
        _messageLabel.textColor = RGBACOLOR(51, 51, 51, 1.0);
        _messageLabel.numberOfLines = 0;
        
    }
    return _messageLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];//kFontSiYuan_Normal(16 * kScreenScaleHeight);
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)configButton {
    if (!_configButton) {
        _configButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _configButton.backgroundColor = [UIColor whiteColor];
        [_configButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _configButton.titleLabel.font = [UIFont systemFontOfSize:16];//kFontSiYuan_Normal(16 * kScreenScaleHeight);
        [_configButton addTarget:self action:@selector(configButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _configButton;
}

- (void)cancelButtonClicked:(UIButton *)button {
    if (self.cancelBtnClickBlock) {
        self.cancelBtnClickBlock();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(altertView:didSelectedAtIndex:)]) {
        [self.delegate altertView:self didSelectedAtIndex:0];
    }
    [self dismiss];
}

- (void)configButtonClicked:(UIButton *)button {
    if (self.configBtnClickBlock) {
        self.configBtnClickBlock();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(altertView:didSelectedAtIndex:)]) {
        [self.delegate altertView:self didSelectedAtIndex:1];
    }
    [self dismiss];
}





@end

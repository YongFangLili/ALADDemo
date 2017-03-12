//
//  ReaderAlertView.h
//  customAlertViewDemo
//
//  Created by liyongfang on 16/7/1.
//  Copyright © 2016年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReaderAlertView;
@protocol ReaderAlertViewDelegate <NSObject>

-(void)altertView:(ReaderAlertView *)alertView didSelectedAtIndex:(NSInteger)buttonIndex;

@end

@interface ReaderAlertView : UIView

/**
 *  设置弹框内容
 *
 *  @param alterTitle        提示标题
 *  @param message           提示信息
 *  @param cancelButtonTitle 取消按钮标题
 *  @param configButtonTitle 确定按钮标题
 */
- (void)setAlertTitle:(NSString *)alterTitle Message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle configButtonTitle:(NSString *)configButtonTitle ;
/**
 * 设置取消按钮字体颜色和大小
 *
 *  @param color     字体颜色
 *  @param titleFont 字体大小
 */
- (void)setCancelButtonTitleColor:(UIColor *)color andFont:(UIFont *)titleFont;
/**
 *  设置确认按钮内容与字体
 *
 *  @param color     设置确认按钮字体颜色
 *  @param titleFont 设置确认按钮字体
 */
- (void)setConfigButtonTitleColor:(UIColor *)color andFont:(UIFont *)titleFont;
/**
 *  设置标题以及提示信息字体大小与颜色
 *
 *  @param messageTitleFont  提示标题字体
 *  @param messageTitleColor 提示标题字体颜色
 *  @param messageFont       提示信息字体
 *  @param messageColor      提示信息字体颜色
 */
-(void)setMessageTitleFont:(UIFont *)messageTitleFont andMessageTitleColor:(UIColor *)messageTitleColor andMessageFont:(UIFont *)messageFont andMessageColor:(UIColor *)messageColor;

/**
 *  弹框显示
 */
- (void)show;

/**
 *  弹框消失
 */
- (void)dismiss;

/**
 *  弹框显示标记
 */

@property(nonatomic,assign)BOOL isShow;

@property(nonatomic, weak)id<ReaderAlertViewDelegate>delegate;
@property(nonatomic, copy) void(^cancelBtnClickBlock)();
@property(nonatomic, copy) void(^configBtnClickBlock)();

@end

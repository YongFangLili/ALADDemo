//
//  ALStatisticBase.m
//  ALStatisticSDK
//
//  Created by ZhangKaiChao on 2016/11/8.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticBase.h"

@implementation UIView (statistic)

/**
 *  统计用 获取视图上文本信息
 *
 *  @return value
 */
- (NSString *)subViewsTextForStatistics
{
    NSMutableArray *arraySubText = [NSMutableArray array];
    for (UIView *subView in [self subviews])
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subView;
            NSString *labelText = [label text];
            if (labelText != nil && [labelText length] > 0)
            {
                [arraySubText addObject:labelText];
            }
        }
        else if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)subView;
            NSString *buttonTitle = [[button titleLabel] text];
            if (buttonTitle != nil && [buttonTitle length] > 0)
            {
                [arraySubText addObject:buttonTitle];
            }
        }
    }
    
    return [arraySubText componentsJoinedByString:@","];;
}

@end



@implementation ALStatisticBase

/**
 *  统计项
 *
 *  @return value
 */
+ (NSDictionary *)statisticsBase {
    return nil;
}

/**
 *  hudview
 *
 *  @return hudview
 */
+ (MBProgressHUD *)hudview {
    @synchronized(self)
    {
        static MBProgressHUD * logHudview = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            logHudview = [[MBProgressHUD alloc] initWithView:
                          [UIApplication sharedApplication].keyWindow];
            logHudview.removeFromSuperViewOnHide = YES;
            logHudview.mode = MBProgressHUDModeText;
        });
        
        if([logHudview isDescendantOfView:[UIApplication sharedApplication].keyWindow] == NO) {
            [[UIApplication sharedApplication].keyWindow addSubview:logHudview];
        }
        
        return logHudview;
    }
}

@end

//
//  ADALCustomerView.h
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/2/24.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADALCustomerView : UIView

- (void)showAD;

@property (nonatomic, copy) void(^removeADViewManagerBlock)();
@end

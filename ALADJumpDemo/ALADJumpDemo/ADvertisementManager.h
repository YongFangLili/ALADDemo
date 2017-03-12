//
//  ADvertisementManager.h
//  ALADJumpDemo
//
//  Created by liyongfang on 2017/2/22.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALADJumpHeader.h"

@interface ADvertisementManager : NSObject


@property (nonatomic, strong) ALADJumpManager *adManager;

/**
 广告单例
 @return 广告
 */
+ (instancetype)sharedADManager;

+ (void)showAD;



@end

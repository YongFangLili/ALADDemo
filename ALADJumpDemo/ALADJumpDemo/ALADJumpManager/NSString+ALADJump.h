//
//  NSString+ALADJump.h
//  ALADJumpDowloader
//
//  Created by liyongfang on 2017/6/23.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ALADJump)

@property(nonatomic,assign,readonly)BOOL xh_isURLString;

@property(nonatomic,copy,readonly,nonnull)NSString *xh_videoName;

@property(nonatomic,copy,readonly,nonnull)NSString *xh_md5String;

-(BOOL)xh_containsSubString:(nonnull NSString *)subString;

@end

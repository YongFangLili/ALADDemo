//
//  ReaderNoNetView.h
//  Pods
//
//  Created by zhangbin on 16/6/20.
//
//

#import <UIKit/UIKit.h>
#import "ReaderEnum.h"
@interface ReaderNoNetView : UIView

//-(instancetype)initWithFrame:(CGRect)frame isMedplus:(BOOL)isMedplus;

-(instancetype)initWithFrame:(CGRect)frame withReaderAppType:(ReaderAppType)appType;

@end

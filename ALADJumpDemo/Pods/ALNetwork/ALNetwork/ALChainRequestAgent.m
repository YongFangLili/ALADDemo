//
//  ALChainRequestAgent.m
//  AllinmdSocial
//
//  Created by ZhangKaiChao on 16/7/15.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALChainRequestAgent.h"
#import "ALChainRequest.h"

@interface ALChainRequestAgent()

@property (strong, nonatomic) NSMutableArray *requestArray;

@end

@implementation ALChainRequestAgent

+ (ALChainRequestAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequest:(ALChainRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeChainRequest:(ALChainRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}


@end

//
//  TestView.m
//  AspectsDemo
//
//  Created by Tim Hsieh on 2021/1/25.
//  Copyright © 2021 R.S. All rights reserved.
//

#import "TestView.h"
#import <Aspects.h>
#import <objc/runtime.h>

@implementation TestView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [UIView aspect_hookSelector:@selector(initWithFrame:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo,CGRect frame){
        NSLog(@"View %@ will appear", aspectInfo.instance);
    } error:nil];
}

@end


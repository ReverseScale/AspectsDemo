//
//  ViewController.m
//  AspectsDemo
//
//  Created by WhatsXie on 2017/12/22.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "ViewController.h"
#import "Cat.h"
#import "TestView.h"
#import <Aspects.h>
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"View Controller %@ will appear animated: %d", aspectInfo.instance, animated);
    } error:NULL];
    
    TestView *customView = [[TestView alloc] init];
    customView.frame = CGRectMake(100, 100, self.view.bounds.size.width - 200, 150);
    customView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:customView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"System View Controller will appear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

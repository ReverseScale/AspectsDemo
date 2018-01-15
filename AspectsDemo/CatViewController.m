//
//  CatViewController.m
//  AspectsDemo
//
//  Created by WhatsXie on 2017/12/26.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "CatViewController.h"

#import "Cat.h"
#import <Aspects.h>
#import <objc/runtime.h>

@interface CatViewController ()

@end

@implementation CatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Class catMetal = objc_getMetaClass(NSStringFromClass(Cat.class).UTF8String);
    
    [catMetal aspect_hookSelector:@selector(classFee) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"Miao~,I am angry~");
    } error:NULL];
    
    [Cat classFee];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

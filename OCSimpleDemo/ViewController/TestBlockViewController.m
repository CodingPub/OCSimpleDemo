//
//  TestBlockViewController.m
//  OCSimpleDemo
//
//  Created by LinXiaoBin on 2018/8/16.
//  Copyright © 2018年 Felink. All rights reserved.
//

#import "TestBlockViewController.h"
#import "TestBlockManager.h"

@interface TestBlockViewController ()

@property (nonatomic, strong) TestBlockManager *manager;

@end

@implementation TestBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test Block";
    self.manager = TestBlockManager.new;
    
    typeof(self) __weak weakSelf = self;
    
    NSUInteger section = 0;
    [self addSection:@"Block Property"];
    [self section:section addCell:@"copy property" action:^{
        [weakSelf testCopyBlockProperty];
    }];
    [self section:section addCell:@"strong property" action:^{
        [weakSelf testStrongBlockProperty];
    }];
    [self section:section addCell:@"block property" action:^{
        [weakSelf testWeakBlockProperty];
    }];
    [self section:section addCell:@"block property with autoreleasepool" action:^{
        [weakSelf testWeakBlockPropertyWithAutoreloeasePool];
    }];
    
    section = 1;
    [self addSection:@"Block Param"];
    [self section:section addCell:@"copy param" action:^{
        [weakSelf testCopyBlockParam];
    }];
    [self section:section addCell:@"strong param" action:^{
        [weakSelf testStrongBlockParam];
    }];
    [self section:section addCell:@"weak param" action:^{
        [weakSelf testWeakBlockParam];
    }];
    [self section:section addCell:@"weak param with autoreleasepool" action:^{
        [weakSelf testWeakBlockParamAutoReleasePool];
    }];
    [self section:section addCell:@"weak param with thread" action:^{
        [weakSelf testWeakBlockParamThread];
    }];
}

- (void)dealloc {
    NSLog(@"TestBlockViewController dealloc");
}

- (void)testCopyBlockProperty {
    self.manager.copyBlock  = ^{
        NSLog(@"exec copy block %@", self);
    };
    
    if (self.manager.copyBlock) {
        self.manager.copyBlock();
    }
}

- (void)testStrongBlockProperty {
    self.manager.strongBlock  = ^{
        NSLog(@"exec strong block %@", self);
    };
    
    if (self.manager.strongBlock) {
        self.manager.strongBlock();
    }
}

- (void)testWeakBlockProperty {
    self.manager.weakBlock = ^{
        NSLog(@"exec weak block %@", self);
    };
    
    if (self.manager.weakBlock) {
        self.manager.weakBlock();
    }
}

- (void)testWeakBlockPropertyWithAutoreloeasePool {
    @autoreleasepool {
        self.manager.weakBlock = ^{
            NSLog(@"exec weak block %@", self);
        };
    }
    
    if (self.manager.weakBlock) {
        self.manager.weakBlock();
    }
}

- (void)testCopyBlockParam {
    [self.manager testWithCopyBlock:^{
        NSLog(@"exec copy block %@", self);
    }];
}

- (void)testStrongBlockParam {
    [self.manager testWithStrongBlock:^{
        NSLog(@"exec strong block %@", self);
    }];
}

- (void)testWeakBlockParam {
    [self.manager testWithWeakBlock:^{
        NSLog(@"exec weak block %@", self);
    }];
}

- (void)testWeakBlockParamAutoReleasePool {
    @autoreleasepool {
        [self.manager testWithWeakBlockAutoreleasePool:^{
            NSLog(@"exec weak block with autoreleasepool %@", self);
        }];
    }
    
    if (self.manager.weakBlock) {
        self.manager.weakBlock();
    }
}

- (void)testWeakBlockParamThread {
    [self.manager testWithWeakBlockThread:^{
        NSLog(@"exec weak block with thread change %@", self);
    }];
}

@end

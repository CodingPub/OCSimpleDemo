//
//  TestBlockManager.m
//  OCSimpleDemo
//
//  Created by LinXiaoBin on 2018/8/16.
//  Copyright © 2018年 Felink. All rights reserved.
//

#import "TestBlockManager.h"


@implementation TestBlockManager

- (void)dealloc
{
    NSLog(@"TestBlockManager dealloc");
}

- (void)simpleBlock:(TestBlock)block
{
    NSLog(@"simpleBlock %@", block);

    if (block) {
        block();
    }
}

- (void)testWithCopyBlock:(TestBlock)block
{
    self.copyBlock = block;
    if (self.copyBlock) {
        self.copyBlock();
    }
}

- (void)testWithStrongBlock:(TestBlock)block
{
    NSLog(@"testWithStrongBlock %@", block);
    self.strongBlock = block;
    NSLog(@"testWithStrongBlock %@", self.strongBlock);

    if (self.strongBlock) {
        self.strongBlock();
    }
}

- (void)testWithWeakBlock:(TestBlock)block
{
    self.weakBlock = block;

    if (self.weakBlock) {
        self.weakBlock();
    }
}

- (void)testWithWeakBlockThread:(TestBlock)block
{
    self.weakBlock = block;
    NSLog(@"%@", block);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.weakBlock) {
            self.weakBlock();
        }
    });
}


@end

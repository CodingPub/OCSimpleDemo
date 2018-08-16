//
//  TestBlockManager.m
//  OCSimpleDemo
//
//  Created by LinXiaoBin on 2018/8/16.
//  Copyright © 2018年 Felink. All rights reserved.
//

#import "TestBlockManager.h"

@implementation TestBlockManager

- (void)dealloc {
    NSLog(@"TestBlockManager dealloc");
}

- (void)testWithCopyBlock:(TestBlock)block {
    self.copyBlock = block;
    if (self.copyBlock) {
        self.copyBlock();
    }
}

- (void)testWithStrongBlock:(TestBlock)block {
    self.strongBlock = block;
    
    if (self.strongBlock) {
        self.strongBlock();
    }
}

- (void)testWithWeakBlock:(TestBlock)block {
    self.weakBlock = block;
    
    if (self.weakBlock) {
        self.weakBlock();
    }
}

- (void)testWithWeakBlockAutoreleasePool:(TestBlock)block {
    @autoreleasepool {
        self.weakBlock = block;
    }
    
    if (self.weakBlock) {
#warning 为何此处能执行
        self.weakBlock();
    }
}

- (void)testWithWeakBlockThread:(TestBlock)block {
    self.weakBlock = block;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#warning 为何此处会崩溃，weakBlock 野指针
            if (self.weakBlock) {
                self.weakBlock();
            }
        });
    });
    
}


@end

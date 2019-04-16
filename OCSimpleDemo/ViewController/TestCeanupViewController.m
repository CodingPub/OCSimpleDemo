//
//  TestCeanupViewController.m
//  OCSimpleDemo
//
//  Created by LinXiaoBin on 2018/9/4.
//  Copyright © 2018年 Felink. All rights reserved.
//

#import "TestCeanupViewController.h"
//#import <ReactiveObjC/ReactiveObjC.h>

#ifndef onExit

/**
 * Returns A and B concatenated after full macro expansion.
 */
#define metamacro_concat(A, B) \
metamacro_concat_(A, B)
#define metamacro_concat_(A, B) A ## B

#if DEBUG
#define rac_keywordify autoreleasepool {}
#else
#define rac_keywordify try {} @catch (...) {}
#endif

/*** implementation details follow ***/
typedef void (^fl_cleanupBlock_t)(void);

static inline void fl_executeCleanupBlock (__strong fl_cleanupBlock_t *block) {
    (*block)();
}

#define onExit \
rac_keywordify \
__strong fl_cleanupBlock_t metamacro_concat(fl_exitBlock_, __LINE__) __attribute__((cleanup(fl_executeCleanupBlock), unused)) = ^

#endif

@interface TestCeanupViewController ()

@end

@implementation TestCeanupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test Cleanup";
    
    typeof(self) __weak weakSelf = self;
    
    NSInteger section = 0;
    [self addSection:@""];
    
    [self section:section addCell:@"simple test" action:^{
        [weakSelf simpleTest];
    }];

    [self section:section addCell:@"Macro" action:^{
        [weakSelf testMacro];
    }];

    [self section:section addCell:@"Semaphore" action:^{
        [weakSelf testSemaphore];
    }];

}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

// 指定一个cleanup方法，注意入参是所修饰变量的地址，类型要一样
// 对于指向objc对象的指针(id *)，如果不强制声明__strong默认是__autoreleasing，造成类型不匹配
//static void stringCleanUp(__strong NSString **string) {
//    NSLog(@"%@", *string);
//}

- (void)simpleTest {
//    NSString *string __attribute__((cleanup(stringCleanUp))) = @"sunnyxx";
}

- (void)testMacro {
    @onExit {
        NSLog(@"yo");
    };
}

- (void)testSemaphore {
    static dispatch_semaphore_t lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = dispatch_semaphore_create(1);
    });
    
    {
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        @onExit {
            dispatch_semaphore_signal(lock);
        };
        NSLog(@"testSemaphore");
    }
    
    {
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        @onExit {
            dispatch_semaphore_signal(lock);
        };
        NSLog(@"testSemaphore 2");
    }
}


@end

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
    
    NSInteger section = 0;
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
    [self section:section addCell:@"weak param with thread" action:^{
        [weakSelf testWeakBlockParamThread];
    }];
    
    
    [self section:section addCell:@"test block" action:^{
        [weakSelf test];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#if 0
#warning 快速测试
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        if (indexPath.section < [self numberOfSectionsInTableView:self.tableView]
            && indexPath.row < [self tableView:self.tableView numberOfRowsInSection:indexPath.section]) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
#endif
    });
}

- (void)testBlock:(TestBlock)block {
    NSLog(@"testBlock %@", block);
    
    if (block) {
        block();
    }
}

- (void)test {
    [self testBlock:^{
        NSLog(@"call test block");
    }];
    
    [self testBlock:^{
        NSLog(@"call test block %@", self);
    }];
}

- (void)dealloc {
    NSLog(@"TestBlockViewController dealloc");
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

- (void)testWeakBlockParamThread {    
    [self.manager testWithWeakBlockThread:^{
        NSLog(@"exec weak block with thread change %@", self);
    }];
}

@end

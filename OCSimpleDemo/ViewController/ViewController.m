//
//  ViewController.m
//  OCSimpleDemo
//
//  Created by LinXiaoBin on 2018/8/16.
//  Copyright © 2018年 Felink. All rights reserved.
//

#import "ViewController.h"
#import "TestBlockViewController.h"
#import "TestCeanupViewController.h"
#import "TestCollectionViewController.h"


@interface ViewController ()
{
}

@property (nonatomic, assign, getter=isOn) BOOL on;

@end


@implementation ViewController

@synthesize on = _on;

- (BOOL)isOn
{
    return _on;
}

- (void)setOn:(BOOL)on
{
    _on = on;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.on = YES;
    NSLog(@"%@", @(self.isOn));
    NSLog(@"%@", @(self.on));
    NSLog(@"%@", @([self isOn]));

    typeof(self) __weak weakSelf = self;
    NSUInteger section = 0;
    [self addSection:@"测试"];
    [self section:section
          addCell:@"Test Block"
           action:^{
               TestBlockViewController *ctrl = [[TestBlockViewController alloc] init];
               [weakSelf.navigationController pushViewController:ctrl animated:YES];
           }];
    [self section:section
          addCell:@"Test Ceanup"
           action:^{
               TestCeanupViewController *ctrl = [[TestCeanupViewController alloc] init];
               [weakSelf.navigationController pushViewController:ctrl animated:YES];
           }];
    [self section:section
          addCell:@"UICollectionView"
           action:^{
               TestCollectionViewController *ctrl = [[TestCollectionViewController alloc] init];
               [weakSelf.navigationController pushViewController:ctrl animated:YES];
           }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

#if 1
#warning 快速测试
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        if (indexPath.section < [self numberOfSectionsInTableView:self.tableView]
            && indexPath.row < [self tableView:self.tableView numberOfRowsInSection:indexPath.section]) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
#endif
    });
}

@end

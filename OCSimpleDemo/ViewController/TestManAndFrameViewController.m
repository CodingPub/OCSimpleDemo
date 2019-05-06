//
//  TestManAndFrameViewController.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/5/6.
//  Copyright © 2019 Felink. All rights reserved.
//

#import "TestManAndFrameViewController.h"
#import <Masonry/Masonry.h>

@interface TestManAndFrameViewController ()

@property (nonatomic, strong) UIView *container;

@end

@implementation TestManAndFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:container];
    self.container = container;
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view).insets(UIEdgeInsetsMake(0, 12, 0, 12));
        make.centerY.equalTo(self.view);
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Tap me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.container.mas_bottom).offset(30);
    }];
    
}

- (void)onButtonClick {
    NSInteger count = self.container.subviews.count + 3;
    count = count > 9 ? 0 : count;
    
    [self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (count == 0) {
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    NSInteger maxCol = 3;
    CGFloat span = 10;
    CGFloat itemSize = (UIScreen.mainScreen.bounds.size.width - 24 - ((maxCol - 1) * span)) / maxCol;
    for (NSInteger i = 0; i<count; i++) {
        NSInteger row = i / maxCol;
        NSInteger col = i % maxCol;
        UIView *view = [[UIView alloc] init];
        CGFloat x = (itemSize + span) * col;
        CGFloat y = (itemSize + span) * row;
        view.frame = CGRectMake(x, y, itemSize, itemSize);
        view.backgroundColor = [UIColor blueColor];
         
        [self.container addSubview:view];

        if (i == count-1) {
            [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(CGRectGetMaxY(view.frame));
            }];
        }
    }
    
}

@end

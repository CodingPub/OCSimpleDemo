//
//  HitTestViewController.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/4/11.
//  Copyright © 2019 Felink. All rights reserved.
//

#import "HitTestViewController.h"
#import "HitTestView.h"
#import <Masonry/Masonry.h>

@interface HitTestViewController ()

@end

@implementation HitTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    HitTestView *viewA = [[HitTestView alloc] initWithTitle:@"A"];
    viewA.backgroundColor = [UIColor orangeColor];
    HitTestView *viewB = [[HitTestView alloc] initWithTitle:@"B"];
    viewB.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    HitTestView *viewC = [[HitTestView alloc] initWithTitle:@"C"];
    viewC.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:viewA];
    [viewA addSubview:viewB];
    [viewA addSubview:viewC];
    
    [viewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [viewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewA);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [viewC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(viewB);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}


@end

//
//  TestSimpleCollectionViewCell.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/7.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import "TestSimpleCollectionViewCell.h"
#import <Masonry/Masonry.h>

@implementation TestSimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.width.equalTo(@(50));
        }];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
            make.height.equalTo(@(60));
        }];
        
        self.contentView.backgroundColor = [UIColor orangeColor];
    }
    return self;
}


+ (NSString *)reuseIdentifier {
    return @"TestSimpleCollectionViewCell";
}

@end

//
//  SimpleHeaderCollectionReusableView.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/7.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import "SimpleHeaderCollectionReusableView.h"
#import <Masonry/Masonry.h>


@interface SimpleHeaderCollectionReusableView ()

@property (nonatomic, strong) UILabel *label;

@end


@implementation SimpleHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];

        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(20, 10, 10, 10));
        }];
    }
    return self;
}

- (UILabel *)label
{
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blueColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        _label = label;
    }
    return _label;
}

- (void)setTitle:(NSString *)title
{
    _title = title.copy;

    self.label.text = title;
}

+ (NSString *)reuseIdentifier
{
    return @"SimpleHeaderCollectionReusableView";
}

@end

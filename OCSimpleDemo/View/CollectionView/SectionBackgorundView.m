//
//  SectionBackgorundView.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/7.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import "SectionBackgorundView.h"


@implementation SectionBackgorundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

+ (NSString *)reuseIdentifier
{
    return @"SimpleHeaderCollectionReusableView";
}

@end

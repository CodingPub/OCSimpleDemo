//
//  HitTestView.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/4/11.
//  Copyright © 2019 Felink. All rights reserved.
//

#import "HitTestView.h"

@implementation HitTestView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title.copy;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%@ hit test", self.title);
    return [super hitTest:point withEvent:event];
}

@end

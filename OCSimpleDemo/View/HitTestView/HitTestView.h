//
//  HitTestView.h
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/4/11.
//  Copyright © 2019 Felink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HitTestView : UIView

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;

@end

//
//  SimpleHeaderCollectionReusableView.h
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/7.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SimpleHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, copy) NSString *title;

+ (NSString *)reuseIdentifier;

@end

//
//  UICollectionView+IGGAutolayoutCell.h
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/8.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+IGGIndexPathCache.h"

/**
 自动计算 CollectionViewCell Size
 */
@interface UICollectionView (IGGAutolayoutCell)

- (CGSize)igg_heightForCellWithIdentifier:(NSString *)identifier
                                indexPath:(NSIndexPath *)indexPath
                                  maxSize:(CGSize)maxSize
                            configuration:(void (^)(id cell))configuration;

@end

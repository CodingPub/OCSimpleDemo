//
//  UICollectionView+IGGIndexPathCache.h
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/8.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IGGIndexPathSizeCache : NSObject

// Enable automatically if you're using index path driven height cache
@property (nonatomic, assign) BOOL automaticallyInvalidateEnabled;

- (BOOL)existsSizeAtIndexPath:(NSIndexPath *)indexPath;
- (void)cacheSize:(CGSize)size byIndexPath:(NSIndexPath *)indexPath;
- (CGSize)heightForIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateSizeAtIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateAllHeightCache;

@end


@interface UICollectionView (IGGIndexPathSizeCache)
/// Height cache by index path. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) IGGIndexPathSizeCache *igg_indexPathSizeCache;
@end


@interface UICollectionView (IGGIndexPathSizeCacheInvalidation)
/// Call this method when you want to reload data but don't want to invalidate
/// all height cache by index path, for example, load more data at the bottom of
/// table view.
- (void)igg_reloadDataWithoutInvalidateIndexPathHeightCache;
@end

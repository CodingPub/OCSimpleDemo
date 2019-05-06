//
//  UICollectionView+IGGIndexPathCache.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/8.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import "UICollectionView+IGGIndexPathCache.h"
#import <objc/runtime.h>

typedef NSMutableArray<NSMutableArray<NSValue *> *> FDIndexPathHeightsBySection;

static NSValue *s_igg_empty_size = nil;


@interface IGGIndexPathSizeCache ()
@property (nonatomic, strong) FDIndexPathHeightsBySection *heightsBySectionForPortrait;
@property (nonatomic, strong) FDIndexPathHeightsBySection *heightsBySectionForLandscape;
@end


@implementation IGGIndexPathSizeCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _heightsBySectionForPortrait = [NSMutableArray array];
        _heightsBySectionForLandscape = [NSMutableArray array];

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_igg_empty_size = [NSValue valueWithCGSize:CGSizeMake(-1, -1)];
        });
    }
    return self;
}

- (FDIndexPathHeightsBySection *)heightsBySectionForCurrentOrientation
{
    return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? self.heightsBySectionForPortrait : self.heightsBySectionForLandscape;
}

- (void)enumerateAllOrientationsUsingBlock:(void (^)(FDIndexPathHeightsBySection *heightsBySection))block
{
    block(self.heightsBySectionForPortrait);
    block(self.heightsBySectionForLandscape);
}

- (BOOL)existsSizeAtIndexPath:(NSIndexPath *)indexPath
{
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSValue *number = self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row];

    return number != s_igg_empty_size;
}

- (void)cacheSize:(CGSize)height byIndexPath:(NSIndexPath *)indexPath
{
    self.automaticallyInvalidateEnabled = YES;
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row] = [NSValue valueWithCGSize:height];
}

- (CGSize)heightForIndexPath:(NSIndexPath *)indexPath
{
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSValue *number = self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row];
    return number.CGSizeValue;
}

- (void)invalidateSizeAtIndexPath:(NSIndexPath *)indexPath
{
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
        heightsBySection[indexPath.section][indexPath.row] = @-1;
    }];
}

- (void)invalidateAllHeightCache
{
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
        [heightsBySection removeAllObjects];
    }];
}

- (void)buildCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths
{
    // Build every section array or row array which is smaller than given index path.
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self buildSectionsIfNeeded:indexPath.section];
        [self buildRowsIfNeeded:indexPath.row inExistSection:indexPath.section];
    }];
}

- (void)buildSectionsIfNeeded:(NSInteger)targetSection
{
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
        for (NSInteger section = 0; section <= targetSection; ++section) {
            if (section >= heightsBySection.count) {
                heightsBySection[section] = [NSMutableArray array];
            }
        }
    }];
}

- (void)buildRowsIfNeeded:(NSInteger)targetRow inExistSection:(NSInteger)section
{
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
        NSMutableArray<NSValue *> *heightsByRow = heightsBySection[section];
        for (NSInteger row = 0; row <= targetRow; ++row) {
            if (row >= heightsByRow.count) {
                heightsByRow[row] = s_igg_empty_size;
            }
        }
    }];
}

@end


@implementation UICollectionView (IGGIndexPathSizeCache)

- (IGGIndexPathSizeCache *)igg_indexPathSizeCache
{
    IGGIndexPathSizeCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [IGGIndexPathSizeCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end

// We just forward primary call, in crash report, top most method in stack maybe FD's,
// but it's really not our bug, you should check whether your table view's data source and
// displaying cells are not matched when reloading.
static void __FD_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(void (^callout)(void))
{
    callout();
}
#define FDPrimaryCall(...)                                               \
    do {                                                                 \
        __FD_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(^{ \
            __VA_ARGS__});                                               \
    } while (0)


@implementation UICollectionView (IGGIndexPathSizeCacheInvalidation)

- (void)igg_reloadDataWithoutInvalidateIndexPathHeightCache
{
    FDPrimaryCall([self igg_reloadData];);
}

+ (void)load
{
    // All methods that trigger height cache's invalidation
    SEL selectors[] = {@selector(reloadData),
                       @selector(insertSections:withRowAnimation:),
                       @selector(deleteSections:withRowAnimation:),
                       @selector(reloadSections:withRowAnimation:),
                       @selector(moveSection:toSection:),
                       @selector(insertRowsAtIndexPaths:withRowAnimation:),
                       @selector(deleteRowsAtIndexPaths:withRowAnimation:),
                       @selector(reloadRowsAtIndexPaths:withRowAnimation:),
                       @selector(moveRowAtIndexPath:toIndexPath:)};

    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"igg_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)igg_reloadData
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
            [heightsBySection removeAllObjects];
        }];
    }
    FDPrimaryCall([self igg_reloadData];);
}

- (void)igg_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.igg_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection insertObject:[NSMutableArray array] atIndex:section];
            }];
        }];
    }
    FDPrimaryCall([self igg_insertSections:sections withRowAnimation:animation];);
}

- (void)igg_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.igg_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection removeObjectAtIndex:section];
            }];
        }];
    }
    FDPrimaryCall([self igg_deleteSections:sections withRowAnimation:animation];);
}

- (void)igg_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.igg_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[section] removeAllObjects];
            }];
        }];
    }
    FDPrimaryCall([self igg_reloadSections:sections withRowAnimation:animation];);
}

- (void)igg_moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.igg_indexPathSizeCache buildSectionsIfNeeded:section];
        [self.igg_indexPathSizeCache buildSectionsIfNeeded:newSection];
        [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
            [heightsBySection exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }];
    }
    FDPrimaryCall([self igg_moveSection:section toSection:newSection];);
}

- (void)igg_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.igg_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[indexPath.section] insertObject:@-1 atIndex:indexPath.row];
            }];
        }];
    }
    FDPrimaryCall([self igg_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)igg_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.igg_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];

        NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
            if (!mutableIndexSet) {
                mutableIndexSet = [NSMutableIndexSet indexSet];
                mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
            }
            [mutableIndexSet addIndex:indexPath.row];
        }];

        [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSIndexSet *indexSet, BOOL *stop) {
            [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[key.integerValue] removeObjectsAtIndexes:indexSet];
            }];
        }];
    }
    FDPrimaryCall([self igg_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)igg_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.igg_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                heightsBySection[indexPath.section][indexPath.row] = @-1;
            }];
        }];
    }
    FDPrimaryCall([self igg_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)igg_moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (self.igg_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.igg_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:@[sourceIndexPath, destinationIndexPath]];
        [self.igg_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
            NSMutableArray<NSValue *> *sourceRows = heightsBySection[sourceIndexPath.section];
            NSMutableArray<NSValue *> *destinationRows = heightsBySection[destinationIndexPath.section];
            NSValue *sourceValue = sourceRows[sourceIndexPath.row];
            NSValue *destinationValue = destinationRows[destinationIndexPath.row];
            sourceRows[sourceIndexPath.row] = destinationValue;
            destinationRows[destinationIndexPath.row] = sourceValue;
        }];
    }
    FDPrimaryCall([self igg_moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];);
}

@end

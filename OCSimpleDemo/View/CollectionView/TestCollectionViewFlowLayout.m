//
//  TestCollectionViewFlowLayout.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/7.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import "TestCollectionViewFlowLayout.h"
#import "SectionBackgorundView.h"

@implementation TestCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self registerClass:SectionBackgorundView.class forDecorationViewOfKind:SectionBackgorundView.reuseIdentifier];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithArray:attributes];
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        
        // 查找一行的第一个item
        if (attribute.representedElementKind == UICollectionElementCategoryCell
            && attribute.indexPath.row == 0) {
            
            UICollectionViewLayoutAttributes *lastAttrInSection = [self lastItemAttrInSection:attribute.indexPath.section];
            
            // 创建decoration属性
            UICollectionViewLayoutAttributes *decorationAttributes = [self layoutAttributesForDecorationViewOfKind:SectionBackgorundView.reuseIdentifier atIndexPath:attribute.indexPath];
            decorationAttributes.frame = [self sectionBackgroundFrame:attribute lastItem:lastAttrInSection];
            
            // 设置zIndex，表示在item的后面
            decorationAttributes.zIndex = attribute.zIndex-1;
            
            // 添加属性到集合
            [allAttributes addObject:decorationAttributes];
        }
    }
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)lastItemAttrInSection:(NSInteger)section {
    UICollectionViewLayoutAttributes *lastAttrInSection = nil;
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
    if (rowCount > 0) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:section];
        lastAttrInSection = [self layoutAttributesForItemAtIndexPath:lastIndexPath];
    }
    return lastAttrInSection;
}

- (CGRect)sectionBackgroundFrame:(UICollectionViewLayoutAttributes *)firstItem lastItem:(UICollectionViewLayoutAttributes *)lastItem {
    CGFloat x = 0;
    CGFloat y = firstItem.frame.origin.y - self.sectionInset.top;
    CGFloat width = self.collectionViewContentSize.width;
    CGFloat height = (lastItem.frame.origin.y + lastItem.frame.size.height - y) + self.sectionInset.bottom;
    
    if (self.sectionBackgroundContainsHeaderView) {
        UICollectionViewLayoutAttributes *headerItem = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:firstItem.indexPath];
        y -= headerItem.frame.size.height;
        height += headerItem.frame.size.height;
    }
    
    return CGRectMake(x, y, width, height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end

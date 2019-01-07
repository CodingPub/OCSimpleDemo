//
//  TestCollectionViewController.m
//  OCSimpleDemo
//
//  Created by Xiaobin Lin on 2019/1/7.
//  Copyright © 2019年 Felink. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "TestSimpleCollectionViewCell.h"
#import "SimpleHeaderCollectionReusableView.h"
#import "TestCollectionViewFlowLayout.h"
#import "SectionBackgorundView.h"
#import <Masonry/Masonry.h>

@interface TestCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestCollectionViewFlowLayout *layout = [[TestCollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.sectionBackgroundContainsHeaderView = YES;
    
    // 自动计算高度会导致 header 位置不对
    // layout.estimatedItemSize = CGSizeMake(50, 50);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Register cell classes
    [self.collectionView registerClass:[TestSimpleCollectionViewCell class] forCellWithReuseIdentifier:TestSimpleCollectionViewCell.reuseIdentifier];
    [self.collectionView registerClass:SimpleHeaderCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SimpleHeaderCollectionReusableView.reuseIdentifier];
    [self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TestSimpleCollectionViewCell.reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SimpleHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SimpleHeaderCollectionReusableView.reuseIdentifier forIndexPath:indexPath];
        header.title = @"标题";
        return header;
    } else {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        return footer;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(50, 70);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(300, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(300, 20);
}


#pragma mark <UICollectionViewDelegate>


@end

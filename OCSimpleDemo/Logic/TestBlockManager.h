//
//  TestBlockManager.h
//  OCSimpleDemo
//
//  Created by LinXiaoBin on 2018/8/16.
//  Copyright © 2018年 Felink. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TestBlock)(void);


@interface TestBlockManager : NSObject

@property (nonatomic, copy) TestBlock copyBlock;
@property (nonatomic, strong) TestBlock strongBlock;
@property (nonatomic, weak) TestBlock weakBlock;

- (void)simpleBlock:(TestBlock)block;

- (void)testWithCopyBlock:(TestBlock)block;
- (void)testWithStrongBlock:(TestBlock)block;
- (void)testWithWeakBlock:(TestBlock)block;
- (void)testWithWeakBlockThread:(TestBlock)block;

@end

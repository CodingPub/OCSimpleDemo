//
//  BaseTestTableViewController.h
//  OCSimpleDemo
//
//  Created by LinXiaoBin on 2018/8/16.
//  Copyright © 2018年 Felink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTestTableViewController : UITableViewController


- (void)addSection:(NSString *)title;
- (void)section:(NSUInteger)section addCell:(NSString *)title action:(void (^)(void))action;

@end

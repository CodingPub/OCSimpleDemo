//
//  BaseTestTableViewController.m
//  OCSimpleDemo
//
//  Created by LinXiaoBin on 2018/8/16.
//  Copyright © 2018年 Felink. All rights reserved.
//

#import "BaseTestTableViewController.h"

#define kSectionTitleKey @"SectionTitle"
#define kCellTitleArrayKey @"CellTitleArray"
#define kCellTitleKey @"Title"
#define kCellOperationKey @"Operation"


@interface BaseTestTableViewController ()

@property (nonatomic, strong) NSMutableArray *sections;

@end


@implementation BaseTestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCellIDentifier"];
    self.sections = @[].mutableCopy;
}

- (void)addSection:(NSString *)title
{
    [self.sections addObject:@{ kSectionTitleKey: title ?: @"", kCellTitleArrayKey: @[].mutableCopy }];
}

- (void)section:(NSUInteger)section addCell:(NSString *)title action:(void (^)(void))action
{
    NSMutableArray *array = self.sections[section][kCellTitleArrayKey];

    [array addObject:@{kCellTitleKey: title, kCellOperationKey: action}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = [self.sections objectAtIndex:section];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return dict[kSectionTitleKey];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [self.sections objectAtIndex:section];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return [dict[kCellTitleArrayKey] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCellIDentifier" forIndexPath:indexPath];

    NSDictionary *dict = [self.sections objectAtIndex:indexPath.section];
    NSArray *titles = dict[kCellTitleArrayKey];
    if ([titles isKindOfClass:[NSArray class]]) {
        NSDictionary *cellDict = titles[indexPath.row];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%zd-%zd %@", indexPath.section, indexPath.row, cellDict[kCellTitleKey]];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dict = [self.sections objectAtIndex:indexPath.section];
    NSArray *titles = dict[kCellTitleArrayKey];
    if ([titles isKindOfClass:[NSArray class]]) {
        NSDictionary *cellDict = titles[indexPath.row];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            void (^block)(void) = cellDict[kCellOperationKey];
            block();
        }
    }
}

@end

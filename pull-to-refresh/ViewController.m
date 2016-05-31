//
//  ViewController.m
//  pull-to-refresh
//
//  Created by Jon on 5/30/16.
//  Copyright © 2016 Jonathan Lazar. All rights reserved.
//

#import "ViewController.h"
#import "RefreshControl.h"

@interface ViewController () <UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RefreshControl *rc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    RefreshControl *rc = [[RefreshControl alloc] initWithTableView:tableView];
    [rc addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.rc = rc;
    tableView.delegate = self;
}

- (void)refresh
{
    NSLog(@"Data refresh triggered");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rc endRefreshing];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.rc scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.rc scrollViewDidEndDragging:scrollView];
}

@end

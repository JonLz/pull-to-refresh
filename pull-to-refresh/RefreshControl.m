//
//  RefreshControl.m
//  pull-to-refresh
//
//  Created by Jon on 5/30/16.
//  Copyright © 2016 Jonathan Lazar. All rights reserved.
//

#import "RefreshControl.h"

const CGFloat height = 50.0f;

@interface RefreshControl ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat refreshDistance;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) CGRect defaultFrame;
@property (nonatomic, assign) UIEdgeInsets defaultInsets;
@end

@implementation RefreshControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self commonInit];
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [self initWithFrame:CGRectMake(0, -height, tableView.bounds.size.width, height)];
    [self setupTableView:tableView];
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor lightGrayColor];
    CGRect labelFrame = self.bounds;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = @"Pull to refresh...";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    self.label = label;
    
    self.refreshing = NO;
    self.refreshDistance = 120.0f;
    self.defaultFrame = self.frame;
}

- (void)setupTableView:(UITableView *)tableView
{
    _tableView = tableView;
    [tableView addSubview:self];
    self.defaultInsets = tableView.contentInset;
    self.refreshDistance = tableView.bounds.size.width / 4.0f;
}

- (void)beginRefreshing
{
    self.refreshing = YES;
    self.label.text = @"Refreshing...";
    CGPoint contentOffset = self.tableView.contentOffset;
    self.tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
    self.tableView.contentOffset = contentOffset;
}

- (void)endRefreshing
{
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.contentInset = self.defaultInsets;
        CGPoint offset = self.tableView.contentOffset;
        self.tableView.contentOffset = offset;
        self.frame = self.defaultFrame;
    } completion:^(BOOL finished) {
        [self resetState];
    }];
}

- (void)resetState
{
    self.frame = self.defaultFrame;
    self.refreshing = NO;
    self.label.text = @"Pull to refresh...";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pullDistance = MAX(0.0, -scrollView.contentOffset.y);
    
    CGRect frame = self.frame;
    if (pullDistance > frame.size.height) {
        frame.origin.y = -pullDistance;
    }
    self.frame = frame;
    
    if (self.refreshing) {
        if (pullDistance == 0) {
            self.tableView.contentInset = UIEdgeInsetsZero;
        }
    }
    
    [self updateInterface:pullDistance];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (self.refreshing) {
        if (-scrollView.contentOffset.y > height) {
            CGPoint offset = self.tableView.contentOffset;
            self.tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
            self.tableView.contentOffset = offset;
        }
        return;
    }
    
    CGFloat pullDistance = MAX(0.0, -scrollView.contentOffset.y);
    
    if (pullDistance >= self.refreshDistance) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self beginRefreshing];
    }
}

- (void)updateInterface:(CGFloat)pullDistance
{
    if (!self.refreshing) {
        if (pullDistance > self.refreshDistance) {
            self.label.text = @"Release to refresh...";
        }
        
        if ( pullDistance < self.refreshDistance) {
            self.label.text = @"Pull to refresh...";
        }
    }
}

@end

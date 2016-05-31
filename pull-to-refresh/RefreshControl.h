//
//  RefreshControl.h
//  pull-to-refresh
//
//  Created by Jon on 5/30/16.
//  Copyright © 2016 Jonathan Lazar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshControl : UIControl
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)beginRefreshing;
- (void)endRefreshing;
- (instancetype)initWithTableView:(UITableView *)tableView;
@end

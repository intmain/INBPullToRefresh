//
//  INBPullToRefreshView.h
//  IphoneAgit
//
//  Created by Leonard on 2015. 2. 28..
//  Copyright (c) 2015년 Kakao Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewController.h"

#define TOP_BAR_HEIGHT 64

@interface INBPullToRefreshView : UIImageView
@property (nonatomic ,weak) UIViewController *viewController;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) void (^pullToRefreshHandler)(INBPullToRefreshView *v);
@property (nonatomic, assign) BOOL showPullToRefresh;

@property (assign, nonatomic) CGFloat maxImageHeight;
@property (assign, nonatomic) CGFloat refreshThreshold;
@property (strong, nonatomic) UIView *pullIndicatorView;
@property (assign, nonatomic) BOOL enableRefresh;
@property (readonly, nonatomic) CGFloat topBarHeight;

- (void)stopAnimation;
+ (CGFloat)topBarHeight;

@end


@interface UIViewController (INBPullToRefreshView)
@property (nonatomic, strong, readonly) INBPullToRefreshView *pullToRefresh;
@property (nonatomic , assign) CGFloat lastOffsetY;
@property (nonatomic , assign) UIStatusBarStyle prevStatusBarStyle;
- (INBPullToRefreshView *)addPullToRefreshWithHeight:(CGFloat)height image:(UIImage *)image tableView:(UITableView *)tableView actoinHandler:(void (^)(INBPullToRefreshView *view))handler;
- (INBPullToRefreshView *)addPullToRefreshWithHeight:(CGFloat)height url:(NSURL *)imageURL tableView:(UITableView *)tableView actoinHandler:(void (^)(INBPullToRefreshView *view))handler;

@end
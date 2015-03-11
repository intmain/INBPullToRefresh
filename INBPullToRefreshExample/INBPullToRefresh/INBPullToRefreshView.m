//
//  INBPullToRefreshView.m
//  INBPullToRefreshExample
//
//  Created by intmain on 2015. 3. 8..
//  Copyright (c) 2015년 intmain. All rights reserved.
//

typedef enum {
    INBPullToRefreshViewStateNormal = 0,
    INBPullToRefreshViewStateStopped,
    INBPullToRefreshViewStateLoading,
} INBPullToRefreshViewState;

#import "INBPullToRefreshView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIImageView+AFNetworking.h"


@interface UINavigationBar (Addition)

- (void)hideBottomHairline;
- (void)showBottomHairline;

@end

@implementation UINavigationBar (Addition)

/**
 * Hide 1px hairline of the nav bar
 */
- (void)hideBottomHairline {
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = YES;
}

/**
 * Show 1px hairline of the nav bar
 */
- (void)showBottomHairline {
    // Show 1px hairline of translucent nav bar
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = NO;
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


@end

@implementation UIViewController (INBPullToRefreshView)

- (INBPullToRefreshView *)addPullToRefreshWithHeight:(CGFloat)height image:(UIImage *)image url:(NSURL *)imageURL tableView:(UITableView *)tableView actoinHandler:(void (^)(INBPullToRefreshView *view))handler
{
    [self swizzlingViewLifeCycle];
    
    if(self.pullToRefresh) {
        return self.pullToRefresh;
    }
    
    INBPullToRefreshView *view = [[INBPullToRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    
    
    view.maxImageHeight = height;
    
    if (imageURL) {
        [view setImageWithURL:imageURL];
    } else if(image) {
        view.image = image;
    }
    
    view.tableView = tableView;
    view.showPullToRefresh = YES;
    view.refreshThreshold = 50.0f;
    view.pullToRefreshHandler = handler;
    
    
    
    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    loadLabel.text = @"Refresh";
    loadLabel.textColor = [UIColor whiteColor];
    loadLabel.textAlignment = NSTextAlignmentCenter;
    loadLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    loadLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    loadLabel.layer.opacity = 0.0f;
    [view addSubview:loadLabel];
    view.pullIndicatorView = loadLabel;
    
    tableView.contentInset = UIEdgeInsetsMake(view.maxImageHeight-view.topBarHeight, 0, 0, 0);
    tableView.backgroundColor = [UIColor clearColor];
    
    [self setClearNavigationBar:YES];
    
    [self.view addSubview:view];
    
    return view;
}
- (INBPullToRefreshView *)addPullToRefreshWithHeight:(CGFloat)height image:(UIImage *)image tableView:(UITableView *)tableView actoinHandler:(void (^)(INBPullToRefreshView *view))handler
{
    return [self addPullToRefreshWithHeight:height image:image url:nil tableView:tableView actoinHandler:handler];
}

- (INBPullToRefreshView *)addPullToRefreshWithHeight:(CGFloat)height url:(NSURL *)imageURL tableView:(UITableView *)tableView actoinHandler:(void (^)(INBPullToRefreshView *view))handler
{
    return [self addPullToRefreshWithHeight:height image:nil url:imageURL tableView:tableView actoinHandler:handler];
}

- (void)swizzlingViewLifeCycle
{
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        
        int i=0;
        unsigned int mc = 0;
        Method * mlist = class_copyMethodList(self.class, &mc);
        BOOL isViewWillAppear = NO;
        BOOL isViewDidAppear = NO;
        BOOL isViewWillDisappear = NO;
        BOOL isViewDidDisappear = NO;
        BOOL isViewDidLayoutSubviews = NO;
        for(i=0;i<mc;i++) {
            isViewWillAppear = isViewWillAppear || ( @selector(viewWillAppear:) == method_getName(mlist[i]) );
            isViewDidAppear = isViewDidAppear || ( @selector(viewDidAppear:) == method_getName(mlist[i]) );
            isViewWillDisappear = isViewWillDisappear || ( @selector(viewWillDisappear:) == method_getName(mlist[i]) );
            isViewDidDisappear = isViewDidDisappear || ( @selector(viewDidDisappear:) == method_getName(mlist[i]) );
            isViewDidLayoutSubviews = isViewDidLayoutSubviews || ( @selector(viewDidLayoutSubviews) == method_getName(mlist[i]) );
        }
        
        if(!isViewWillAppear) {
            Method superClassMethod = class_getInstanceMethod(self.superclass, @selector(viewWillAppear:));
            IMP imp = method_getImplementation(superClassMethod);
            class_addMethod(self.class ,  @selector(viewWillAppear:) , imp , method_getTypeEncoding(superClassMethod));
        }
        
        if(!isViewDidAppear) {
            Method superClassMethod = class_getInstanceMethod(self.superclass, @selector(viewDidAppear:));
            IMP imp = method_getImplementation(superClassMethod);
            class_addMethod(self.class ,  @selector(viewDidAppear:) , imp , method_getTypeEncoding(superClassMethod));
        }
        
        if(!isViewWillDisappear) {
            Method superClassMethod = class_getInstanceMethod(self.superclass, @selector(viewWillDisappear:));
            IMP imp = method_getImplementation(superClassMethod);
            class_addMethod(self.class ,  @selector(viewWillDisappear:) , imp , method_getTypeEncoding(superClassMethod));
        }
        
        if(!isViewDidDisappear) {
            Method superClassMethod = class_getInstanceMethod(self.superclass, @selector(viewDidDisappear:));
            IMP imp = method_getImplementation(superClassMethod);
            class_addMethod(self.class ,  @selector(viewDidDisappear:) , imp , method_getTypeEncoding(superClassMethod));
        }
        
        if(!isViewDidLayoutSubviews) {
            Method superClassMethod = class_getInstanceMethod(self.superclass, @selector(viewDidLayoutSubviews));
            IMP imp = method_getImplementation(superClassMethod);
            class_addMethod(self.class ,  @selector(viewDidLayoutSubviews) , imp , method_getTypeEncoding(superClassMethod));
        }

        Method originalMethod = class_getInstanceMethod(self.class, @selector(viewDidAppear:));
        Method extendedMethod = class_getInstanceMethod(self.class, @selector(INBPullToRefreshView_viewDidAppear:));
        method_exchangeImplementations(originalMethod, extendedMethod);
        
        originalMethod = class_getInstanceMethod(self.class, @selector(viewWillAppear:));
        extendedMethod = class_getInstanceMethod(self.class, @selector(INBPullToRefreshView_viewWillAppear:));
        method_exchangeImplementations(originalMethod, extendedMethod);
        
        originalMethod = class_getInstanceMethod(self.class, @selector(viewWillDisappear:));
        extendedMethod = class_getInstanceMethod(self.class, @selector(INBPullToRefreshView_viewWillDisappear:));
        method_exchangeImplementations(originalMethod, extendedMethod);
        
        originalMethod = class_getInstanceMethod(self.class, @selector(viewDidDisappear:));
        extendedMethod = class_getInstanceMethod(self.class, @selector(INBPullToRefreshView_viewDidDisappear:));
        method_exchangeImplementations(originalMethod, extendedMethod);
        
        originalMethod = class_getInstanceMethod(self.class, @selector(viewDidLayoutSubviews));
        extendedMethod = class_getInstanceMethod(self.class, @selector(INBPullToRefreshView_viewDidLayoutSubviews));
        method_exchangeImplementations(originalMethod, extendedMethod);
    });
}

- (void)INBPullToRefreshView_viewWillAppear:(BOOL)animated
{
    [self setClearNavigationBar:YES];
    [self INBPullToRefreshView_viewWillAppear:animated];
    UITableView *tableView = self.pullToRefresh.tableView;
    tableView.contentOffset = tableView.contentOffset;
    self.pullToRefresh.showPullToRefresh = YES;
}

- (void)INBPullToRefreshView_viewDidAppear:(BOOL)animated
{
    [self setClearNavigationBar:YES];
    [self INBPullToRefreshView_viewDidAppear:animated];
    UITableView *tableView = self.pullToRefresh.tableView;
    if(tableView.contentInset.top != self.pullToRefresh.maxImageHeight) {
        UIEdgeInsets inset = tableView.contentInset;
        inset.top = self.pullToRefresh.maxImageHeight;
        tableView.contentInset = inset;
    }
    tableView.contentOffset = tableView.contentOffset;
    
    if(self.lastOffsetY != 0) {
        self.pullToRefresh.tableView.contentOffset = CGPointMake(0, self.lastOffsetY);
    }
    self.prevStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)INBPullToRefreshView_viewWillDisappear:(BOOL)animated
{
    self.lastOffsetY = self.pullToRefresh.tableView.contentOffset.y;
    [self setClearNavigationBar:NO];
    self.pullToRefresh.tableView.contentOffset = CGPointMake(0, self.lastOffsetY);
    [self INBPullToRefreshView_viewWillDisappear:animated];
    
}

- (void)INBPullToRefreshView_viewDidDisappear:(BOOL)animated
{
    [self INBPullToRefreshView_viewDidDisappear:animated];
    [self setClearNavigationBar:NO];
    self.pullToRefresh.showPullToRefresh = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:self.prevStatusBarStyle];
}

- (void)INBPullToRefreshView_viewDidLayoutSubviews
{
    [self INBPullToRefreshView_viewDidLayoutSubviews];
    INBPullToRefreshView *pullToRefresh = self.pullToRefresh;
    if(pullToRefresh) {
        CGRect frame = pullToRefresh.frame;
        frame.origin.x = 0;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = pullToRefresh.maxImageHeight;
        pullToRefresh.frame = frame;
        pullToRefresh.tableView.contentOffset = pullToRefresh.tableView.contentOffset;
    }
}


- (INBPullToRefreshView *)pullToRefresh
{
    for(UIView *subView in self.view.subviews) {
        if([subView isKindOfClass:INBPullToRefreshView.class]) {
            return (INBPullToRefreshView *)subView;
        }
    }
    return nil;
}

- (void)setClearNavigationBar:(BOOL)clear
{
    static UIImage *blankImage = nil;
    UIImage *headerImage = nil;
    if (clear) {
        if (!blankImage) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, [INBPullToRefreshView topBarHeight]), NO, 0.0);
            blankImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        headerImage = blankImage;
    }
    else {
    }
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    if (!self.navigationController.navigationBar) return;
    
    if(clear) {
        self.navigationController.navigationBar.translucent = YES;
        if(self.tabBarController) {
            self.tabBarController.view.frame = self.navigationController.view.bounds;
            self.view.frame = CGRectMake(0, 0, self.tabBarController.view.frame.size.width, self.tabBarController.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
        }
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]} ;
        [self.navigationController.navigationBar hideBottomHairline];
    } else {
        self.navigationController.navigationBar.translucent = NO;
        if(self.tabBarController) {
            
            self.tabBarController.view.frame = CGRectMake(0, self.tabBarController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height - self.tabBarController.view.frame.origin.y);
            self.tabBarController.selectedViewController.view.frame = CGRectMake(0, 0, self.tabBarController.view.frame.size.width, self.tabBarController.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
        }
        self.navigationController.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
        self.navigationController.navigationBar.titleTextAttributes = [UINavigationBar appearance].titleTextAttributes;
        [self.navigationController.navigationBar showBottomHairline];
    }

    [bar.layer removeAllAnimations];
    [bar setBackgroundImage:headerImage forBarMetrics:UIBarMetricsDefault];
}

+ (void)load {
    
}

- (void)setLastOffsetY:(CGFloat)lastOffsetY
{
    objc_setAssociatedObject(self, @"lastOffsetY", @(lastOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lastOffsetY
{
    NSNumber *offsetY = (NSNumber *)objc_getAssociatedObject(self, @"lastOffsetY");
    return (CGFloat)[offsetY floatValue];
}

- (void)setPrevStatusBarStyle:(UIStatusBarStyle)prevStatusBarStyle
{
    objc_setAssociatedObject(self, @"prevStatusBarStyle", @(prevStatusBarStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (UIStatusBarStyle)prevStatusBarStyle
{
    NSNumber *statusBarStyle = (NSNumber *)objc_getAssociatedObject(self, @"prevStatusBarStyle");
    return (UIStatusBarStyle)[statusBarStyle integerValue];
}

@end

@interface INBPullToRefreshView ()
{
    BOOL _enableRefresh;
}

@property (nonatomic, assign) BOOL isObserving;
@property (nonatomic, assign)  CGFloat prevNaviImageOriginY;
@property (nonatomic,assign) INBPullToRefreshViewState state;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat prevProgress;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
@property (strong, nonatomic) CAGradientLayer *gradient;

@end


@implementation INBPullToRefreshView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.opaque = YES;
        self.clearsContextBeforeDrawing = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = NO;
        
        self.enableRefresh = YES;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self.blurEffectView setFrame:self.bounds];
        [self addSubview:self.blurEffectView];
        self.gradient = [CAGradientLayer layer];
        self.gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.maxImageHeight*8/15);
        self.gradient.colors = @[
                            (id)[UIColor colorWithRed:(0.0f/255.0f) green:(0.0f/255.0f) blue:(0.0f/255.0f) alpha:0.8f].CGColor,
                            (id)[UIColor colorWithRed:(0.0f/255.0f) green:(0.0f/255.0f) blue:(0.0f/255.0f) alpha:0.0f].CGColor,
                            ];
        [self.layer insertSublayer:self.gradient atIndex:0];
    }
    return self;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        [self scrollViewScrolled:contentOffset];
    } else if ([keyPath isEqualToString:@"image"]) {
        self.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.maxImageHeight);
    } else if ([keyPath isEqualToString:@"frame"]) {
        [self.blurEffectView setFrame:self.bounds];
        [self adjustPullIndicatorOffset];
    }
}

- (void)scrollViewScrolled:(CGPoint)contentOffset
{

    
    if( contentOffset.y <= -self.maxImageHeight) { // 아래로 내려간경우
        CGFloat gap = -(contentOffset.y - (-self.maxImageHeight)); // 얼마나 내려갔나?
        CGRect frame = self.frame ;
        frame.size.height = self.maxImageHeight + gap;
        frame.size.width = self.tableView.frame.size.width;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.frame = frame;
        
        self.progress = gap / self.refreshThreshold;
        self.blurEffectView.alpha = 0.0f;
        
    } else { // 위로 올라간 경우
        //위로 올라가면 좌표를 위로 올라간만큼 올려야 함.
        // 근데 66은 남겨야함
        
        CGFloat gap = -(contentOffset.y - (-self.maxImageHeight)); // 얼마나 내려갔나?
        self.progress = 0.0f;
        
        if(self.tableView.tableHeaderView) {
            gap = (-gap < self.tableView.tableHeaderView.frame.size.height)? 0 : gap + self.tableView.tableHeaderView.frame.size.height;
        }
        
        if (-gap < (self.maxImageHeight-self.topBarHeight )) {
            self.blurEffectView.alpha = -(gap/(self.maxImageHeight-self.topBarHeight));
            CGRect frame = self.frame ;
            frame.origin.x = 0;
            frame.origin.y = gap;
            frame.size.height = self.maxImageHeight;
            frame.size.width = self.tableView.frame.size.width;
            self.frame = frame;
        } else {
            CGRect frame = self.frame ;
            frame.origin.x = 0;
            frame.origin.y = -(self.maxImageHeight- self.topBarHeight);
            frame.size.height = self.maxImageHeight;
            frame.size.width = self.tableView.frame.size.width;
            self.frame = frame;
            self.blurEffectView.alpha = 1.0f;
        }
        
    }
    [self.blurEffectView setFrame:self.bounds];
    CGFloat yOffset = contentOffset.y;
    
    switch (self.state) {
        case INBPullToRefreshViewStateNormal: //detect action
            if (!self.tableView.dragging && !self.tableView.isZooming && yOffset < -(self.maxImageHeight+self.refreshThreshold)) {
                [self actionTriggeredState];
            }
            break;
        case INBPullToRefreshViewStateStopped: // finish
        case INBPullToRefreshViewStateLoading: // wait until stopIndicatorAnimation
            break;
        default:
            break;
    }
}

- (void)actionTriggeredState
{
    self.state = INBPullToRefreshViewStateLoading;
    
    [UIView animateWithDuration:0.1f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.tableView.contentInset = UIEdgeInsetsMake(self.maxImageHeight+self.refreshThreshold, 0, 0, 0);
                         [self.blurEffectView.layer addAnimation:[self opacityAnimation] forKey:@"opacityIN"];
                     } completion:^(BOOL finished) {
                         if (self.pullToRefreshHandler)
                             self.pullToRefreshHandler(self);
                     }];
}

- (void)actionStopState
{
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.tableView.contentInset = UIEdgeInsetsMake(self.maxImageHeight, 0, 0, 0);
                         if([self.blurEffectView.layer animationForKey:@"opacityIN"] != nil) {
                             
                             [self.blurEffectView.layer removeAnimationForKey:@"opacityIN"];
                         }
                     } completion:^(BOOL finished) {
                         
                         self.state = INBPullToRefreshViewStateNormal;
                     }];
}

- (CABasicAnimation *)opacityAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.4   ;
    animation.fromValue =  @0.0;
    animation.toValue = @1.0;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    animation.additive = NO;
    return animation;
}

#pragma mark - property
- (void)setShowPullToRefresh:(BOOL)showPullToRefresh
{
    self.hidden = !showPullToRefresh;
    
    if (showPullToRefresh) {
        if (!self.isObserving) {
            [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.isObserving = YES;
        }
    } else {
        if (self.isObserving) {
            [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
            [self removeObserver:self forKeyPath:@"image"];
            [self removeObserver:self forKeyPath:@"frame"];
            self.isObserving = NO;
        }
    }
}

- (BOOL)showPullToRefresh
{
    return !self.hidden;
}

- (void)adjustPullIndicatorOffset
{
    if(self.pullIndicatorView) {
        _pullIndicatorView.center = CGPointMake(self.center.x, self.center.y*3/2);
    }
}

#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

- (void)setProgress:(CGFloat)progress
{
    if(INBPullToRefreshViewStateNormal == self.state) {
        
        if (0.0f > progress) {
            progress = 0.0f;
        }
        
        if (1.0f < progress ) {
            progress = 1.0f;
        }
        
        self.pullIndicatorView.layer.opacity = progress;
        self.pullIndicatorView.layer.shadowOpacity = progress;
        self.pullIndicatorView.layer.shadowOffset = CGSizeMake(3 * progress, 3 * progress);


        CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animationImage.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180+180*self.prevProgress)];
        animationImage.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180+180*progress)];
        animationImage.duration = 0.1f;
        animationImage.removedOnCompletion = NO;
        animationImage.fillMode = kCAFillModeForwards;
        [self.pullIndicatorView.layer addAnimation:animationImage forKey:@"animation"];
        

    } else {
        self.pullIndicatorView.layer.opacity = 0.0f;
    }
    
    self.prevProgress = self.progress;
    _progress = progress;
}

- (void)setPullIndicatorView:(UIView *)pullIndicatorView
{
    [_pullIndicatorView removeFromSuperview];
    _pullIndicatorView = pullIndicatorView;
    _pullIndicatorView.center = CGPointMake(self.center.x, self.center.y*3/2);
    _pullIndicatorView.layer.shadowColor = [UIColor blackColor].CGColor;
    _pullIndicatorView.layer.opacity = 0.0f;
    [self addSubview:_pullIndicatorView];
}

- (void)stopAnimation
{
    [self actionStopState];
}

- (void)setEnableRefresh:(BOOL)enableRefresh
{
    _enableRefresh = enableRefresh;
    self.tableView.bounces = enableRefresh;
}

- (BOOL)enableRefresh
{
    return _enableRefresh;
}

- (void)setMaxImageHeight:(CGFloat)maxImageHeight
{
    _maxImageHeight = maxImageHeight;
    self.gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.maxImageHeight*8/15);
}



- (CGFloat)topBarHeight
{
    if(OsVer() < 8) {
        return 64.0f;
    }
    if(IsPad())
    {
        return 64.0f;
    }
    if(self.tableView.frame.size.width > self.tableView.frame.size.height) {
        return 32.0f;
    } else {
        return 64.0f;
    }
    return 64.0f;
}

+ (CGFloat)topBarHeight
{
    if(OsVer() < 8) {
        return 64.0f;
    }
    if(IsPad())
    {
        return 64.0f;
    }
    
    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) ||
        ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
    {
        return 32.0f;
    } else {
        return 64.0f;
    }
    
    return 64.0f;
}

NSInteger OsVer()
{
    NSArray *verArray = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    NSInteger osVer = [verArray[0] integerValue];
    return osVer;
}

BOOL IsPad()
{
#ifdef __IPHONE_3_2
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}

@end

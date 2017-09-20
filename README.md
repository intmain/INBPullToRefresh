# INBPullToRefresh


Image navigation bar pull to refresh library.

![DemoGif](http://mud-kage.kakaocdn.net/dn/dyXUDe/btqbX7AD6Mw/KDIbP9DUDVJTbherjWqwEk/o.gif)

## Requirement
- ARC.
- iOS 8.

## Install
### CocoaPods
Add `pod 'INBPullToRefresh'` to your Podfile.

### Manually

1. Copy `INBPullToRefresh` directory to your project.

## Usage

    #import "INBPullToRefreshView.h"
    ...
    INBPullToRefreshView *refreshView = [self addPullToRefreshWithHeight:120 url:self.barImageURL tableView:self.tableView actoinHandler:^(INBPullToRefreshView *view) {
		// do something...
        // then must call stopAnimation method.
    	[view performSelector:@selector(stopAnimation)];
    }];
    
### Customization
#### Property
You can customize below properties.

    refreshView.pullIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reload.png"]];
    refreshView.refreshThreshold = 60;
    refreshView.maxImageHeight = 150;
    refreshView.enableRefresh = NO; // tableView.bounces = NO;
    
## Warnning
This library is implemented by "Method swizzling". If you are using "Method swizzling" for below methods, it can twist with this library.

	viewWillAppear: 
    viewDidAppear:
    viewWillDisappear:
    viewDidDisappear:
    viewDidLayoutSubviews

    
## LICENSE
MIT

~cancel~

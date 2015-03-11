//
//  RefreshViewController.m
//  INBPullToRefreshExample
//
//  Created by intmain on 2015. 3. 8..
//  Copyright (c) 2015년 intmain. All rights reserved.
//

#import "RefreshViewController.h"
#import "INBPullToRefreshView.h"

@interface RefreshViewController () <UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation RefreshViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    INBPullToRefreshView *refreshView;
    if (self.barImageURL) {
        refreshView = [self addPullToRefreshWithHeight:120 url:self.barImageURL tableView:self.tableView actoinHandler:^(INBPullToRefreshView *view) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if([view respondsToSelector:@selector(stopAnimation)]) {
                    [view performSelector:@selector(stopAnimation)];
                }
            });
        }];
    } else if(self.barImage) {
        refreshView = [self addPullToRefreshWithHeight:120 image:self.barImage tableView:self.tableView actoinHandler:^(INBPullToRefreshView *view) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if([view respondsToSelector:@selector(stopAnimation)]) {
                    [view performSelector:@selector(stopAnimation)];
                }
            });
        }];
        
    }

    refreshView.pullIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reload.png"]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Title";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Cell_%ld" , indexPath.row];
    
    return cell;
}

@end

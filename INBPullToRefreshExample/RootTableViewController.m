//
//  RootTableViewController.m
//  INBPullToRefreshExample
//
//  Created by intmain on 2015. 3. 8..
//  Copyright (c) 2015년 intmain. All rights reserved.
//

#import "RootTableViewController.h"
#import "RefreshViewController.h"

@interface RootTableViewController ()

@property (strong ,nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *imageURLs;

@end

@implementation RootTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = @[ [UIImage imageNamed:@"sorea1.jpg"],[UIImage imageNamed:@"sorea2.jpg"],[UIImage imageNamed:@"sorea3.jpg"],[UIImage imageNamed:@"girlgen.jpg"],[UIImage imageNamed:@"girlgen2.jpg"] ];
    
    self.imageURLs = @[[NSURL URLWithString:@"https://raw.githubusercontent.com/intmain/INBPullToRefresh/master/INBPullToRefreshExample/images/sorea1.jpg"] , [NSURL URLWithString:@"https://raw.githubusercontent.com/intmain/INBPullToRefresh/master/INBPullToRefreshExample/images/sorea2.jpg"],
                       [NSURL URLWithString:@"https://raw.githubusercontent.com/intmain/INBPullToRefresh/master/INBPullToRefreshExample/images/sorea3.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if(0 == section) {
        return self.images.count;
    } else if (1 == section) {
        return self.imageURLs.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Cell_%ld" , indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(0 == section) {
        return @"UIImage";
    } else if (1 == section) {
        return @"NSURL";
    }
    return nil;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    RefreshViewController *viewController = segue.destinationViewController;
    if (0 == indexPath.section) {
        viewController.barImage = self.images[indexPath.row];
    } else if ( 1 == indexPath.section) {
        viewController.barImageURL = self.imageURLs[indexPath.row];
    }
    
}


@end

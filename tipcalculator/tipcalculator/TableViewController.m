//
//  TableViewController.m
//  tipcalculator
//
//  Created by Jiheng Lu on 10/9/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property NSMutableArray *history;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearData)];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)clearData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSMutableArray array] forKey:@"history"];
    _history = [defaults objectForKey:@"history"];
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _history = [defaults objectForKey:@"history"];

    return _history.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }

    NSMutableArray *data = [_history objectAtIndex:indexPath.row];
    
    NSLog(@"%@", data);
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", @"TipAmount: ", [[data objectAtIndex:0] description]];
    
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@%@", @"TipAmount: ", [[data objectAtIndex:1] description]];
    return cell;
}

@end

//
//  NNChannelViewController.m
//  NowAndNext
//
//  Created by Keith Moon on 03/09/2013.
//  Copyright (c) 2013 Data Ninjitsu. All rights reserved.
//

#import "NNChannelViewController.h"
#import "NNScheduleViewController.h"

@interface NNChannelViewController ()

@property (nonatomic, strong) NSArray *channelArray;

@end

@implementation NNChannelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.channelArray = @[@"bbcone", @"bbctwo", @"bbcthree", @"bbcfour", @"cbbc", @"cbeebies", @"bbcnews", @"parliament", @"bbcalba"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.channelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChannelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.channelArray[indexPath.row];
    
    return cell;
}

#pragma mark - Segue Methods 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NNScheduleViewController *scheduleVC = (NNScheduleViewController *)segue.destinationViewController;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    scheduleVC.channelName = self.channelArray[selectedIndexPath.row];
    
    if (selectedIndexPath.row == 0) {
        
        scheduleVC.region = @"london";
        
    } else if (selectedIndexPath.row == 1) {
        
        scheduleVC.region = @"england";
    
    }
}

@end

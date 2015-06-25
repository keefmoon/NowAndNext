//
//  NNScheduleViewController.m
//  NowAndNext
//
//  Created by Keith Moon on 03/09/2013.
//  Copyright (c) 2013 Data Ninjitsu. All rights reserved.
//

#import "NNScheduleViewController.h"
#import "NNDetailViewController.h"

@interface NNScheduleViewController ()

@property (nonatomic, strong) NSMutableArray *programmes;

@end

@implementation NNScheduleViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}
                             
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    self.title = self.channelName;
    
    NSString *scheduleString = [NSString stringWithFormat:@"http://www.bbc.co.uk/%@/programmes/schedules.json", self.channelName];
    if (self.region) {
        scheduleString = [NSString stringWithFormat:@"http://www.bbc.co.uk/%@/programmes/schedules/%@.json", self.channelName, self.region];
    }
    
    NSURL *scheduleURL = [NSURL URLWithString:scheduleString];
    NSURLRequest *request = [NSURLRequest requestWithURL:scheduleURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (error) {
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:error.description
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                               }
                               
                               NSDictionary *scheduleData = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:NSJSONReadingAllowFragments
                                                                                              error:nil];
                               
                               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                               dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
                               
                               NSArray *allProgrammes = scheduleData[@"schedule"][@"day"][@"broadcasts"];
                               
                               self.programmes = [NSMutableArray array];
                               
                               for (NSDictionary *programmeDetails in allProgrammes) {
                                   
                                   NSDate *endDate = [dateFormatter dateFromString:programmeDetails[@"end"]];
                                   
                                   if ([endDate timeIntervalSinceNow] > 0) {
                                       
                                       [self.programmes addObject:programmeDetails];
                                   }
                                   
                               }
                               NSLog(@"DATA: %@", self.programmes);
                               [self.tableView reloadData];
                               
                           }];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else {
        return self.programmes.count - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProgrammeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger programmeIndex = [self programmeIndexForIndexPath:indexPath];
    
    cell.textLabel.text = self.programmes[programmeIndex][@"programme"][@"display_titles"][@"title"];
    cell.detailTextLabel.text = self.programmes[programmeIndex][@"programme"][@"display_titles"][@"subtitle"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Now";
    } else {
        return @"Next";
    }
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushDetail"]) {
        
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        NSInteger programmeIndex = [self programmeIndexForIndexPath:selectedIndexPath];
        NSDictionary *programmeDictionary = self.programmes[programmeIndex];
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        NNDetailViewController *detailVC = (NNDetailViewController *)navController.topViewController;
        
        detailVC.programmeDictionary = programmeDictionary;
    }
    
}

#pragma mark - Helper Methods

- (NSInteger)programmeIndexForIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 0;
    } else {
        return indexPath.row+1;
    }
    
}

@end

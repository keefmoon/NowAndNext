//
//  NNDetailViewController.m
//  NowAndNext
//
//  Created by Keith Moon on 21/11/2013.
//  Copyright (c) 2013 Data Ninjitsu. All rights reserved.
//

#import "NNDetailViewController.h"

@interface NNDetailViewController ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *startLabel;
@property (nonatomic, strong) IBOutlet UILabel *endLabel;
@property (nonatomic, strong) IBOutlet UILabel *summaryLabel;

@property (nonatomic, strong) NSDateFormatter *inFormatter;
@property (nonatomic, strong) NSDateFormatter *outFormatter;

- (IBAction)doneButtonPressed:(id)sender;

@end

@implementation NNDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inFormatter = [[NSDateFormatter alloc] init];
    self.inFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    self.outFormatter = [[NSDateFormatter alloc] init];
    self.outFormatter.timeStyle = NSDateFormatterMediumStyle;
    self.outFormatter.dateStyle = NSDateFormatterMediumStyle;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.programmeDictionary) {
        
        self.titleLabel.text = self.programmeDictionary[@"programme"][@"display_titles"][@"title"];
        self.subTitleLabel.text = self.programmeDictionary[@"programme"][@"display_titles"][@"subtitle"];
        
        NSString *startDateString = self.programmeDictionary[@"start"];
        NSString *endDateString = self.programmeDictionary[@"end"];
        
        self.startLabel.text = [self formatTimeStamp:startDateString];
        self.endLabel.text = [self formatTimeStamp:endDateString];
        
        self.summaryLabel.text = self.programmeDictionary[@"programme"][@"short_synopsis"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        //Done
    }];
    
}

- (NSString *)formatTimeStamp:(NSString *)timestamp {
    
    NSDate *dateTime = [self.inFormatter dateFromString:self.programmeDictionary[@"start"]];
    NSString *formattedDate = [self.outFormatter stringFromDate:dateTime];
    
    return formattedDate;
}

@end

//
//  DaysViewController.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/10/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "DaysViewController.h"

@interface DaysViewController() <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSDateFormatter *weekdayFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation DaysViewController

#pragma mark - Lazy instantiation

- (NSMutableArray *)days
{
    if (!_days) {
        _days = [[NSMutableArray alloc] init];
    }
    return _days;
}

- (NSDateFormatter *)weekdayFormatter
{
    if (!_weekdayFormatter) {
        _weekdayFormatter = [[NSDateFormatter alloc] init];
        [_weekdayFormatter setDateFormat:@"EEEE"];
    }
    return _weekdayFormatter;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    return _dateFormatter;
}

#pragma mark -ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //change the font of the view controller's title
    self.title = @"All days";
    CGRect frame = CGRectZero;
    UILabel *viewControllerTitle = [[UILabel alloc] initWithFrame:frame];
    viewControllerTitle.backgroundColor = [UIColor clearColor];
    viewControllerTitle.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28];
    viewControllerTitle.textAlignment = NSTextAlignmentCenter;
    viewControllerTitle.textColor = [UIColor whiteColor];
    viewControllerTitle.text = self.navigationItem.title;
    [viewControllerTitle sizeToFit];
    // emboss in the same way as the native title
    [viewControllerTitle setShadowColor:[UIColor lightGrayColor]];
    [viewControllerTitle setShadowOffset:CGSizeMake(0.9, - 1.3)];
    self.navigationItem.titleView = viewControllerTitle;
    
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    
    self.days = [self lastSevenDays];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
    
    NSDate *currentDay = self.days[indexPath.row];
    
    cell.textLabel.text = [self.weekdayFormatter stringFromDate:currentDay];
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:currentDay];
    
    return cell;
}

#pragma mark - Helper methods

- (NSMutableArray *)lastSevenDays
{
    NSMutableArray *sevenDays = [[NSMutableArray alloc] init];
    
    NSDate *now = [NSDate date];
    [sevenDays addObject:now];
    
    for (int i = 1; i < 7; i++) {
        NSDate *nextDate = [now dateByAddingTimeInterval: i*24*60*60];
        [sevenDays addObject:nextDate];
    }
    
    return sevenDays;
}

@end

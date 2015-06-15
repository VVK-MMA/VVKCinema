//
//  DaysViewController.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/10/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "DaysViewController.h"
#import "VVKCinemaInfo.h"
#import "DayCell.h"

@interface DaysViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSDate *currentDay;

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
    
    [self.days addObject:@"All"];

    [self.days addObjectsFromArray:[self lastThirtyDays]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
    
    self.currentDay = self.days[indexPath.row];
        
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DayCell *)cell atIndexPath:(NSIndexPath *)indexPath {    
    cell.date = self.currentDay;
}


#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == 0 ) {
        [[VVKCinemaInfo sharedVVKCinemaInfo] setDaysPredicate:nil];
    } else {
        NSDate *day = self.days[indexPath.row];
        
        [[VVKCinemaInfo sharedVVKCinemaInfo] setDaysPredicate:[NSPredicate predicateWithFormat:@"releaseDate <= %@", day]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedDayPredicate" object:nil];
    
    //    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - Helper methods

- (NSMutableArray *)lastThirtyDays
{
    NSMutableArray *sevenDays = [[NSMutableArray alloc] init];
    
    NSDate *now = [NSDate date];
    [sevenDays addObject:now];
    
    for (int i = 1; i < 30; i++) {
        NSDate *nextDate = [now dateByAddingTimeInterval: i*24*60*60];
        [sevenDays addObject:nextDate];
    }
    
    return sevenDays;
}

@end

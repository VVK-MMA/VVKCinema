//
//  TypeViewController.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/10/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "TypeViewController.h"
#import "ParseInfo.h"
#import "ProjectionType.h"
#import "VVKCinemaInfo.h"
#import "CoreDataInfo.h"

@interface TypeViewController() <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *typeArray;

@end

@implementation TypeViewController

#pragma mark -ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //change the font of the view controller's title
    self.title = @"Type";
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
    
    NSArray *typesArray = [[CoreDataInfo sharedCoreDataInfo] fetchAllObjectsWithClassName:@"Hall"];
    
    self.typeArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.typeArray addObject:@"All"];

    for (ProjectionType *type in typesArray) {
        [self.typeArray addObject:type.name];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.typeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell" forIndexPath:indexPath];
    
    NSString *currentType = self.typeArray[indexPath.row];
    
    cell.textLabel.text = currentType;
    
    if ( indexPath.row == [[[VVKCinemaInfo sharedVVKCinemaInfo] currentType] integerValue] ) {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentType:[NSNumber numberWithInteger:indexPath.row]];

    if ( indexPath.row == 0 ) {
        [[VVKCinemaInfo sharedVVKCinemaInfo] setTypePredicate:nil];
    } else {
        NSString *type = self.typeArray[indexPath.row];

        [[VVKCinemaInfo sharedVVKCinemaInfo] setTypePredicate:[NSPredicate predicateWithFormat:@"ANY halls.name contains[c] %@", type]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedTypePredicate" object:nil];
    
    [self performSegueWithIdentifier:@"UnwindToType" sender:self];
}

@end

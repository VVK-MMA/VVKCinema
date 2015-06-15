//
//  GenreViewController.m
//  VVKCinema
//
//  Created by AdrenalineHvata on 6/10/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "GenreViewController.h"
#import "ParseInfo.h"
#import "Genre.h"
#import "VVKCinemaInfo.h"
#import "CoreDataInfo.h"

@interface GenreViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *genreArray;

@end

@implementation GenreViewController

#pragma mark -ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //change the font of the view controller's title
    self.title = @"Genre";
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
    
    NSArray *genresArray = [[CoreDataInfo sharedCoreDataInfo] fetchAllObjectsWithClassName:@"Genre"];
    
    self.genreArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.genreArray addObject:@"All"];
    
    for (Genre *genre in genresArray) {
        [self.genreArray addObject:genre.name];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.genreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell" forIndexPath:indexPath];
    
    NSString *currentType = self.genreArray[indexPath.row];
    
    cell.textLabel.text = currentType;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == 0 ) {
        [[VVKCinemaInfo sharedVVKCinemaInfo] setGenrePredicate:nil];
    } else {
        NSString *genre = self.genreArray[indexPath.row];
        
        [[VVKCinemaInfo sharedVVKCinemaInfo] setGenrePredicate:[NSPredicate predicateWithFormat:@"ANY genres.name like %@", genre]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedGenrePredicate" object:nil];
    
    [self performSegueWithIdentifier:@"UnwindToGenre" sender:self];
}

@end

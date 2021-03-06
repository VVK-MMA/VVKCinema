//
//  SortOptionsViewController.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/9/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "SortOptionsViewController.h"
#import "VVKCinemaInfo.h"

@interface SortOptionsViewController()

@property (weak, nonatomic) IBOutlet UIButton *alphabetButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@end

@implementation SortOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.alphabetButton.layer.cornerRadius = self.alphabetButton.frame.size.height /2;
    self.alphabetButton.layer.masksToBounds = YES;
    self.alphabetButton.layer.borderWidth = 0;
    self.alphabetButton.backgroundColor = [UIColor grayColor];
    
    self.ratingButton.layer.cornerRadius = self.alphabetButton.frame.size.height /2;
    self.ratingButton.layer.masksToBounds = YES;
    self.ratingButton.layer.borderWidth = 0;
    self.ratingButton.backgroundColor = [UIColor grayColor];
    
    self.dateButton.layer.cornerRadius = self.alphabetButton.frame.size.height /2;
    self.dateButton.layer.masksToBounds = YES;
    self.dateButton.layer.borderWidth = 0;
    self.dateButton.backgroundColor = [UIColor grayColor];
    
    if ( [[[VVKCinemaInfo sharedVVKCinemaInfo] sort] isEqualToString:@"releaseDate"] || ![[VVKCinemaInfo sharedVVKCinemaInfo] sort] ) {
        self.dateButton.backgroundColor = [UIColor orangeColor];
    } else if ( [[[VVKCinemaInfo sharedVVKCinemaInfo] sort] isEqualToString:@"name"] ) {
        self.alphabetButton.backgroundColor = [UIColor orangeColor];
    } else if ( [[[VVKCinemaInfo sharedVVKCinemaInfo] sort] isEqualToString:@"rate"] ) {
        self.ratingButton.backgroundColor = [UIColor orangeColor];
    }
}

#pragma mark - IBActions

- (IBAction)dismissVC:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)addSortOption:(id)sender {
    if ( [sender tag] == 0 ) {
        if ( [[[VVKCinemaInfo sharedVVKCinemaInfo] sort] isEqualToString:@"name"] || [[[VVKCinemaInfo sharedVVKCinemaInfo] sort] isEqualToString:@"rate"] ) {
            [[VVKCinemaInfo sharedVVKCinemaInfo] setSortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"releaseDate" ascending:NO]];
            [[VVKCinemaInfo sharedVVKCinemaInfo] setSort:@"releaseDate"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedSortOption" object:nil];
        }
    } else if ( [sender tag] == 1 ) {
        if ( ![[[VVKCinemaInfo sharedVVKCinemaInfo] sort] isEqualToString:@"name"] ) {
            [[VVKCinemaInfo sharedVVKCinemaInfo] setSortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
            [[VVKCinemaInfo sharedVVKCinemaInfo] setSort:@"name"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedSortOption" object:nil];
        }
    } else if ( [sender tag] == 2 ) {
        if ( ![[[VVKCinemaInfo sharedVVKCinemaInfo] sort] isEqualToString:@"rate"] ) {
            [[VVKCinemaInfo sharedVVKCinemaInfo] setSortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"rate" ascending:NO]];
            [[VVKCinemaInfo sharedVVKCinemaInfo] setSort:@"rate"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedSortOption" object:nil];
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedSortOption" object:nil];
    
    [self dismissVC:sender];
}

@end

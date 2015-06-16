//
//  DetailsViewController.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/17/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "DetailsViewController.h"
#import "VVKCinemaInfo.h"
#import "Movie.h"
#import "CoreDataInfo.h"
#import "Director.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Movie *selectedMovie = [[[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Movie" objectId:[[VVKCinemaInfo sharedVVKCinemaInfo] selectedMovie] andContext:[[CoreDataInfo sharedCoreDataInfo] context]] objectAtIndex:0];
    
    self.posterImageView.image = [UIImage imageWithData:selectedMovie.posterData];
    self.nameLabel.text = selectedMovie.name;
    
    NSMutableArray *genres = [NSMutableArray arrayWithCapacity:0];
    
    for ( NSManagedObject *genre in selectedMovie.genres ) {
        [genres addObject:[genre valueForKey:@"name"]];
    }
    
    NSString *joinedGenres = [genres componentsJoinedByString:@" * "];
    
    self.genresLabel.text = joinedGenres;
    
    Director *director = selectedMovie.director;
    
    self.directorLabel.text = [NSString stringWithFormat:@"DIRECTOR\n%@ %@", director.firstName, director.lastName];
    
    NSMutableArray *actors = [NSMutableArray arrayWithCapacity:0];
    
    for ( NSManagedObject *actor in selectedMovie.actors ) {
        [actors addObject:[NSString stringWithFormat:@"%@ %@", [actor valueForKey:@"firstName"], [actor valueForKey:@"lastName"]]];
    }
    
    NSString *joinedActors = [actors componentsJoinedByString:@"\n"];
    
    self.actorsLabel.text = [NSString stringWithFormat:@"ACTORS\n%@", joinedActors];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd.MM.yy"]; // Date formater
    NSString *date = [dateformat stringFromDate:[NSDate date]]; // Convert date to string

    self.releaseDateLabel.text = [NSString stringWithFormat:@"%@ min * %@", selectedMovie.duration, date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

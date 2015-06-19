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
#import "Projection.h"
#import "StartRatingControl.h"
#import "CinemaPickerView.h"

@interface DetailsViewController ()<StarRatingDelegate,CinemaPickerViewDelegate,CinemaPickerViewDatasource>

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;


@property (weak, nonatomic) IBOutlet StarRatingControl *starView;

@end

@implementation DetailsViewController {
    CinemaPickerView *cinemaPicker;
    Movie *selectedMovie;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Setting up the picker
    cinemaPicker = [[CinemaPickerView alloc] initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, self.view.bounds.size.height-400.0)];
    cinemaPicker.datasource = self;
    cinemaPicker.delegate = self;
    [self.view addSubview:cinemaPicker];
    
    [cinemaPicker reloadData];
    
    // Setup starView
    self.starView.delegate = self;
    
    // Details Part
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationController.navigationBar.topItem.title = @"Back";

    selectedMovie = [[[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Movie" objectId:[[VVKCinemaInfo sharedVVKCinemaInfo] selectedMovie] andContext:[[CoreDataInfo sharedCoreDataInfo] context]] objectAtIndex:0];
    
    self.posterImageView.image = [UIImage imageWithData:selectedMovie.posterData];
    self.nameLabel.text = selectedMovie.name;
    self.starView.rating = [selectedMovie.rate integerValue];
    
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
    
    for ( Projection *projection in selectedMovie.projections ) {
        NSLog(@"%@", projection.parseId);
        NSLog(@"%@", projection.date);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rateMovie:(id)sender {
    NSLog(@"%lu", (unsigned long)self.starView.rating);
    
    selectedMovie.rate = [NSNumber numberWithInteger:self.starView.rating];
    
    [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"You rated %@ with %lu stars!", selectedMovie.name, (unsigned long)self.starView.rating] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -Cinema Picker View Life cycle


- (NSUInteger)numberOfComponentsForPickerView:(CinemaPickerView *)pickerView
{
    return 7;
}

- (NSUInteger)pickerView:(CinemaPickerView *)pickerView numberOfItemsForComponent:(NSUInteger)component
{
    return 7;
}

- (NSString *)pickerView:(CinemaPickerView *)pickerView textForItem:(NSInteger)item forComponent:(NSInteger)component
{
    NSString *value = @"";
    
    switch (component) {
        case 0:
            
            value = [NSString stringWithFormat:@"%ld.06", 18+item];
            break;
            
        case 1:
            switch (item) {
                case 0:
                    
                    value = @"IMAX";
                    break;
                    
                case 1:
                    
                    value = @"2D";
                    break;
                    
                case 2:
                    
                    value = @"3D";
                    break;
                    
       
                    
              //  default:
                 //   value = @"value";
                    break;
            }
            
            break;
            
        case 2:
            switch (item) {
                case 0:
                    
                    value = @"12:30";
                    break;
                    
                case 1:
                    
                    value = @"13:30";
                    break;
                    
                case 2:
                    
                    value = @"15:30";
                    break;
                    
                case 3:
                    
                    value = @"18:30";
                    break;
                    
                case 4:
                    
                    value = @"21:30";
                    break;
                    
            }
            
            break;
            
       // default:
         //   value = @"value";
           // break;
    }
    
    return value;
}

- (NSString *)pickerView:(CinemaPickerView *)pickerView titleForComponent:(NSUInteger)component
{
    NSString *value = @"";
    
    switch (component) {
        case 0:
            value = @"Date";
            break;
        case 1:
            value = @"Type";
            break;
        case 2:
            value = @"Time";
            break;
        
         
    }
    
    return value;
}

- (void)pickerView:(CinemaPickerView *)pickerView didSelectItem:(NSUInteger)item forComponent:(NSUInteger)component
{
    NSLog(@"COMPONENT: %lu; ITEM: %lu", (unsigned long)component, (unsigned long)item);
}

- (UIColor *)selectionColorForPickerView:(CinemaPickerView *)pickerView
{
    return [UIColor colorWithRed:62.0/255.0 green:116.0/255.0 blue:1.0 alpha:1.0];
}

- (void)reload
{
    [cinemaPicker reloadData];
}

@end

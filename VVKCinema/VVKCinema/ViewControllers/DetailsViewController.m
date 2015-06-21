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
#import "Hall.h"

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
    NSMutableArray *hallsArray;
    NSMutableArray *timesArray;
    NSMutableArray *datesArray;
    NSString *selectedDate;
    NSString *selectedTime;
    NSArray *projectionsArray;
    NSInteger selectedProjectionIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //imageView setup
    self.posterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.posterImageView.layer.borderWidth = 5.0f;
    self.posterImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.posterImageView.layer.shadowRadius = 4.0f;
    self.posterImageView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.posterImageView.layer.shadowOpacity = 0.5f;
    
    //Setting up the picker
    cinemaPicker = [[CinemaPickerView alloc] initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, self.view.bounds.size.height-450.0)];
    cinemaPicker.datasource = self;
    cinemaPicker.delegate = self;
    [self.view addSubview:cinemaPicker];
    
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
    
    //
    hallsArray = [NSMutableArray arrayWithCapacity:0];
    timesArray = [NSMutableArray arrayWithCapacity:0];
    datesArray = [self nextSevenDays];
    
    projectionsArray = [[CoreDataInfo sharedCoreDataInfo] fetchAllProjectionsWithDate:datesArray[0] movieId:selectedMovie.parseId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];

    NSLog(@"%@", selectedMovie.parseId);
    
    for (Projection *projection in projectionsArray) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSString *timeString = [formatter stringFromDate:projection.date];
        
        [timesArray addObject:timeString];
    }
    
    [cinemaPicker reloadData];
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


#pragma mark -Cinema Picker View Life cycle

- (NSDate *)todayPlusDays:(NSInteger)days {
    NSDate *today = [NSDate date];
    
    return [today dateByAddingTimeInterval:60 * 60 * 24 * days];
}

- (NSMutableArray *)nextSevenDays {
    NSMutableArray *nextSevenDays = [NSMutableArray arrayWithCapacity:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d.MM"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [nextSevenDays addObject:dateString];
    
    for (int i = 1; i < 7; i++) {
        [nextSevenDays addObject:[dateFormatter stringFromDate:[self todayPlusDays:i]]];
    }
    
    return nextSevenDays;
}

- (NSUInteger)numberOfComponentsForPickerView:(CinemaPickerView *)pickerView
{
    return 3;
}

- (NSUInteger)pickerView:(CinemaPickerView *)pickerView numberOfItemsForComponent:(NSUInteger)component
{
    if ( component == 0 ) {
        return [datesArray count];
    } else if ( component == 1 ) {
        return 2;
    }
    
    return [timesArray count];
}

- (NSString *)pickerView:(CinemaPickerView *)pickerView textForItem:(NSInteger)item forComponent:(NSInteger)component
{
    NSString *value = @"";
    
    switch (component) {
        case 0:
            switch (item) {
                case 0:
                    value = datesArray[0];
                    
                    break;
                case 1:
                    value = datesArray[1];
                    
                    break;
                case 2:
                    value = datesArray[2];
                    
                    break;
                case 3:
                    value = datesArray[3];
                    
                    break;
                case 4:
                    value = datesArray[4];
                    
                    break;
                case 5:
                    value = datesArray[5];
                    
                    break;
                case 6:
                    value = datesArray[6];
                    
                    break;
                case 7:
                    value = datesArray[7];
                    
                    break;
            }
            
            break;
        case 1:
            switch (item) {
                case 0:
                    value = @"IMAX";
                    
                    break;
                case 1:
                    value = @"4DX";
                    
                    break;
            }
            
            break;
        case 2:
            switch (item) {
                case 0:
                    value = timesArray[0];
                    
                    break;
                case 1:
                    value = timesArray[1];
                    
                    break;
                case 2:
                    value = timesArray[2];
                    
                    break;
                case 3:
                    value = timesArray[3];
                    
                    break;
                case 4:
                    value = timesArray[4];
                    
                    break;
                case 5:
                    value = timesArray[5];
                    
                    break;
            }
            
            break;
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
    
    if ( component == 0 ) {
//        if ( item > 0 ) {
//            NSArray *projectionsArray = [[CoreDataInfo sharedCoreDataInfo] fetchAllProjectionsWithDate:datesArray[item] movieId:selectedMovie.parseId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        projectionsArray = [[CoreDataInfo sharedCoreDataInfo] fetchAllProjectionsWithDate:datesArray[item] movieId:selectedMovie.parseId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
//            for (Projection *projection in projectionsArray) {
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                [formatter setDateFormat:@"HH:mm"];
//                NSString *timeString = [formatter stringFromDate:projection.date];
//                
//                [timesArray addObject:timeString];
//            }
            
//            [cinemaPicker reloadData];
            
            selectedDate = datesArray[item];
//        }
    } else if ( component == 2 ) {
        if ( [timesArray count] != 0 ) {
            selectedTime = timesArray[item];
            selectedProjectionIndex = item;
        }
    }
}

- (UIColor *)selectionColorForPickerView:(CinemaPickerView *)pickerView
{
    return [UIColor colorWithRed:62.0/255.0 green:116.0/255.0 blue:1.0 alpha:1.0];
}

- (void)reload
{
    [cinemaPicker reloadData];
}

- (IBAction)book:(id)sender {
//    NSString *dateString = [NSString stringWithFormat:@"%@ %@", selectedDate, selectedTime];
//    
//    // Convert string to date object
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"d.MM HH:mm"];
//    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    NSDate *date = [dateFormat dateFromString:dateString];
//    
//    NSLog(@"%@", dateString);
//    NSLog(@"%@", date);
    
    [[VVKCinemaInfo sharedVVKCinemaInfo] setSelectedProjection:projectionsArray[selectedProjectionIndex]];
}

@end

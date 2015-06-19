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
#import "InfoCell.h"
#import "StartRatingControl.h"

@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate, StarRatingDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet StarRatingControl *starView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Setting up the tableview
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    // Setup starView
    self.starView.delegate = self;
    
    // Details Part
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationController.navigationBar.topItem.title = @"Back";

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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table View Life cycle
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"1";
    }else if(section == 1)
    {
        return @"2";
    }else if(section == 2)
    {
        return @"3";
    }else if(section == 3)
    {
        return @"4";
    }else if(section == 4)
    {
        return @"5";
    }else if(section == 5)
    {
        return @"6";
    } else if(section == 5){
        
        return @"7";
    } else {
        return @"8";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"cell";
    InfoCell *cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil){
        cell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
    }else{
        cell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0) {
        NSLog(@"indexPath section%ld",(long)[indexPath section]);
        NSLog(@"rows === %ld",(long)[indexPath row]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end

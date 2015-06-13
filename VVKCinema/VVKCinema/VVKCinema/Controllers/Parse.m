//
//  Parse.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "Parse.h"
#import "Movie.h"
#import "Country.h"
#import "Director.h"
#import "Language.h"
#import "Actor.h"
#import "Genre.h"
#import "Hall.h"
#import "Projection.h"
#import "ProjectionType.h"
#import "Ticket.h"
#import "Seat.h"
#import "TicketType.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@implementation Parse

#define X_Parse_Application_Id @"Pz64OL0zYyDKrlRPA8ULclYo9dr9dt2xtrb4aufU"
#define X_Parse_REST_API_Key @"ZEA7E45RUzSJHg4ezCnn9B8fsYiAWUDNQW5bZsSC"

#pragma mark Class Methods

+ (id)sharedParse {
    static Parse *sharedParse = nil;
    
    @synchronized(self) {
        if ( sharedParse == nil )
            sharedParse = [[self alloc] init];
    }
    
    return sharedParse;
}

#pragma mark Public Methods

- (NSDictionary *)getAllObjectsWithType:(NSString *)type relatedToObjectWithClassName:(NSString *)className objectId:(NSString *)objectId andKeyName:(NSString *)keyName {
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] init];
    
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:X_Parse_Application_Id forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:X_Parse_REST_API_Key forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@?where={\"$relatedTo\":{\"object\":{\"__type\":\"Pointer\",\"className\":\"%@\",\"objectId\":\"%@\"},\"key\":\"%@\"}}", type, className, objectId, keyName];
    
    NSString *encodeURLSTring = [urlStringFull stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [NSURL URLWithString:encodeURLSTring];
    
    [parseRequest setURL:requestURL];
    
    NSURLResponse *res = nil;
    NSError *err = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:parseRequest returningResponse:&res error:&err];
    
    if ( data ) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        return responseDictionary;
    }
    
    return nil;
}

- (BOOL)isCoreDataContainsObjectWithClassName:(NSString *)className WithId:(NSString *)objectId {
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ( [delegate performSelector:@selector(managedObjectContext)] ) {
        context = [delegate managedObjectContext];
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:className];
    
    NSError *error = nil;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else {
        for (Movie *object in objects) {
            if ( [object.parseId isEqualToString:objectId] ) {
                return YES;
            }
        }
    }
    
    return  NO;
}

- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *saveError = nil;
    
    if ( ![context save:&saveError] )
    {
        NSLog(@"Save did not complete successfully. Error: %@", [saveError localizedDescription]);
    }
}

- (NSManagedObjectContext *)getContext {
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ( [delegate performSelector:@selector(managedObjectContext)] ) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (NSDictionary *)getObjectWithType:(NSString *)type andObjectId:(NSString *)objectId {
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] init];
    
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:X_Parse_Application_Id forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:X_Parse_REST_API_Key forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@/%@", type, objectId];
    
    NSString *encodeURLSTring = [urlStringFull stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [NSURL URLWithString:encodeURLSTring];
    
    [parseRequest setURL:requestURL];
    
    NSURLResponse *res = nil;
    NSError *err = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:parseRequest returningResponse:&res error:&err];
    
    if ( data ) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        return responseDictionary;
    }
    
    return nil;
}

- (NSData *)getAllObjectsWithType:(NSString *)type {
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] init];
    
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:X_Parse_Application_Id forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:X_Parse_REST_API_Key forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@", type];
    
    NSString *encodeURLSTring = [urlStringFull stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [NSURL URLWithString:encodeURLSTring];
    
    [parseRequest setURL:requestURL];
    
    NSURLResponse *res = nil;
    NSError *err = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:parseRequest returningResponse:&res error:&err];
    
    if ( data ) {
        return data;
    }
    
    return nil;
}

- (void)transferFromServerToCoreDataAllObjectsWithType:(NSString *)type {
    NSData *data = [self getAllObjectsWithType:type];
    
    if ( data ) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ( [type isEqualToString:@"Movie"] ) {
            for (id key in responseDictionary) {
                NSDictionary *moviesDictionary = responseDictionary[key];
                
                for (id movieDictionary in moviesDictionary) {
                    NSString *objectId = [movieDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", objectId);
                    
                    if ( [self isCoreDataContainsObjectWithClassName:@"Movie" WithId:objectId] ) {
                        continue;
                    }
                    
                    Movie *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:[self getContext]];
                    
                    newMovie.parseId = objectId;
                    
                    NSNumber *duration = [movieDictionary objectForKey:@"duration"];
                    NSLog(@"%@", duration);
                    newMovie.duration = duration;
                    
                    NSString *movieInfo = [movieDictionary objectForKey:@"info"];
                    NSLog(@"%@", movieInfo);
                    newMovie.info = movieInfo;
                    
                    NSString *name = [movieDictionary objectForKey:@"name"];
                    NSLog(@"%@", name);
                    newMovie.name = name;
                    
                    NSDictionary *posterDictionary = [movieDictionary objectForKey:@"poster"];
                    NSString *posterUrl = [posterDictionary objectForKey:@"url"];
                    NSLog(@"%@", posterUrl);
                    newMovie.poster = posterUrl;
                    
                    NSNumber *rate = [movieDictionary objectForKey:@"rate"];
                    NSLog(@"%@", rate);
                    newMovie.rate = rate;
                    
                    NSDictionary *releaseDateDictionary = [movieDictionary objectForKey:@"releaseDate"];
                    NSString *releaseDateIso = [releaseDateDictionary objectForKey:@"iso"];
                    NSLog(@"%@", releaseDateIso);
                        
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                    NSDate *capturedStartDate = [dateFormatter dateFromString:releaseDateIso];
                    NSLog(@"%@", capturedStartDate);
                    newMovie.releaseDate = capturedStartDate;
                    
                    NSNumber *subtitled = [movieDictionary objectForKey:@"subtitled"];
                    NSLog(@"%@", subtitled);
                    newMovie.subtitled = subtitled;
                    
                    NSDictionary *countryDictionary = [movieDictionary objectForKey:@"country"];
                    NSString *countryId = [countryDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", countryId);
                        
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Country" WithId:countryId] ) {
                        NSDictionary *countryDict = [self getObjectWithType:@"Country" andObjectId:countryId];
                        NSString *countryName = [countryDict objectForKey:@"name"];
                        NSLog(@"%@", countryName);
                            
                        Country *newCountry = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:[self getContext]];
                            
                        newCountry.parseId = countryId;
                        newCountry.name = countryName;
                            
//                        [self saveContext:[self getContext]];
                    }
                    
                    NSDictionary *directorDictionary = [movieDictionary objectForKey:@"director"];
                    NSString *directorId = [directorDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", directorId);
                        
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Director" WithId:directorId] ) {
                        NSDictionary *directorDict = [self getObjectWithType:@"Director" andObjectId:directorId];
                        NSString *directorFirstName = [directorDict objectForKey:@"firstName"];
                        NSString *directorLastName = [directorDict objectForKey:@"lastName"];
                        NSString *directorName = [NSString stringWithFormat:@"%@ %@", directorFirstName, directorLastName];
                        NSLog(@"%@", directorName);
                            
                        Director *newDirector = [NSEntityDescription insertNewObjectForEntityForName:@"Director" inManagedObjectContext:[self getContext]];
                            
                        newDirector.parseId = directorId;
                        newDirector.firstName = directorFirstName;
                        newDirector.lastName = directorLastName;
                            
//                        [self saveContext:[self getContext]];
                    }
                        
                    NSDictionary *languageDictionary = [movieDictionary objectForKey:@"language"];
                    NSString *languageId = [languageDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", languageId);
                        
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Language" WithId:languageId] ) {
                        NSDictionary *languageDict = [self getObjectWithType:@"Language" andObjectId:languageId];
                        NSString *languageName = [languageDict objectForKey:@"name"];
                        NSLog(@"%@", languageName);
                            
                        Language *newLanguage = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:[self getContext]];
                        
                        newLanguage.parseId = languageId;
                        newLanguage.name = languageName;
                            
//                        [self saveContext:[self getContext]];
                    }
                        
                    NSDictionary *actorsResultsDictionary = [self getAllObjectsWithType:@"Actor" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"actors"];
                    for (id actorsResultsDictionaryKey in actorsResultsDictionary) {
                        NSDictionary *actorsDictionary = actorsResultsDictionary[actorsResultsDictionaryKey];
                            
                        for (id actorDictionary in actorsDictionary) {
                            NSString *actorObjectId = [actorDictionary objectForKey:@"objectId"];
                            NSLog(@"%@", actorObjectId);
                                
                            if ( ![self isCoreDataContainsObjectWithClassName:@"Actor" WithId:actorObjectId] ) {
                                NSString *actorFirstName = [actorDictionary objectForKey:@"firstName"];
                                NSString *actorLastName = [actorDictionary objectForKey:@"lastName"];
                                NSString *actorName = [NSString stringWithFormat:@"%@ %@", actorFirstName, actorLastName];
                                NSLog(@"%@", actorName);
                                    
                                Actor *newActor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[self getContext]];
                                    
                                newActor.parseId = actorObjectId;
                                newActor.firstName = actorFirstName;
                                newActor.lastName = actorLastName;
                                
//                                [self saveContext:[self getContext]];
                            
                                [newMovie addActorsObject:newActor];
                            }
                        }
                    }
                        
                    NSDictionary *genresResultsDictionary = [self getAllObjectsWithType:@"Genre" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"genres"];
                    for (id genresResultsDictionaryKey in genresResultsDictionary) {
                        NSDictionary *genresDictionary = genresResultsDictionary[genresResultsDictionaryKey];
                            
                        for (id genreDictionary in genresDictionary) {
                            NSString *genreObjectId = [genreDictionary objectForKey:@"objectId"];
                            NSLog(@"%@", genreObjectId);
                                
                            if ( ![self isCoreDataContainsObjectWithClassName:@"Genre" WithId:genreObjectId] ) {
                                NSString *genreName = [genreDictionary objectForKey:@"name"];
                                NSLog(@"%@", genreName);
                                    
                                Genre *newGenre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[self getContext]];
                                
                                newGenre.parseId = genreObjectId;
                                newGenre.name = genreName;
                                    
//                                [self saveContext:[self getContext]];
                                
                                [newMovie addGenresObject:newGenre];
                            }
                        }
                    }
                        
                    NSDictionary *hallsResultsDictionary = [self getAllObjectsWithType:@"Hall" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"halls"];
                    for (id hallsResultsDictionaryKey in hallsResultsDictionary) {
                        NSDictionary *hallsDictionary = hallsResultsDictionary[hallsResultsDictionaryKey];
                            
                        for (id hallDictionary in hallsDictionary) {
                            NSString *hallObjectId = [hallDictionary objectForKey:@"objectId"];
                            NSLog(@"%@", hallObjectId);
                                
                            if ( ![self isCoreDataContainsObjectWithClassName:@"Hall" WithId:hallObjectId] ) {
                                NSString *hallName = [hallDictionary objectForKey:@"name"];
                                NSLog(@"%@", hallName);
                                    
                                Hall *newHall = [NSEntityDescription insertNewObjectForEntityForName:@"Hall" inManagedObjectContext:[self getContext]];
                                    
                                newHall.parseId = hallObjectId;
                                newHall.name = hallName;
                                    
//                                [self saveContext:[self getContext]];
                                
                                [newMovie addHallsObject:newHall];
                            }

                        }
                    }
                    
                    NSArray *countryArray = [self fetchObjectWithEntityName:@"Country" objectId:countryId andContext:[self getContext]];
                        
                    if ( countryArray ) {
                        newMovie.country = countryArray[0];
                        Country *checkCountry = newMovie.country;
                        NSLog(@"%@", checkCountry.name);
                    }
                        
                    NSArray *directorArray = [self fetchObjectWithEntityName:@"Director" objectId:directorId andContext:[self getContext]];
                        
                    if ( directorArray ) {
                        newMovie.director = directorArray[0];
                        Director *checkDirector = newMovie.director;
                        NSLog(@"%@", checkDirector.firstName);
                    }
                        
                    NSArray *languageArray = [self fetchObjectWithEntityName:@"Language" objectId:languageId andContext:[self getContext]];
                        
                    if ( languageArray ) {
                        newMovie.language = languageArray[0];
                        Language *checkLanguage = newMovie.language;
                        NSLog(@"%@", checkLanguage.name);
                    }
                        
//                    [self saveContext:[self getContext]];
                }
            }
            
            [self saveContext:[self getContext]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesAddedToCoreData" object:nil];
        } else if ( [type isEqualToString:@"Projection"] ) {
            for (id key in responseDictionary) {
                NSDictionary *projectionsDictionary = responseDictionary[key];
                    
                for (id projectionDictionary in projectionsDictionary) {
                    NSString *projectionObjectId = [projectionDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", projectionObjectId);
                        
                    if ( [self isCoreDataContainsObjectWithClassName:@"Projection" WithId:projectionObjectId] ) {
                        continue;
                    }
                        
                    Projection *newProjection = [NSEntityDescription insertNewObjectForEntityForName:@"Projection" inManagedObjectContext:[self getContext]];
                    
                    newProjection.parseId = projectionObjectId;
                    
                    NSDictionary *projectionDateDictionary = [projectionDictionary objectForKey:@"date"];
                    NSString *projectionDateIso = [projectionDateDictionary objectForKey:@"iso"];
                    NSLog(@"%@", projectionDateIso);
                        
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                    NSDate *capturedStartDate = [dateFormatter dateFromString:projectionDateIso];
                    NSLog(@"%@", capturedStartDate);
                    newProjection.date = capturedStartDate;
                    
                    NSDictionary *projectionHallDictionary = [projectionDictionary objectForKey:@"hall"];
                    NSString *projectionHallId = [projectionHallDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", projectionHallId);
                        
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Hall" WithId:projectionHallId] ) {
                        NSDictionary *projectionHallDict = [self getObjectWithType:@"Hall" andObjectId:projectionHallId];
                        NSString *projectionHallName = [projectionHallDict objectForKey:@"name"];
                        NSLog(@"%@", projectionHallName);
                            
                        Hall *newHall = [NSEntityDescription insertNewObjectForEntityForName:@"Hall" inManagedObjectContext:[self getContext]];
                            
                        newHall.parseId = projectionHallId;
                        newHall.name = projectionHallName;
                            
//                        [self saveContext:[self getContext]];
                    }
                        
                    NSDictionary *projectionMovieDictionary = [projectionDictionary objectForKey:@"movie"];
                    NSString *projectionMovieId = [projectionMovieDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", projectionMovieId);
                        
                    NSDictionary *projectionProjectionTypeDictionary = [projectionDictionary objectForKey:@"projectionType"];
                    NSString *projectionProjectionTypeId = [projectionProjectionTypeDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", projectionProjectionTypeId);
                        
                    if ( ![self isCoreDataContainsObjectWithClassName:@"ProjectionType" WithId:projectionProjectionTypeId] ) {
                        NSDictionary *projectionProjectionTypeDict = [self getObjectWithType:@"ProjectionType" andObjectId:projectionProjectionTypeId];
                        NSString *projectionProjectionTypeName = [projectionProjectionTypeDict objectForKey:@"name"];
                        NSLog(@"%@", projectionProjectionTypeName);
                            
                        ProjectionType *newProjectionType = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectionType" inManagedObjectContext:[self getContext]];
                        
                        newProjectionType.parseId = projectionProjectionTypeId;
                        newProjectionType.name = projectionProjectionTypeName;
                            
//                        [self saveContext:[self getContext]];
                    }
                    
                    NSArray *hallArray = [self fetchObjectWithEntityName:@"Hall" objectId:projectionHallId andContext:[self getContext]];
                    
                    if ( hallArray ) {
                        newProjection.hall = hallArray[0];
                        Hall *checkHall = newProjection.hall;
                        NSLog(@"%@", checkHall.name);
                    }
                        
                    NSArray *movieArray = [self fetchObjectWithEntityName:@"Movie" objectId:projectionMovieId andContext:[self getContext]];
                        
                    if ( [movieArray count] > 0 ) {
                        newProjection.movie = movieArray[0];
                        Movie *checkMovie = newProjection.movie;
                        NSLog(@"%@", checkMovie.name);
                    }
                        
                    NSArray *projectionTypeArray = [self fetchObjectWithEntityName:@"ProjectionType" objectId:projectionProjectionTypeId andContext:[self getContext]];
                        
                    if ( projectionTypeArray ) {
                        newProjection.projectionType = projectionTypeArray[0];
                        ProjectionType *checkProjectionType = newProjection.projectionType;
                        NSLog(@"%@", checkProjectionType.name);
                    }
                        
//                    [self saveContext:[self getContext]];
                }
            }
            
            [self saveContext:[self getContext]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectionsAddedToCoreData" object:nil];
        } else if ( [type isEqualToString:@"Ticket"] ) {
            for (id key in responseDictionary) {
                NSDictionary *ticketsDictionary = responseDictionary[key];
                
                for (id ticketDictionary in ticketsDictionary) {
                    NSString *ticketObjectId = [ticketDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", ticketObjectId);
                        
                    if ( [self isCoreDataContainsObjectWithClassName:@"Ticket" WithId:ticketObjectId] ) {
                        continue;
                    }
                        
                    Ticket *newTicket = [NSEntityDescription insertNewObjectForEntityForName:@"Ticket" inManagedObjectContext:[self getContext]];
                    
                    newTicket.parseId = ticketObjectId;
                    
                    NSDictionary *seatDictionary = [ticketDictionary objectForKey:@"seat"];
                    NSString *seatId = [seatDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", seatId);
                        
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Seat" WithId:seatId] ) {
                        NSDictionary *seatDict = [self getObjectWithType:@"Seat" andObjectId:seatId];
                        NSNumber *seatBusy = [seatDict objectForKey:@"busy"];
                        NSLog(@"%@", seatBusy);
                            
                        NSNumber *seatColumn = [seatDict objectForKey:@"column"];
                        NSLog(@"%@", seatColumn);
                            
                        NSNumber *seatRow = [seatDict objectForKey:@"row"];
                        NSLog(@"%@", seatRow);
                            
                        NSDictionary *seatProjectionDictionary = [seatDict objectForKey:@"projection"];
                        NSString *seatProjectionId = [seatProjectionDictionary objectForKey:@"objectId"];
                        NSLog(@"%@", seatProjectionId);
                            
                        Seat *newSeat = [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:[self getContext]];
                            
                        newSeat.parseId = seatId;
                        newSeat.busy = seatBusy;
                        newSeat.column = seatColumn;
                        newSeat.row = seatRow;
                            
                        NSArray *seatProjectionArray = [self fetchObjectWithEntityName:@"Projection" objectId:seatProjectionId andContext:[self getContext]];
                            
                        if ( [seatProjectionArray count] > 0 ) {
                            newSeat.projection = seatProjectionArray[0];
                            Projection *checkProjection = newSeat.projection;
                            NSLog(@"%@", checkProjection.date);
                        }
                            
//                        [self saveContext:[self getContext]];
                    }
                        
                    NSDictionary *ticketTypeDictionary = [ticketDictionary objectForKey:@"ticketType"];
                    NSString *ticketTypeId = [ticketTypeDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", ticketTypeId);
                        
                    if ( ![self isCoreDataContainsObjectWithClassName:@"TicketType" WithId:ticketTypeId] ) {
                        NSDictionary *ticketTypeDict = [self getObjectWithType:@"TicketType" andObjectId:ticketTypeId];
                        NSString *ticketTypeName = [ticketTypeDict objectForKey:@"name"];
                        NSLog(@"%@", ticketTypeName);
                            
                        TicketType *newTicketType = [NSEntityDescription insertNewObjectForEntityForName:@"TicketType" inManagedObjectContext:[self getContext]];
                            
                        newTicketType.parseId = ticketTypeId;
                        newTicketType.name = ticketTypeName;
                        
//                        [self saveContext:[self getContext]];
                    }
                        
                    NSDictionary *userDictionary = [ticketDictionary objectForKey:@"user"];
                    NSString *userId = [userDictionary objectForKey:@"objectId"];
                    NSLog(@"%@", userId);
                        
                    if ( ![self isCoreDataContainsObjectWithClassName:@"User" WithId:userId] ) {
                        NSDictionary *userDict = [self getObjectWithType:@"User" andObjectId:userId];
                        NSString *userUsername = [userDict objectForKey:@"username"];
                        NSLog(@"%@", userUsername);
                            
                        NSString *userPassword = [userDict objectForKey:@"password"];
                        NSLog(@"%@", userPassword);
                            
                        NSString *userEmail = [userDict objectForKey:@"email"];
                        NSLog(@"%@", userEmail);
                            
                        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self getContext]];
                            
                        newUser.parseId = userId;
                        newUser.username = userUsername;
                        newUser.password = userPassword;
                        newUser.email = userEmail;
                            
//                        [self saveContext:[self getContext]];
                    }
                    
                    NSArray *seatArray = [self fetchObjectWithEntityName:@"Seat" objectId:seatId andContext:[self getContext]];
                        
                    if ( seatArray ) {
                        newTicket.seat = seatArray[0];
                        Seat *checkSeat = newTicket.seat;
                        NSLog(@"%@", checkSeat.row);
                    }
                    
                    NSArray *ticketTypeArray = [self fetchObjectWithEntityName:@"TicketType" objectId:ticketTypeId andContext:[self getContext]];
                        
                    if ( [ticketTypeArray count] > 0 ) {
                        newTicket.ticketType = ticketTypeArray[0];
                        TicketType *checkTicketType = newTicket.ticketType;
                        NSLog(@"%@", checkTicketType.name);
                    }
                        
                    NSArray *userArray = [self fetchObjectWithEntityName:@"User" objectId:userId andContext:[self getContext]];
                        
                    if ( userArray ) {
                        newTicket.user = userArray[0];
                        User *checkUser = newTicket.user;
                        NSLog(@"%@", checkUser.username);
                    }
                        
//                    [self saveContext:[self getContext]];
                }
            }
            
            [self saveContext:[self getContext]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TicketsAddedToCoreData" object:nil];
        }
        
    }
}

- (NSArray *)fetchObjectWithEntityName:(NSString *)entityName objectId:(NSString *)objectId andContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:[NSString stringWithFormat:@"%@", entityName] inManagedObjectContext:context]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"parseId = '%@'", objectId]];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *entitiesArray = [context executeFetchRequest:request error:&error];
    
    if ( error ) {
        NSLog(@"%@: Error fetching context: %@", [self class], [error localizedDescription]);
        NSLog(@"entitiesArray: %@",entitiesArray);
        
        return nil;
    }
    
    return entitiesArray;
}

@end

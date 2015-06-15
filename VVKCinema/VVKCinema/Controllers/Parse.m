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
#import <UIKit/UIKit.h>

#define X_Parse_Application_Id @"Pz64OL0zYyDKrlRPA8ULclYo9dr9dt2xtrb4aufU"
#define X_Parse_REST_API_Key @"ZEA7E45RUzSJHg4ezCnn9B8fsYiAWUDNQW5bZsSC"

@implementation Parse


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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:className];
    
    NSError *error = nil;
    
    NSArray *objects = [[[Parse sharedParse] getContext] executeFetchRequest:request error:&error];
    
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

+ (NSArray *)fetchAllObjectsWithClassName:(NSString *)className {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:className];
    
    NSError *error = nil;
    
    NSArray *objects = [[[Parse sharedParse] getContext] executeFetchRequest:request error:&error];
    
    if ( error != nil ) {
        NSLog(@"%@", error);
        
        return nil;
    }
    
    return objects;
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
                    
                    if ( [self isCoreDataContainsObjectWithClassName:@"Movie" WithId:objectId] ) {
                        continue;
                    }
                    
                    Movie *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:[self getContext]];
                    
                    newMovie.parseId = objectId;
                    
                    NSNumber *duration = [movieDictionary objectForKey:@"duration"];
                    newMovie.duration = duration;
                    
                    NSString *movieInfo = [movieDictionary objectForKey:@"info"];
                    newMovie.info = movieInfo;
                    
                    NSString *name = [movieDictionary objectForKey:@"name"];
                    newMovie.name = name;
                    
                    NSDictionary *posterDictionary = [movieDictionary objectForKey:@"poster"];
                    NSString *posterUrl = [posterDictionary objectForKey:@"url"];
                    newMovie.poster = posterUrl;
                    
                    NSNumber *rate = [movieDictionary objectForKey:@"rate"];
                    newMovie.rate = rate;
                    
                    NSDictionary *releaseDateDictionary = [movieDictionary objectForKey:@"releaseDate"];
                    NSString *releaseDateIso = [releaseDateDictionary objectForKey:@"iso"];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                    NSDate *capturedStartDate = [dateFormatter dateFromString:releaseDateIso];
                    newMovie.releaseDate = capturedStartDate;
                    
                    NSNumber *subtitled = [movieDictionary objectForKey:@"subtitled"];
                    newMovie.subtitled = subtitled;
                    
                    NSDictionary *countryDictionary = [movieDictionary objectForKey:@"country"];
                    NSString *countryId = [countryDictionary objectForKey:@"objectId"];
                    
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Country" WithId:countryId] ) {
                        NSDictionary *countryDict = [self getObjectWithType:@"Country" andObjectId:countryId];
                        NSString *countryName = [countryDict objectForKey:@"name"];
                        
                        Country *newCountry = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:[self getContext]];
                            
                        newCountry.parseId = countryId;
                        newCountry.name = countryName;
                            
//                        [self saveContext:[self getContext]];
                    }
                    
                    NSDictionary *directorDictionary = [movieDictionary objectForKey:@"director"];
                    NSString *directorId = [directorDictionary objectForKey:@"objectId"];
                    
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Director" WithId:directorId] ) {
                        NSDictionary *directorDict = [self getObjectWithType:@"Director" andObjectId:directorId];
                        NSString *directorFirstName = [directorDict objectForKey:@"firstName"];
                        NSString *directorLastName = [directorDict objectForKey:@"lastName"];
                        NSString *directorName = [NSString stringWithFormat:@"%@ %@", directorFirstName, directorLastName];
                        
                        Director *newDirector = [NSEntityDescription insertNewObjectForEntityForName:@"Director" inManagedObjectContext:[self getContext]];
                            
                        newDirector.parseId = directorId;
                        newDirector.firstName = directorFirstName;
                        newDirector.lastName = directorLastName;
                            
//                        [self saveContext:[self getContext]];
                    }
                        
                    NSDictionary *languageDictionary = [movieDictionary objectForKey:@"language"];
                    NSString *languageId = [languageDictionary objectForKey:@"objectId"];
                    
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Language" WithId:languageId] ) {
                        NSDictionary *languageDict = [self getObjectWithType:@"Language" andObjectId:languageId];
                        NSString *languageName = [languageDict objectForKey:@"name"];
                        
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
                            
                            if ( ![self isCoreDataContainsObjectWithClassName:@"Actor" WithId:actorObjectId] ) {
                                NSString *actorFirstName = [actorDictionary objectForKey:@"firstName"];
                                NSString *actorLastName = [actorDictionary objectForKey:@"lastName"];
                                NSString *actorName = [NSString stringWithFormat:@"%@ %@", actorFirstName, actorLastName];
                                
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
                            
                            if ( ![self isCoreDataContainsObjectWithClassName:@"Genre" WithId:genreObjectId] ) {
                                NSString *genreName = [genreDictionary objectForKey:@"name"];
                                
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
                            
                            if ( ![self isCoreDataContainsObjectWithClassName:@"Hall" WithId:hallObjectId] ) {
                                NSString *hallName = [hallDictionary objectForKey:@"name"];
                                
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
                    }
                        
                    NSArray *directorArray = [self fetchObjectWithEntityName:@"Director" objectId:directorId andContext:[self getContext]];
                        
                    if ( directorArray ) {
                        newMovie.director = directorArray[0];
                    }
                        
                    NSArray *languageArray = [self fetchObjectWithEntityName:@"Language" objectId:languageId andContext:[self getContext]];
                        
                    if ( languageArray ) {
                        newMovie.language = languageArray[0];
                    }
                }
            }
            
            [self saveContext:[self getContext]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesAddedToCoreData" object:nil];
        } else if ( [type isEqualToString:@"Projection"] ) {
            for (id key in responseDictionary) {
                NSDictionary *projectionsDictionary = responseDictionary[key];
                    
                for (id projectionDictionary in projectionsDictionary) {
                    NSString *projectionObjectId = [projectionDictionary objectForKey:@"objectId"];
                    
                    if ( [self isCoreDataContainsObjectWithClassName:@"Projection" WithId:projectionObjectId] ) {
                        continue;
                    }
                        
                    Projection *newProjection = [NSEntityDescription insertNewObjectForEntityForName:@"Projection" inManagedObjectContext:[self getContext]];
                    
                    newProjection.parseId = projectionObjectId;
                    
                    NSDictionary *projectionDateDictionary = [projectionDictionary objectForKey:@"date"];
                    NSString *projectionDateIso = [projectionDateDictionary objectForKey:@"iso"];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                    NSDate *capturedStartDate = [dateFormatter dateFromString:projectionDateIso];
                    newProjection.date = capturedStartDate;
                    
                    NSDictionary *projectionHallDictionary = [projectionDictionary objectForKey:@"hall"];
                    NSString *projectionHallId = [projectionHallDictionary objectForKey:@"objectId"];
                    
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Hall" WithId:projectionHallId] ) {
                        NSDictionary *projectionHallDict = [self getObjectWithType:@"Hall" andObjectId:projectionHallId];
                        NSString *projectionHallName = [projectionHallDict objectForKey:@"name"];
                        
                        Hall *newHall = [NSEntityDescription insertNewObjectForEntityForName:@"Hall" inManagedObjectContext:[self getContext]];
                            
                        newHall.parseId = projectionHallId;
                        newHall.name = projectionHallName;
                    }
                        
                    NSDictionary *projectionMovieDictionary = [projectionDictionary objectForKey:@"movie"];
                    NSString *projectionMovieId = [projectionMovieDictionary objectForKey:@"objectId"];
                    
                    NSDictionary *projectionProjectionTypeDictionary = [projectionDictionary objectForKey:@"projectionType"];
                    NSString *projectionProjectionTypeId = [projectionProjectionTypeDictionary objectForKey:@"objectId"];
                    
                    if ( ![self isCoreDataContainsObjectWithClassName:@"ProjectionType" WithId:projectionProjectionTypeId] ) {
                        NSDictionary *projectionProjectionTypeDict = [self getObjectWithType:@"ProjectionType" andObjectId:projectionProjectionTypeId];
                        NSString *projectionProjectionTypeName = [projectionProjectionTypeDict objectForKey:@"name"];
                        
                        ProjectionType *newProjectionType = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectionType" inManagedObjectContext:[self getContext]];
                        
                        newProjectionType.parseId = projectionProjectionTypeId;
                        newProjectionType.name = projectionProjectionTypeName;
                    }
                    
                    NSArray *hallArray = [self fetchObjectWithEntityName:@"Hall" objectId:projectionHallId andContext:[self getContext]];
                    
                    if ( hallArray ) {
                        newProjection.hall = hallArray[0];
                    }
                        
                    NSArray *movieArray = [self fetchObjectWithEntityName:@"Movie" objectId:projectionMovieId andContext:[self getContext]];
                        
                    if ( [movieArray count] > 0 ) {
                        newProjection.movie = movieArray[0];
                    }
                        
                    NSArray *projectionTypeArray = [self fetchObjectWithEntityName:@"ProjectionType" objectId:projectionProjectionTypeId andContext:[self getContext]];
                        
                    if ( projectionTypeArray ) {
                        newProjection.projectionType = projectionTypeArray[0];
                    }
                }
            }
            
            [self saveContext:[self getContext]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectionsAddedToCoreData" object:nil];
        } else if ( [type isEqualToString:@"Ticket"] ) {
            for (id key in responseDictionary) {
                NSDictionary *ticketsDictionary = responseDictionary[key];
                
                for (id ticketDictionary in ticketsDictionary) {
                    NSString *ticketObjectId = [ticketDictionary objectForKey:@"objectId"];
                    
                    if ( [self isCoreDataContainsObjectWithClassName:@"Ticket" WithId:ticketObjectId] ) {
                        continue;
                    }
                        
                    Ticket *newTicket = [NSEntityDescription insertNewObjectForEntityForName:@"Ticket" inManagedObjectContext:[self getContext]];
                    
                    newTicket.parseId = ticketObjectId;
                    
                    NSDictionary *seatDictionary = [ticketDictionary objectForKey:@"seat"];
                    NSString *seatId = [seatDictionary objectForKey:@"objectId"];
                    
                    if ( ![self isCoreDataContainsObjectWithClassName:@"Seat" WithId:seatId] ) {
                        NSDictionary *seatDict = [self getObjectWithType:@"Seat" andObjectId:seatId];
                        NSNumber *seatBusy = [seatDict objectForKey:@"busy"];
                        
                        NSNumber *seatColumn = [seatDict objectForKey:@"column"];
                        
                        NSNumber *seatRow = [seatDict objectForKey:@"row"];
                        
                        NSDictionary *seatProjectionDictionary = [seatDict objectForKey:@"projection"];
                        NSString *seatProjectionId = [seatProjectionDictionary objectForKey:@"objectId"];
                        
                        Seat *newSeat = [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:[self getContext]];
                            
                        newSeat.parseId = seatId;
                        newSeat.busy = seatBusy;
                        newSeat.column = seatColumn;
                        newSeat.row = seatRow;
                            
                        NSArray *seatProjectionArray = [self fetchObjectWithEntityName:@"Projection" objectId:seatProjectionId andContext:[self getContext]];
                            
                        if ( [seatProjectionArray count] > 0 ) {
                            newSeat.projection = seatProjectionArray[0];
                        }
                    }
                        
                    NSDictionary *ticketTypeDictionary = [ticketDictionary objectForKey:@"ticketType"];
                    NSString *ticketTypeId = [ticketTypeDictionary objectForKey:@"objectId"];
                    
                    if ( ![self isCoreDataContainsObjectWithClassName:@"TicketType" WithId:ticketTypeId] ) {
                        NSDictionary *ticketTypeDict = [self getObjectWithType:@"TicketType" andObjectId:ticketTypeId];
                        NSString *ticketTypeName = [ticketTypeDict objectForKey:@"name"];
                        
                        TicketType *newTicketType = [NSEntityDescription insertNewObjectForEntityForName:@"TicketType" inManagedObjectContext:[self getContext]];
                            
                        newTicketType.parseId = ticketTypeId;
                        newTicketType.name = ticketTypeName;
                    }
                        
                    NSDictionary *userDictionary = [ticketDictionary objectForKey:@"user"];
                    NSString *userId = [userDictionary objectForKey:@"objectId"];
                    
                    if ( ![self isCoreDataContainsObjectWithClassName:@"User" WithId:userId] ) {
                        NSDictionary *userDict = [self getObjectWithType:@"User" andObjectId:userId];
                        NSString *userUsername = [userDict objectForKey:@"username"];
                        
                        NSString *userPassword = [userDict objectForKey:@"password"];
                        
                        NSString *userEmail = [userDict objectForKey:@"email"];
                        
                        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self getContext]];
                            
                        newUser.parseId = userId;
                        newUser.username = userUsername;
                        newUser.password = userPassword;
                        newUser.email = userEmail;
                    }
                    
                    NSArray *seatArray = [self fetchObjectWithEntityName:@"Seat" objectId:seatId andContext:[self getContext]];
                        
                    if ( seatArray ) {
                        newTicket.seat = seatArray[0];
                    }
                    
                    NSArray *ticketTypeArray = [self fetchObjectWithEntityName:@"TicketType" objectId:ticketTypeId andContext:[self getContext]];
                        
                    if ( [ticketTypeArray count] > 0 ) {
                        newTicket.ticketType = ticketTypeArray[0];
                    }
                        
                    NSArray *userArray = [self fetchObjectWithEntityName:@"User" objectId:userId andContext:[self getContext]];
                        
                    if ( userArray ) {
                        newTicket.user = userArray[0];
                    }
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

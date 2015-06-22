//
//  Parse.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "ParseInfo.h"
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
#import "CoreDataInfo.h"

#import <UIKit/UIKit.h>

#define X_Parse_Application_Id @"Pz64OL0zYyDKrlRPA8ULclYo9dr9dt2xtrb4aufU"
#define X_Parse_REST_API_Key @"ZEA7E45RUzSJHg4ezCnn9B8fsYiAWUDNQW5bZsSC"

@implementation ParseInfo

#pragma mark Class Methods

+ (id)sharedParse {
    static ParseInfo *sharedParse = nil;
    
    @synchronized(self) {
        if ( sharedParse == nil )
            sharedParse = [[self alloc] init];
    }
    
    return sharedParse;
}


#pragma mark Private Methods

- (NSMutableURLRequest *)baseRequestWithParseHeaders {
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] init];
    
    [parseRequest setValue:X_Parse_Application_Id forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:X_Parse_REST_API_Key forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    return parseRequest;
}

- (NSMutableURLRequest *)baseGetRequestWithParseHeaders {
    NSMutableURLRequest *parseRequest = [self baseRequestWithParseHeaders];
    
    [parseRequest setHTTPMethod:@"GET"];
    
    return parseRequest;
}

- (NSMutableURLRequest *)basePostRequestWithParseHeaders {
    NSMutableURLRequest *parseRequest = [self baseRequestWithParseHeaders];
    
    [parseRequest setHTTPMethod:@"POST"];
    
    return parseRequest;
}

- (NSMutableURLRequest *)basePostRequestWithParseHeadersAndContentType {
    NSMutableURLRequest *parseRequest = [self basePostRequestWithParseHeaders];
    
    [parseRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return parseRequest;
}

- (NSDictionary *)responseFromSynchronousRequest:(NSMutableURLRequest *)parseRequest {
    NSURLResponse *res = nil;
    NSError *err = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:parseRequest returningResponse:&res error:&err];
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return responseDictionary;
}

- (NSDictionary *)getAllObjectsWithType:(NSString *)type relatedToObjectWithClassName:(NSString *)className objectId:(NSString *)objectId andKeyName:(NSString *)keyName {
    NSMutableURLRequest *parseRequest = [self baseGetRequestWithParseHeaders];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@?where={\"$relatedTo\":{\"object\":{\"__type\":\"Pointer\",\"className\":\"%@\",\"objectId\":\"%@\"},\"key\":\"%@\"}}", type, className, objectId, keyName];
    
    NSString *encodeURLSTring = [urlStringFull stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [NSURL URLWithString:encodeURLSTring];
    
    [parseRequest setURL:requestURL];
    
    return [self responseFromSynchronousRequest:parseRequest];
}

- (NSDictionary *)getObjectWithType:(NSString *)type andObjectId:(NSString *)objectId {
    NSMutableURLRequest *parseRequest = [self baseGetRequestWithParseHeaders];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@/%@", type, objectId];
    
    NSString *encodeURLSTring = [urlStringFull stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [NSURL URLWithString:encodeURLSTring];
    
    [parseRequest setURL:requestURL];
    
    return [self responseFromSynchronousRequest:parseRequest];
}

- (NSDictionary *)getAllObjectsWithType:(NSString *)type {
    NSMutableURLRequest *parseRequest = [self baseGetRequestWithParseHeaders];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@", type];
    NSString *encodeURLSTring = [urlStringFull stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [NSURL URLWithString:encodeURLSTring];
    
    [parseRequest setURL:requestURL];
    
    return [self responseFromSynchronousRequest:parseRequest];
}

- (void)setURLToParseRequest:(NSMutableURLRequest *)parseRequest WithString:(NSString *)urlString {
    NSString *encodeURLSTring = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [NSURL URLWithString:encodeURLSTring];
    
    [parseRequest setURL:requestURL];
}

- (void)setHTTPBodyToRequest:(NSMutableURLRequest *)request withDictionary:(NSDictionary *)dictionary {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setValue: [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
}


#pragma mark Public Methods

- (NSDictionary *)getSeatWithClassName:(NSString *)className column:(NSNumber *)column row:(NSNumber *)row fromProjection:(NSString *)projection {
    NSMutableURLRequest *parseRequest = [self baseGetRequestWithParseHeaders];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@?where={\"column\":%@,\"row\":%@,\"projectionId\":\"%@\"}}", className, column, row, projection];
    
    [self setURLToParseRequest:parseRequest WithString:urlStringFull];
    
    return [self responseFromSynchronousRequest:parseRequest];
}

- (NSDictionary *)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSMutableURLRequest *parseRequest = [self baseGetRequestWithParseHeaders];
    
    [parseRequest setValue:@"1" forHTTPHeaderField:@"X-Parse-Revocable-Session"];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/login?username=%@&password=%@", username, password];
    
    [self setURLToParseRequest:parseRequest WithString:urlStringFull];
    
    return [self responseFromSynchronousRequest:parseRequest];
}

- (void)sendSignUpRequestToParseWithName:(NSString *)name password:(NSString *)password andEmail:(NSString *)email {
    NSMutableURLRequest *request = [self basePostRequestWithParseHeadersAndContentType];
    
    [request setURL:[NSURL URLWithString:@"https://api.parse.com/1/users/"]];
    
    // Set HTTP headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"1" forHTTPHeaderField:@"X-Parse-Revocable-Session"];
    
    NSDictionary *dict = @{@"name":name, @"password":password, @"email":email, @"username":email};
    
    [self setHTTPBodyToRequest:request withDictionary:dict];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( !data ) {
            [self.delegate userDidPostSuccessfully:NO];
            
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
        
        if ( [httpResponse statusCode] == 201 ) {
            NSLog(@"Registration successful!");
            [self.delegate userDidPostSuccessfully:YES];
        } else {
//            NSLog(@"Registration failed!");
//            NSLog(@"%@", response);
            [self.delegate userDidPostSuccessfully:NO];
        }
    }];
}

- (void)bookNewSeatToParseWithColumn:(NSNumber *)column row:(NSNumber *)row andProjectionId:(NSString *)projectionId {
    NSMutableURLRequest *request = [self basePostRequestWithParseHeadersAndContentType];
    
    [request setURL:[NSURL URLWithString:@"https://api.parse.com/1/classes/Seat"]];
    
    NSDictionary *dict = @{@"column":column, @"row":row, @"projectionId":projectionId};
    
    [self setHTTPBodyToRequest:request withDictionary:dict];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( !data ) {
            [self.delegate userDidPostSuccessfully:NO];
            
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
        
        if ( [httpResponse statusCode] == 201 ) {
            NSLog(@"bookNewSeatToParse successful!");
            [self.delegate userDidPostSuccessfully:YES];
        } else {
            NSLog(@"bookNewSeatToParse failed!");
            NSLog(@"%@", response);
            [self.delegate userDidPostSuccessfully:NO];
        }
    }];
}

- (void)bookNewTicketToParseWithSeat:(NSString *)seat ticketType:(NSString *)ticketType andUserId:(NSString *)userId {
    NSMutableURLRequest *request = [self basePostRequestWithParseHeadersAndContentType];
    
    [request setURL:[NSURL URLWithString:@"https://api.parse.com/1/classes/Ticket"]];
    
//    NSDictionary *dict = @{@"seatId":seat, @"ticketType":ticketType, @"userId":userId};
    NSDictionary *dict = @{@"seatId":seat, @"user":userId};
    
    [self setHTTPBodyToRequest:request withDictionary:dict];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( !data ) {            
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
        
        if ( [httpResponse statusCode] == 201 ) {
            NSLog(@"bookNewTicketToParseWithSeat successful!");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
        } else {
            NSLog(@"bookNewTicketToParseWithSeat failed!");
            NSLog(@"%@", response);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BookedNewTicket" object:nil];
}

- (void)transferFromServerToCoreDataAllObjectsWithType:(NSString *)type {
    NSDictionary *responseDictionary = [self getAllObjectsWithType:type];
    
    if ( [type isEqualToString:@"Movie"] ) {
        for (id key in responseDictionary) {
            NSDictionary *moviesDictionary = responseDictionary[key];
            
            for (id movieDictionary in moviesDictionary) {
                NSString *objectId = [movieDictionary objectForKey:@"objectId"];
                
                if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Movie" andValue:objectId forKey:@"parseId"] ) {
                    continue;
                }
                
                Movie *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
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
                
                if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Country" andValue:countryId forKey:@"parseId"] ) {
                    NSDictionary *countryDict = [self getObjectWithType:@"Country" andObjectId:countryId];
                    NSString *countryName = [countryDict objectForKey:@"name"];
                    
                    Country *newCountry = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    newCountry.parseId = countryId;
                    newCountry.name = countryName;
                }
                
                NSDictionary *directorDictionary = [movieDictionary objectForKey:@"director"];
                NSString *directorId = [directorDictionary objectForKey:@"objectId"];
                
                if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Director" andValue:directorId forKey:@"parseId"] ) {
                    NSDictionary *directorDict = [self getObjectWithType:@"Director" andObjectId:directorId];
                    NSString *directorFirstName = [directorDict objectForKey:@"firstName"];
                    NSString *directorLastName = [directorDict objectForKey:@"lastName"];
                    
                    Director *newDirector = [NSEntityDescription insertNewObjectForEntityForName:@"Director" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    newDirector.parseId = directorId;
                    newDirector.firstName = directorFirstName;
                    newDirector.lastName = directorLastName;
                }
                
                NSDictionary *languageDictionary = [movieDictionary objectForKey:@"language"];
                NSString *languageId = [languageDictionary objectForKey:@"objectId"];
                
                if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Language" andValue:languageId forKey:@"parseId"] ) {
                    NSDictionary *languageDict = [self getObjectWithType:@"Language" andObjectId:languageId];
                    NSString *languageName = [languageDict objectForKey:@"name"];
                    
                    Language *newLanguage = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    newLanguage.parseId = languageId;
                    newLanguage.name = languageName;
                }
                
                NSDictionary *actorsResultsDictionary = [self getAllObjectsWithType:@"Actor" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"actors"];
                
                for (id actorsResultsDictionaryKey in actorsResultsDictionary) {
                    NSDictionary *actorsDictionary = actorsResultsDictionary[actorsResultsDictionaryKey];
                    
                    for (id actorDictionary in actorsDictionary) {
                        NSString *actorObjectId = [actorDictionary objectForKey:@"objectId"];
                        
                        if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Actor" andValue:actorObjectId forKey:@"parseId"] ) {
                            NSString *actorFirstName = [actorDictionary objectForKey:@"firstName"];
                            NSString *actorLastName = [actorDictionary objectForKey:@"lastName"];
                            
                            Actor *newActor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                            
                            newActor.parseId = actorObjectId;
                            newActor.firstName = actorFirstName;
                            newActor.lastName = actorLastName;
                            
                            [newMovie addActorsObject:newActor];
                        }
                    }
                }
                
                NSDictionary *genresResultsDictionary = [self getAllObjectsWithType:@"Genre" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"genres"];
                
                for (id genresResultsDictionaryKey in genresResultsDictionary) {
                    NSDictionary *genresDictionary = genresResultsDictionary[genresResultsDictionaryKey];
                    
                    for (id genreDictionary in genresDictionary) {
                        NSString *genreObjectId = [genreDictionary objectForKey:@"objectId"];
                        
                        if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Genre" andValue:genreObjectId forKey:@"parseId"] ) {
                            NSString *genreName = [genreDictionary objectForKey:@"name"];
                            
                            Genre *newGenre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                            
                            newGenre.parseId = genreObjectId;
                            newGenre.name = genreName;
                            
                            [newMovie addGenresObject:newGenre];
                        } else {
                            Genre *newGenre = [[[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Genre" objectId:genreObjectId andContext:[[CoreDataInfo sharedCoreDataInfo] context]] objectAtIndex:0];
                            
                            [newMovie addGenresObject:newGenre];
                        }
                    }
                }
                
                NSDictionary *hallsResultsDictionary = [self getAllObjectsWithType:@"Hall" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"halls"];
                
                for (id hallsResultsDictionaryKey in hallsResultsDictionary) {
                    NSDictionary *hallsDictionary = hallsResultsDictionary[hallsResultsDictionaryKey];
                    
                    for (id hallDictionary in hallsDictionary) {
                        NSString *hallObjectId = [hallDictionary objectForKey:@"objectId"];
                        
                        if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Hall" andValue:hallObjectId forKey:@"parseId"] ) {
                            NSString *hallName = [hallDictionary objectForKey:@"name"];
                            
                            Hall *newHall = [NSEntityDescription insertNewObjectForEntityForName:@"Hall" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                            
                            newHall.parseId = hallObjectId;
                            newHall.name = hallName;
                            
                            [newMovie addHallsObject:newHall];
                        } else {
                            Hall *newHall = [[[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Hall" objectId:hallObjectId andContext:[[CoreDataInfo sharedCoreDataInfo] context]] objectAtIndex:0];
                            
                            [newMovie addHallsObject:newHall];
                        }
                    }
                }
                
                NSArray *countryArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Country" objectId:countryId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( countryArray ) {
                    newMovie.country = countryArray[0];
                }
                
                NSArray *directorArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Director" objectId:directorId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( directorArray ) {
                    newMovie.director = directorArray[0];
                }
                
                NSArray *languageArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Language" objectId:languageId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( languageArray ) {
                    newMovie.language = languageArray[0];
                }
            }
        }
        
        [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesAddedToCoreData" object:nil];
    } else if ( [type isEqualToString:@"Projection"] ) {
        for (id key in responseDictionary) {
            NSDictionary *projectionsDictionary = responseDictionary[key];
            
            for (id projectionDictionary in projectionsDictionary) {
                NSString *projectionObjectId = [projectionDictionary objectForKey:@"objectId"];
                
                if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Projection" andValue:projectionObjectId forKey:@"parseId"] ) {
                    continue;
                }
                
                Projection *newProjection = [NSEntityDescription insertNewObjectForEntityForName:@"Projection" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                newProjection.parseId = projectionObjectId;
                
                NSDictionary *projectionDateDictionary = [projectionDictionary objectForKey:@"date"];
                NSString *projectionDateIso = [projectionDateDictionary objectForKey:@"iso"];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSDate *capturedStartDate = [dateFormatter dateFromString:projectionDateIso];
                newProjection.date = capturedStartDate;
                
                NSDictionary *projectionHallDictionary = [projectionDictionary objectForKey:@"hall"];
                NSString *projectionHallId = [projectionHallDictionary objectForKey:@"objectId"];
                
                if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Hall" andValue:projectionHallId forKey:@"parseId"] ) {
                    NSDictionary *projectionHallDict = [self getObjectWithType:@"Hall" andObjectId:projectionHallId];
                    NSString *projectionHallName = [projectionHallDict objectForKey:@"name"];
                    
                    Hall *newHall = [NSEntityDescription insertNewObjectForEntityForName:@"Hall" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    newHall.parseId = projectionHallId;
                    newHall.name = projectionHallName;
                    
                    newProjection.hall = newHall;
                } else {
                    Hall *newHall = [[[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Hall" objectId:projectionHallId andContext:[[CoreDataInfo sharedCoreDataInfo] context]] objectAtIndex:0];
                    
                    newProjection.hall = newHall;
                }
                
                NSDictionary *projectionMovieDictionary = [projectionDictionary objectForKey:@"movie"];
                NSString *projectionMovieId = [projectionMovieDictionary objectForKey:@"objectId"];
                
                NSDictionary *projectionProjectionTypeDictionary = [projectionDictionary objectForKey:@"projectionType"];
                NSString *projectionProjectionTypeId = [projectionProjectionTypeDictionary objectForKey:@"objectId"];
                
                if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"ProjectionType" andValue:projectionProjectionTypeId forKey:@"parseId"] ) {
                    NSDictionary *projectionProjectionTypeDict = [self getObjectWithType:@"ProjectionType" andObjectId:projectionProjectionTypeId];
                    NSString *projectionProjectionTypeName = [projectionProjectionTypeDict objectForKey:@"name"];
                    
                    ProjectionType *newProjectionType = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectionType" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    newProjectionType.parseId = projectionProjectionTypeId;
                    newProjectionType.name = projectionProjectionTypeName;
                    
                    newProjection.projectionType = newProjectionType;
                } else {
                    ProjectionType *newProjectionType = [[[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"ProjectionType" objectId:projectionProjectionTypeId andContext:[[CoreDataInfo sharedCoreDataInfo] context]] objectAtIndex:0];
                    
                    newProjection.projectionType = newProjectionType;
                }
                
                NSArray *hallArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Hall" objectId:projectionHallId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( hallArray ) {
                    newProjection.hall = hallArray[0];
                }
                
                NSArray *movieArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Movie" objectId:projectionMovieId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( [movieArray count] > 0 ) {
                    newProjection.movie = movieArray[0];
                }
                
                NSArray *projectionTypeArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"ProjectionType" objectId:projectionProjectionTypeId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( projectionTypeArray ) {
                    newProjection.projectionType = projectionTypeArray[0];
                }
            }
        }
        
        [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
    } else if ( [type isEqualToString:@"Ticket"] ) {
        for (id key in responseDictionary) {
            NSDictionary *ticketsDictionary = responseDictionary[key];
            
            for (id ticketDictionary in ticketsDictionary) {
                NSString *ticketObjectId = [ticketDictionary objectForKey:@"objectId"];
                
                if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Ticket" andValue:ticketObjectId forKey:@"parseId"] ) {
                    continue;
                }
                
                Ticket *newTicket = [NSEntityDescription insertNewObjectForEntityForName:@"Ticket" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                newTicket.parseId = ticketObjectId;
                
                //
                NSString *createdAtIso = [ticketDictionary objectForKey:@"createdAt"];
//                NSString *createdAtIso = [createdAtDictionary objectForKey:@"iso"];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSDate *capturedStartDate = [dateFormatter dateFromString:createdAtIso];
                newTicket.createdAt = capturedStartDate;
                
//                NSDictionary *seatDictionary = [ticketDictionary objectForKey:@"seat"];
//                NSString *seatId = [seatDictionary objectForKey:@"objectId"];
                
                NSString *seatId = [ticketDictionary objectForKey:@"seatId"];
                
                if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"Seat" andValue:seatId forKey:@"parseId"] ) {
                    NSDictionary *seatDict = [self getObjectWithType:@"Seat" andObjectId:seatId];
                    
                    NSNumber *seatBusy = [seatDict objectForKey:@"busy"];
                    NSNumber *seatColumn = [seatDict objectForKey:@"column"];
                    NSNumber *seatRow = [seatDict objectForKey:@"row"];
                    
//                    NSDictionary *seatProjectionDictionary = [seatDict objectForKey:@"projection"];
//                    NSString *seatProjectionId = [seatProjectionDictionary objectForKey:@"objectId"];
                    
                    NSString *seatProjectionId = [seatDict objectForKey:@"projectionId"];
                    
                    Seat *newSeat = [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    newSeat.parseId = seatId;
                    newSeat.busy = seatBusy;
                    newSeat.column = seatColumn;
                    newSeat.row = seatRow;
                    
                    NSArray *seatProjectionArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Projection" objectId:seatProjectionId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    if ( [seatProjectionArray count] > 0 ) {
                        newSeat.projection = seatProjectionArray[0];
                    }
                }
                
                NSDictionary *ticketTypeDictionary = [ticketDictionary objectForKey:@"ticketType"];
                NSString *ticketTypeId = [ticketTypeDictionary objectForKey:@"objectId"];
                
                if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"TicketType" andValue:ticketTypeId forKey:@"parseId"] ) {
                    NSDictionary *ticketTypeDict = [self getObjectWithType:@"TicketType" andObjectId:ticketTypeId];
                    NSString *ticketTypeName = [ticketTypeDict objectForKey:@"name"];
                    
                    TicketType *newTicketType = [NSEntityDescription insertNewObjectForEntityForName:@"TicketType" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    newTicketType.parseId = ticketTypeId;
                    newTicketType.name = ticketTypeName;
                }
                
//                NSDictionary *userDictionary = [ticketDictionary objectForKey:@"userId"];
//                NSString *userId = [userDictionary objectForKey:@"objectId"];
                
                NSString *userId = [ticketDictionary objectForKey:@"user"];
                
                if ( ![[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"User" andValue:userId forKey:@"parseId"] ) {
                    NSDictionary *userDict = [self getObjectWithType:@"User" andObjectId:userId];
                    
                    NSString *userUsername = [userDict objectForKey:@"username"];
                    NSString *userPassword = [userDict objectForKey:@"password"];
                    NSString *userEmail = [userDict objectForKey:@"email"];
                    NSString *name = [userDict objectForKey:@"name"];
                    
                    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                    
                    newUser.parseId = userId;
                    newUser.username = userUsername;
                    newUser.password = userPassword;
                    newUser.email = userEmail;
                    newUser.name = name;
                }
                
                NSArray *seatArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"Seat" objectId:seatId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( seatArray ) {
                    newTicket.seat = seatArray[0];
                }
                
                NSArray *ticketTypeArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"TicketType" objectId:ticketTypeId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( [ticketTypeArray count] > 0 ) {
                    newTicket.ticketType = ticketTypeArray[0];
                }
                
                NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"User" objectId:userId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
                
                if ( [userArray count] > 0 ) {
                    newTicket.user = userArray[0];
                }
            }
        }
        
        [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
    }
}

@end

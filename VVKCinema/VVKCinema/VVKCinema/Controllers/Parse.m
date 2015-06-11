//
//  Parse.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "Parse.h"

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

- (void)getAllObjectsWithType:(NSString *)type {
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] init];
    
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:X_Parse_Application_Id forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:X_Parse_REST_API_Key forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSString *urlStringFull = [NSString stringWithFormat:@"https://api.parse.com/1/classes/%@", type];
    
    NSString *encodeURLSTring = [urlStringFull stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [NSURL URLWithString:encodeURLSTring];
    
    [parseRequest setURL:requestURL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if ( data ) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ( [type isEqualToString:@"Movie"] ) {
                for (id key in responseDictionary) {
                    NSDictionary *moviesDictionary = responseDictionary[key];
                    
                    for (id movieDictionary in moviesDictionary) {
                        NSString *objectId = [movieDictionary objectForKey:@"objectId"];
                        NSLog(@"%@", objectId);
                        
                        NSString *duration = [movieDictionary objectForKey:@"duration"];
                        NSLog(@"%@", duration);
                        
                        NSString *name = [movieDictionary objectForKey:@"name"];
                        NSLog(@"%@", name);
                        
                        NSDictionary *posterDictionary = [movieDictionary objectForKey:@"poster"];
                        NSString *posterUrl = [posterDictionary objectForKey:@"url"];
                        NSLog(@"%@", posterUrl);
                        
                        NSNumber *rate = [movieDictionary objectForKey:@"rate"];
                        NSLog(@"%@", rate);
                        
                        NSDictionary *releaseDateDictionary = [movieDictionary objectForKey:@"releaseDate"];
                        NSString *releaseDateIso = [releaseDateDictionary objectForKey:@"iso"];
                        NSLog(@"%@", releaseDateIso);
                        
                        NSNumber *subtitled = [movieDictionary objectForKey:@"subtitled"];
                        NSLog(@"%@", subtitled);
                        
                        NSDictionary *countryDictionary = [movieDictionary objectForKey:@"country"];
                        NSString *countryId = [countryDictionary objectForKey:@"objectId"];
                        NSLog(@"%@", countryId);
                        
                        NSDictionary *countryDict = [self getObjectWithType:@"Country" andObjectId:countryId];
                        NSString *countryName = [countryDict objectForKey:@"name"];
                        NSLog(@"%@", countryName);
                    
                        NSDictionary *directorDictionary = [movieDictionary objectForKey:@"director"];
                        NSString *directorId = [directorDictionary objectForKey:@"objectId"];
                        NSLog(@"%@", directorId);
                        
                        NSDictionary *directorDict = [self getObjectWithType:@"Director" andObjectId:directorId];
                        NSString *directorFirstName = [directorDict objectForKey:@"firstName"];
                        NSString *directorLastName = [directorDict objectForKey:@"lastName"];
                        NSString *directorName = [NSString stringWithFormat:@"%@ %@", directorFirstName, directorLastName];
                        NSLog(@"%@", directorName);
                        
                        NSDictionary *languageDictionary = [movieDictionary objectForKey:@"language"];
                        NSString *languageId = [languageDictionary objectForKey:@"objectId"];
                        NSLog(@"%@", languageId);
                        
                        NSDictionary *languageDict = [self getObjectWithType:@"Language" andObjectId:languageId];
                        NSString *languageName = [languageDict objectForKey:@"name"];
                        NSLog(@"%@", languageName);
                        
                        NSDictionary *actorsResultsDictionary = [self getAllObjectsWithType:@"Actor" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"actors"];
                        for (id actorsResultsDictionaryKey in actorsResultsDictionary) {
                            NSDictionary *actorsDictionary = actorsResultsDictionary[actorsResultsDictionaryKey];
                            
                            for (id actorDictionary in actorsDictionary) {
                                NSString *actorObjectId = [actorDictionary objectForKey:@"objectId"];
                                NSLog(@"%@", actorObjectId);
                                
                                NSString *actorFirstName = [actorDictionary objectForKey:@"firstName"];
                                NSString *actorLastName = [actorDictionary objectForKey:@"lastName"];
                                NSString *actorName = [NSString stringWithFormat:@"%@ %@", actorFirstName, actorLastName];
                                NSLog(@"%@", actorName);
                            }
                        }
                        
                        NSDictionary *genresResultsDictionary = [self getAllObjectsWithType:@"Genre" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"genres"];
                        for (id genresResultsDictionaryKey in genresResultsDictionary) {
                            NSDictionary *genresDictionary = genresResultsDictionary[genresResultsDictionaryKey];
                            
                            for (id genreDictionary in genresDictionary) {
                                NSString *genreObjectId = [genreDictionary objectForKey:@"objectId"];
                                NSLog(@"%@", genreObjectId);
                                
                                NSString *genreName = [genreDictionary objectForKey:@"name"];
                                NSLog(@"%@", genreName);
                            }
                        }
                        
                        NSDictionary *hallsResultsDictionary = [self getAllObjectsWithType:@"Hall" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"halls"];
                        for (id hallsResultsDictionaryKey in hallsResultsDictionary) {
                            NSDictionary *hallsDictionary = hallsResultsDictionary[hallsResultsDictionaryKey];
                            
                            for (id hallDictionary in hallsDictionary) {
                                NSString *hallObjectId = [hallDictionary objectForKey:@"objectId"];
                                NSLog(@"%@", hallObjectId);
                                
                                NSString *hallName = [hallDictionary objectForKey:@"name"];
                                NSLog(@"%@", hallName);
                            }
                        }
                        
                        NSDictionary *projectionsResultsDictionary = [self getAllObjectsWithType:@"Projection" relatedToObjectWithClassName:@"Movie" objectId:objectId andKeyName:@"projections"];
                        for (id projectionsResultsDictionaryKey in projectionsResultsDictionary) {
                            NSDictionary *projectionsDictionary = projectionsResultsDictionary[projectionsResultsDictionaryKey];
                            
                            for (id projectionDictionary in projectionsDictionary) {
                                NSString *projectionObjectId = [projectionDictionary objectForKey:@"objectId"];
                                NSLog(@"%@", projectionObjectId);
                                
                                NSDictionary *projectionDateDictionary = [projectionDictionary objectForKey:@"date"];
                                NSString *projectionDateIso = [projectionDateDictionary objectForKey:@"iso"];
                                NSLog(@"%@", projectionDateIso);
                                
                                NSDictionary *projectionHallDictionary = [projectionDictionary objectForKey:@"hall"];
                                NSString *projectionHallId = [projectionHallDictionary objectForKey:@"objectId"];
                                NSLog(@"%@", projectionHallId);
                                
//                                NSDictionary *projectionHallDict = [self getObjectWithType:@"Hall" andObjectId:projectionHallId];
//                                NSString *projectionHallName = [projectionHallDict objectForKey:@"name"];
//                                NSLog(@"%@", projectionHallName);
                                
                                NSDictionary *projectionMovieDictionary = [projectionDictionary objectForKey:@"movie"];
                                NSString *projectionMovieId = [projectionMovieDictionary objectForKey:@"objectId"];
                                NSLog(@"%@", projectionMovieId);
                                
                                NSDictionary *projectionProjectionTypeDictionary = [projectionDictionary objectForKey:@"projectionType"];
                                NSString *projectionProjectionTypeId = [projectionProjectionTypeDictionary objectForKey:@"objectId"];
                                NSLog(@"%@", projectionProjectionTypeId);
                            }
                        }
                    }
                }
            }
        }
    }];
    
    [task resume];
}

@end

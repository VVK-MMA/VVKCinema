//
//  MapViewController.h
//  VVKCinema
//
//  Created by AdrenalineHvata on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h> 
@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)handleRoutePressed:(id)sender;
@end

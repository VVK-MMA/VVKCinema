//
//  MapViewController.m
//  VVKCinema
//
//  Created by AdrenalineHvata on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>


@interface MapViewController () <MKMapViewDelegate> {
    
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
}
@end

@implementation MapViewController{
    NSMutableArray *animationCameras;
}

@synthesize locationManager = _locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Ask for Authorization
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    // Do any additional setup after loading the view, typically from a nib.
   
    self.mapView.delegate = self;
    self.mapView.camera.centerCoordinate = CLLocationCoordinate2DMake(42.654783,23.370199);
    self.mapView.camera.altitude = 1000;
    self.mapView.camera.pitch = 30;
    
    self.mapView.pitchEnabled = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.zoomEnabled = YES;
    self.navigationItem.title = @"RouteToVVKCinema";
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)handleRoutePressed:(id)sender {
 

    // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    // Start at our current location
    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake( 42.654783,23.370199);
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    [directionsRequest setDestination:source];
    //Uncomment to use the current location
    // MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    [directionsRequest setSource:source];
    // Make the destination
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(42.688226, 23.318539);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                // Now handle the result
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }else{
           
            [self goToCoordinate:destinationCoords];        }
        
        // So there wasn't an error - let's plot those routes
         _currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
    }];
}



#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
    
}


#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}
#pragma mark - Helper Methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (animated) {
        [self goToNextCamera];
    }
}

- (void)performLongCameraAnimation:(MKMapCamera *)end
{
    MKMapCamera *start = self.mapView.camera;
    CLLocation *startLocation = [[CLLocation alloc] initWithCoordinate:start.centerCoordinate altitude:start.altitude horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];
    CLLocation *endLocation = [[CLLocation alloc] initWithCoordinate:end.centerCoordinate altitude:end.altitude horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];
    CLLocationDistance distance = [startLocation distanceFromLocation:endLocation];
    CLLocationDistance midAltitute = distance;
    
    MKMapCamera *midCamera1 = [MKMapCamera cameraLookingAtCenterCoordinate:start.centerCoordinate fromEyeCoordinate:start.centerCoordinate eyeAltitude:midAltitute];
    
    MKMapCamera *midCamera2 = [MKMapCamera cameraLookingAtCenterCoordinate:end.centerCoordinate fromEyeCoordinate:end.centerCoordinate eyeAltitude:midAltitute];
    
    animationCameras = [[NSMutableArray alloc] init];
    [animationCameras addObject:midCamera1];
    [animationCameras addObject:midCamera2];
    [animationCameras addObject:end];
    [self goToNextCamera];
    
}

- (void)performShortCameraAnimaton:(MKMapCamera *)end
{
    CLLocationCoordinate2D startingCoordinate = self.mapView.centerCoordinate;
    MKMapPoint startingPoint = MKMapPointForCoordinate(startingCoordinate);
    MKMapPoint endingPoint = MKMapPointForCoordinate(end.centerCoordinate);
    
    MKMapPoint midPoint = MKMapPointMake(startingPoint.x + ((endingPoint.x - startingPoint.x) / 2.0), startingPoint.y + ((endingPoint.y - startingPoint.y) / 2.0));
    
    CLLocationCoordinate2D midCoordinate = MKCoordinateForMapPoint(midPoint);
    CLLocationDistance midAltitude = end.altitude * 4;
    
    MKMapCamera *midCamera = [MKMapCamera cameraLookingAtCenterCoordinate:end.centerCoordinate fromEyeCoordinate:midCoordinate eyeAltitude:midAltitude];
    
    animationCameras = [[NSMutableArray alloc] init];
    [animationCameras addObject:midCamera];
    [animationCameras addObject:end];
    [self goToNextCamera];
}

- (void)goToNextCamera
{
    if (animationCameras.count == 0) {
        return;
    }
    
    MKMapCamera *nextCamera = [animationCameras firstObject];
    [animationCameras removeObjectAtIndex:0];
    [UIView animateWithDuration:2.0 animations:^{
        self.mapView.camera = nextCamera;
    } completion:NULL];
}

- (void)goToCoordinate:(CLLocationCoordinate2D)coord
{
    MKMapCamera *end = [MKMapCamera cameraLookingAtCenterCoordinate:coord fromEyeCoordinate:coord eyeAltitude:500];
    end.pitch = 55;
    
    MKMapCamera *start = self.mapView.camera;
    CLLocation *startLocation = [[CLLocation alloc] initWithCoordinate:start.centerCoordinate altitude:start.altitude horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];
    CLLocation *endLocation = [[CLLocation alloc] initWithCoordinate:end.centerCoordinate altitude:end.altitude horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];
    CLLocationDistance distance = [startLocation distanceFromLocation:endLocation];
    
    if (distance < 2500) {
        [self.mapView setCamera:end animated:YES];
        return;
    }
    
    if (distance < 50000) {
        [self performShortCameraAnimaton:end];
        return;
    }
    
    [self performLongCameraAnimation:end];
}
@end

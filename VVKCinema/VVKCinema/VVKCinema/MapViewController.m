//
//  MapViewController.m
//  VVKCinema
//
//  Created by AdrenalineHvata on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController() <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
#define DISTANCE 500

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
        
    self.preferredContentSize = [self.mapView sizeThatFits:self.presentingViewController.view.bounds.size];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseID = @"MapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        view.canShowCallout = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        view.leftCalloutAccessoryView = imageView;
    }
    
    view.annotation = annotation;
    
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [self updateLeftCalloutAccessoryViewInAnnotationView:view];
}


- (void)updateLeftCalloutAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView{
    
    UIImageView *imageView = nil;
    if ([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    }
    if (imageView) {
        imageView.image = [UIImage imageNamed:@"genre"];
    }
}


- (void)updateMapViewAnnotations
{
    CLLocationCoordinate2D coords;
    //Select longitude and latitude ,
    coords.longitude = 23.376345;
    coords.latitude = 42.646095;
   
   
    MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(coords, DISTANCE, DISTANCE)];
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    //setting up the pointer
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.coordinate = coords;
    
    point.title = @"VVK Cinema";
    [self.mapView addAnnotation:point];
    
    [self.mapView setRegion:region animated:YES];//sets the initial zoom scale
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotations];
    
    //when popover appears the annotation pin will be automatically selected
}

@end

//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  GMapViewController.m
//  WAKEUP
//
//  Created by Mana Mehraein on 4/21/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GMapViewController.h"
#import "CSMarker.h"
#import "MapModel.h"
#import "ViewController.h"
#import "PickerModel.h"

@import GooglePlaces;
@import GoogleMaps;

@interface GMapViewController ()  <GMSMapViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
// IBOutlets
@property (weak, nonatomic) IBOutlet MKMapView *appleMapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTime;
@property (weak, nonatomic) IBOutlet UILabel *arrivalDistance;

//GoogleMap
@property (nonatomic, strong) GMSMapView *mapView;

//GooglePlaces
@property(strong,nonatomic) GMSPlacesClient *placesClient;

// MapKit
@property (strong, nonatomic) MKMapView *mapViews;
@property (strong, nonatomic) MKDirectionsResponse *directionsResponse;

//CoreLocation stuff
@property (strong, nonatomic) CLLocation *startPoint;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLGeocoder * geocoder;
@property (strong, nonatomic) CLGeocoder *geocoderDes;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLLocationCoordinate2D coordinate;
@property CLLocationCoordinate2D coordinateSource;

//model
@property (strong, nonatomic) MapModel* model;
@property(strong, nonatomic) PickerModel* modelP;

//Audio
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
//@property (readonly) SystemSoundID soundFileID;

@end


@implementation GMapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //shared model
    _model = [MapModel sharedModel];
    _modelP=[PickerModel sharedModel];
    
    
    //Ringtone
    NSString *path = [NSString stringWithFormat:@"%@/apple_ring.mp3", [[NSBundle mainBundle] resourcePath]]; NSURL *soundURL = [NSURL fileURLWithPath:path];
    NSError *error; self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error]; [self.audioPlayer prepareToPlay];
    
    
    self.mapView.delegate=self;
    self.appleMapView.delegate=self;
    self.appleMapView.showsUserLocation=YES;
    
    //setting up locationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    //setting dataSource for pickers
    
    
    self.geocoderDes = [[CLGeocoder alloc] init];
    
    //google places
    self.placesClient = [GMSPlacesClient sharedClient];
    
    //google current place
    [self.placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
            NSLog(@"Current Place address %@", place.formattedAddress);
            NSLog(@"Current Place attributions %@", place.attributions);
            NSLog(@"Current PlaceID %@", place.placeID);
        }
        
    }];
    
    //google places
    
    [self.placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        self.nameLabel.text = @"No current place";
        self.addressLabel.text = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                self.nameLabel.text = place.name;
                self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
            }
        }
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Geocoding stuffs using Google Map
- (void)mapView:(GMSMapView *)mapView
didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:coordinate
                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                         CSMarker *marker = [[CSMarker alloc] init];
                         marker.position = coordinate;
                         marker.appearAnimation = kGMSMarkerAnimationPop;
                         marker.map = nil;
                         //this will get the street address and city name
                         //street number and name
                         marker.title = response.firstResult.thoroughfare;
                         //city or locality
                         marker.snippet = response.firstResult.locality;
                         
                     }];
    
}
/*
 - (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
 if (mapView.myLocation != nil) {
 NSString *urlString = [NSString stringWithFormat:
 @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
 @"https://maps.googleapis.com/maps/api/directions/json",  //base URL
 mapView.myLocation.coordinate.latitude, //street location
 mapView.myLocation.coordinate.longitude,
 marker.position.latitude, //end location
 marker.position.longitude,
 @"AIzaSyCN8bk_X-M5BowgUN7mY9ntArEz_X6qw30"]; //API
 //Make a network request and get a JSON response back
 NSURL *directionsURL = [NSURL URLWithString:urlString];
 NSURLSessionDataTask *directionsTask = [self.markerSession dataTaskWithURL:directionsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
 NSError *error = nil;
 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
 if (!error) {
 self.steps = json[@"routes"][0][@"legs"][0][@"steps"];
 //make the direction button appear again when has data
 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
 //                    self.directionsButton.alpha = 1.0;
 GMSPath *path =
 [GMSPath pathFromEncodedPath:
 json[@"routes"][0][@"overview_polyline"][@"points"]];
 self.polyline = [GMSPolyline polylineWithPath:path];
 self.polyline.map = self.mapView;
 }];
 
 }
 }];
 }
 return nil;
 }
 
 */

//new to add pin to the blue circle
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.appleMapView setRegion:[self.appleMapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"You are here!";
    //point.subtitle = @"I'm here!!!";
    
    [self.appleMapView addAnnotation:point];
}
//change latitude longitude to address
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    //NSLog(@"oldlocation: %@", oldLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        NSString *latitudeString = [NSString stringWithFormat:@"%g\u00B0", currentLocation.coordinate.latitude];
        latitudeString = [[NSString alloc] initWithFormat:@"%g", currentLocation.coordinate.latitude];
        
        NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0", currentLocation.coordinate.longitude];
        longitudeString = [[NSString alloc] initWithFormat:@"%g", currentLocation.coordinate.longitude];
    }
    
    
    //calculating time to arrival and distance to arrival
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    // source and destination are the relevant MKMapItem's
    // source has to be current location
    
    //destination has to be address from model
    Map *dest = [self.model addressAtIndex:self.model.numberOfFavs-1];
    //recalling picker view's choices
    Picks* pickChoice = [self.modelP PickerAtIndex:self.modelP.numberOfPickerss-1];
    //changing the address to string
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@",dest.street , dest.city , dest.state , dest.zip];
    NSLog(@"what is the address " "%@", address);
    
    
    //geocodeaddressstring to get latitute and longitude
    [self.geocoderDes geocodeAddressString:address completionHandler:^(NSArray *placemarks2, NSError *error) {
        if ([placemarks2 count] > 0) {
            
            //CLPlacemark *placemark4 = [placemarks2 objectAtIndex:0];
            CLPlacemark *placemark4 = [placemarks2 lastObject];
            CLLocation *location4 = placemark4.location;
            CLLocationCoordinate2D coordination = location4.coordinate;
            NSLog(@" location latitude %f, location longitude %f",coordination.latitude, coordination.longitude);
            
            //
            //        }else {
            //            NSLog(@"%@", error.debugDescription);
            //        }
            //    }];
            
            //alloc and init it to make it a MKMapItem
            MKPlacemark *placemark3 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(coordination.latitude,coordination.longitude) addressDictionary:nil];
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark3];
            
            
            // source and destination are the relevant MKMapItem's
            //getting currentlocation's latitude and longitude to use as source
            MKPlacemark *placemark2 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude) addressDictionary:nil];
            
            MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:placemark2];
            request.source = source; // MKMapItem
            request.destination = destination;
            // Specify the transportation type
            request.transportType = MKDirectionsTransportTypeAutomobile;
            // If you're open to getting more than one route, requestsAlternateRoutes = YES; else requestsAlternateRoutes = NO;
            request.requestsAlternateRoutes = NO;
            MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
            [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                
                if (!error) {
                    self.directionsResponse = response;
                    //no alternate direction
                    MKRoute *route = self.directionsResponse.routes[0];
                    CLLocationDistance distance = route.distance; //distance in meter
                    NSLog(@"%f",distance);
                    self.arrivalDistance.text =[NSString stringWithFormat:@"Distance to arrive in meters:\"%.0f\"",distance];
                    NSTimeInterval seconds = route.expectedTravelTime; //ETA in Seconds
                    NSLog(@"%f",seconds);
                    self.arrivalTime.text=[NSString stringWithFormat:@"Minutes to arrive:\"%.0f\"", (seconds/60)];
                    //Time To Arrive
                    float TTA = [pickChoice.timer floatValue];
                    //Distance To Arrive
                    float DTA = [pickChoice.dist floatValue];
                    NSLog(@"%.0f", TTA);
                    NSLog(@"%.0f", DTA);
                    if ((seconds/60) <= TTA)
                    {
                        NSLog(@"yes");
                        //alarm sounds
                        [self audio];
                    }
                    
                    if (distance<=DTA)
                    {
                        NSLog(@"distYES");
                        //alarm sounds
                        [self audio];
                    }
                    
                    
                }
            }];
            
        }
    }];
    
    
    // Reverse Geocoding using apple
    NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                      self.placemark.subThoroughfare, self.placemark.thoroughfare,
                                      self.placemark.postalCode, self.placemark.locality,
                                      self.placemark.administrativeArea,
                                      self.placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}


// setting up error message in case couldn't get the address
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSString *errorType = nil;
    if (error.code == kCLErrorDenied)
    {errorType = @"Access Decied";}
    else
    {errorType = @"Unknown Error";}
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle: @"Alert"
                                message: @"Error getting location!"
                                
                                preferredStyle: UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   
                               }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//function to call for the ringtone
-(void) audio {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.audioPlayer play];
    
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle: @"Alarm"
                                message: @"You are getting thereeee!"
                                preferredStyle: UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Stop the Alarm"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   [self.audioPlayer stop];
                               }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

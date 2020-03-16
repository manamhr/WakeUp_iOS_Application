//
//  AppDelegate.h
//  WAKEUP
//
//  Created by Mana Mehraein on 4/20/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


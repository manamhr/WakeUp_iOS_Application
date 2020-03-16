//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  ViewController.h
//  WAKEUP
//
//  Created by Mana Mehraein on 4/20/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

#define pickerViewComponent 0
#define pickerViewComponent1 1



typedef void(^AddAddresses) (NSString* street, NSString* city, NSString* state, NSString* zip );

@interface ViewController : UIViewController < UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate,GMSMapViewDelegate > 

@property(copy, nonatomic) AddAddresses addBlock;

@property(strong, nonatomic) NSString* streetHolder;
@property(strong, nonatomic) NSString* cityHolder;
@property(strong, nonatomic) NSString* stateHolder;
@property(strong, nonatomic) NSString* zipHolder;

@property (strong, nonatomic)NSArray *time;
@property (strong, nonatomic)NSArray *timeUnit;
@property (strong, nonatomic)NSArray *distance;
@property (strong, nonatomic)NSArray *distanceUnit;
@property (weak, nonatomic) IBOutlet UIPickerView *distancePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

@end




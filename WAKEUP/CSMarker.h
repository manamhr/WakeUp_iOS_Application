//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  CSMarker.h
//  WAKEUP
//
//  Created by Mana Mehraein on 4/24/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>


//GMSMarker subclass
@interface CSMarker : GMSMarker

@property (nonatomic, copy) NSString *objectID;

@end

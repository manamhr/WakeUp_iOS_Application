//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  MapModel.h
//  WAKEUP
//
//  Created by Mana Mehraein on 4/21/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"



@interface MapModel : NSObject

@property (readonly) NSUInteger currentIndex;



+ (instancetype) sharedModel;
- (NSUInteger) numberOfFavs;
- (Map *) addressAtIndex: (NSUInteger) index;

- (void) insertTheAddress: (NSString *) street
                     city: (NSString *) city
                    state: (NSString *) state
                      zip:(NSString *) zip;
- (void) removeFav;
- (void) removeFavAtIndex: (NSUInteger) index;

- (void) save;

@end

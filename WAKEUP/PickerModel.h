//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  PickerModel.h
//  WAKEUP
//
//  Created by Mana Mehraein on 5/4/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picks.h"

@interface PickerModel : NSObject

+ (instancetype) sharedModel;
- (NSUInteger) numberOfPickerss;

- (Picks*) PickerAtIndex: (NSUInteger) index;

- (void) insertThePicker: (NSString *) timer
                    dist: (NSString *) dist;

- (void) removePicks;
- (void) removePicksAtIndex: (NSUInteger) index;
- (void) save;

@end

//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  Picks.m
//  WAKEUP
//
//  Created by Mana Mehraein on 5/4/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import "Picks.h"

@implementation Picks
- (instancetype) initThePicker:(NSString *)timer
                          dist: (NSString *) dist
{
    
    
    self = [super init];
    if (self) {
        _timer=timer;
        _dist=dist;
        
    }
    return self;
}

- (NSDictionary *) convertToDictionary {
    NSDictionary *PickerDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                self.timer, @"timerKey",
                                self.dist, @"distKey",
                                nil];
    return PickerDict;
}
@end

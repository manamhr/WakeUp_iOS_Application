//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  Map.m
//  WAKEUP
//
//  Created by Mana Mehraein on 4/21/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import "Map.h"

@implementation Map
- (instancetype) initTheAddress: (NSString *) street
                           city: (NSString *) city
                          state: (NSString *) state
                            zip: (NSString *) zip{
    
    
    self = [super init];
    if (self) {
        _street=street;
        _city=city;
        _state = state;
        _zip= zip;
        
    }
    return self;
}

- (NSDictionary *) convertToDictionary {
    NSDictionary *AddressDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.street, @"sKey",
                                 self.city, @"cKey",
                                 self.state, @"stKey",
                                 self.zip, @"zKey",
                                 nil];
    return AddressDict;
}
@end

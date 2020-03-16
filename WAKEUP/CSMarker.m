//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  CSMarker.m
//  WAKEUP
//
//  Created by Mana Mehraein on 4/24/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import "CSMarker.h"
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@implementation CSMarker

-(BOOL)isEqual:(id)object{
    
    CSMarker *otherMarker = (CSMarker *) object;
    if (self.objectID == otherMarker.objectID)
    {
        return YES;
    }
    return NO;
}
-(NSUInteger) hash {
    return [self.objectID hash];
}

@end

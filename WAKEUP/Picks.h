//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  Picks.h
//  WAKEUP
//
//  Created by Mana Mehraein on 5/4/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picks : NSObject
@property (strong, nonatomic, readonly) NSString* timer;
@property (strong, nonatomic, readonly) NSString* dist;



- (instancetype) initThePicker: (NSString *) timer
                          dist: (NSString *) dist;


- (NSDictionary *) convertToDictionary;
@end

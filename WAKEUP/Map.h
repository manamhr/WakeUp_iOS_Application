//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  Map.h
//  WAKEUP
//
//  Created by Mana Mehraein on 4/21/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Map : NSObject
@property (strong, nonatomic, readonly) NSString* street;
@property (strong, nonatomic, readonly) NSString* city;
@property (strong, nonatomic, readonly) NSString* state;
@property (strong, nonatomic, readonly) NSString* zip;


- (instancetype) initTheAddress: (NSString *) street
                           city: (NSString *) city
                          state: (NSString *) state
                            zip: (NSString *) zip;

- (NSDictionary *) convertToDictionary;
@end

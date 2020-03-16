//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  MapModel.m
//  WAKEUP
//
//  Created by Mana Mehraein on 4/21/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import "MapModel.h"
#import "Map.h"
#import "ViewController.h"

@interface MapModel()
@property (strong, nonatomic) NSMutableArray* addresses;
@property (strong, nonatomic) NSString* filepath;


@end

@implementation MapModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // find the Documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = paths[0];
        NSLog(@"docDir = %@", documentsDirectory);
        self.filepath = [documentsDirectory stringByAppendingPathComponent:@"addresses.plist"];
        NSLog(@"filepath = %@", self.filepath);
        NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile: self.filepath];
        
        self.addresses = [[NSMutableArray alloc] init];
        
        
        if (!data) { // file doesn't exit
            // alloc & init any properties
            // ivar _propertyName
            Map* a1=[[Map alloc]
                     initTheAddress: @"3650 McClintock Ave" city: @"Los Angeles" state: @"CA" zip:@"90089" ];
         
            self.addresses = [NSMutableArray arrayWithObjects: a1,nil];
            //            // hard-code some data
            
        } else {
            self.addresses= [[NSMutableArray alloc] init];
            for (NSDictionary* dict in data) {
                
                // NSDictionary object to Flashcard object
                Map* address = [[Map alloc] initTheAddress: dict[@"sKey"] city:dict[@"cKey"] state: dict[@"stKey"] zip: dict[@"zKey"]];
                [self.addresses addObject: address];
            }
        }

        _currentIndex=0;
        
    }
    return self;
}


+ (instancetype) sharedModel{
    //method body
    static MapModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (Map *) addressAtIndex: (NSUInteger) index{
    //method body
    //check if the index is inbound
    if (index<=self.numberOfFavs-1)
    {
        return self.addresses[index];
    }
    else
    {
        return nil;
    }
    
}

// Accessing number of addresses in model
- (NSUInteger) numberOfFavs{
    //method body
    return self.addresses.count;
    
}
- (void) insertTheAddress:(NSString *)street
                     city:(NSString *)city
                    state:(NSString *)state
                      zip:(NSString *)zip {
    //method body
    //create
    Map* newadd = [[Map alloc] initTheAddress: street city: city state: state zip: zip];
    
    [self.addresses addObject:newadd];
    [self save];
    
}


- (void) removeFav{
    //method body
    if ([self numberOfFavs] > 0) {
        [self.addresses removeLastObject];
    }
    [self save];
}
- (void) removeFavAtIndex: (NSUInteger) index{
    //method body
    NSUInteger num=[self numberOfFavs];
    
    if (num> 0 && index< num) {
        [self.addresses removeObjectAtIndex:index];
    }
    else {
        NSLog (@"There are no addresses or you have a bad index");
        
    }
    [self save];
}
- (void) save {
    NSMutableArray *favAdds = [[NSMutableArray alloc] init];
    for (Map* address in self.addresses) {
        NSDictionary *AddDict = [address convertToDictionary];
        [favAdds addObject:AddDict];
    }
    
    [favAdds writeToFile: self.filepath atomically:YES];
}


@end

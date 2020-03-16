//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  PickerModel.m
//  WAKEUP
//
//  Created by Mana Mehraein on 5/4/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import "PickerModel.h"
#import "Picks.h"
#import "ViewController.h"

@interface PickerModel()
@property (strong, nonatomic) NSMutableArray* pickSave;
@property (strong, nonatomic) NSString* filepathPick;
@end

@implementation PickerModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // find the Documents directory
        NSArray *pathpick = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory2 = pathpick[0];
        NSLog(@"pickDocDir = %@", documentsDirectory2);
        self.filepathPick = [documentsDirectory2 stringByAppendingPathComponent:@"pickersave.plist"];
        NSLog(@"filepath = %@", self.filepathPick);
        NSMutableArray *data2 = [NSMutableArray arrayWithContentsOfFile: self.filepathPick];
        
        self.pickSave = [[NSMutableArray alloc] init];
        
        
        if (!data2) { // file doesn't exit
            // alloc & init any properties
            // ivar _propertyName
            Picks* p1=[[Picks alloc]
                       initThePicker:@"0" dist:@"2" ];
            
            self.pickSave = [NSMutableArray arrayWithObjects: p1,nil];
            //            // hard-code some data
            
        } else {
            self.pickSave= [[NSMutableArray alloc] init];
            for (NSDictionary* dict in data2) {
                
                // NSDictionary object to picker object
                Picks* picker = [[Picks alloc] initThePicker:dict[@"timerKey"]  dist:dict[@"distKey"] ];
                [self.pickSave addObject: picker];
            }
        }
        
    }
    return self;
}

+ (instancetype) sharedModel{
    //method body
    static PickerModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (Picks *) PickerAtIndex: (NSUInteger) index{
    //method body
    //check if the index is inbound
    if (index<=self.numberOfPickerss-1)
    {
        return self.pickSave[index];
    }
    else
    {
        return nil;
    }
    
}

// Accessing number of addresses in model
- (NSUInteger) numberOfPickerss{
    //method body
    return self.pickSave.count;
    
}
- (void) insertThePicker:(NSString *)timer
                    dist:(NSString *)dist

{
    //method body
    //create
    Picks* newadd = [[Picks alloc] initThePicker: timer dist: dist];
    
    [self.pickSave addObject:newadd];
    [self save];
    
}


- (void) removePicks{
    //method body
    if ([self numberOfPickerss] > 0) {
        [self.pickSave removeLastObject];
    }
    [self save];
}
- (void) removePicksAtIndex: (NSUInteger) index{
    //method body
    NSUInteger num=[self numberOfPickerss];
    
    if (num> 0 && index< num) {
        [self.pickSave removeObjectAtIndex:index];
    }
    else {
        NSLog (@"There are no pickers or you have a bad index");
        
    }
    [self save];
}
- (void) save {
    NSMutableArray *pickAdds = [[NSMutableArray alloc] init];
    for (Picks* picksave in self.pickSave) {
        NSDictionary *AddDict = [picksave convertToDictionary];
        [pickAdds addObject:AddDict];
    }
    
    [pickAdds writeToFile: self.filepathPick atomically:YES];
}



@end

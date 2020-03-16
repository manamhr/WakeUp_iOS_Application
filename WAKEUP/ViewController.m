//
//  Mana Mehraein
//  mehraein@usc.edu
//  ViewController.m
//  WAKEUP
//
//  Created by Mana Mehraein on 4/20/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//



#import <GoogleMaps/GoogleMaps.h>
#import "ViewController.h"
#import "MapModel.h"
#import "Map.h"
#import "GMapViewController.h"
#import "FavTableViewController.h"
#import "PickerModel.h"
#import "Picks.h"


@interface ViewController () <UITextFieldDelegate>

//model
@property (strong, nonatomic) MapModel* model;
@property (strong, nonatomic)PickerModel* modelP;

//outlets
@property (weak, nonatomic) IBOutlet UILabel *tf1;
@property (weak, nonatomic) IBOutlet UITextField *streetTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *stateTF;
@property (weak, nonatomic) IBOutlet UITextField *zipTF;
@property (weak, nonatomic) IBOutlet UILabel *distanceTF;
@property (weak, nonatomic) IBOutlet UILabel *timeTF;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;


@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model = [MapModel sharedModel];
    _modelP = [PickerModel sharedModel];
    
    //setting delegates
    self.streetTF.delegate=self;
    self.cityTF.delegate=self;
    self.stateTF.delegate=self;
    self.zipTF.delegate=self;
    self.timePicker.delegate=self;
    self.distancePicker.delegate=self;
    self.timePicker.dataSource=self;
    self.distancePicker.dataSource=self;
    
    
    
    
    self.tf1.text= @"Please enter the address";
    self.distanceTF.text=@"Select desired time before arrival";
    self.timeTF.text=@"Select distance before arrival";
    
    
    // pickers
    self.time= @[@"0",@"1", @"2", @"5", @"10", @"15", @"20",@"25", @"30",@"35", @"40", @"45", @"50", @"55", @"60"];
    
    self.timeUnit = @[@"mins"];
    
    self.distance = @[@"0",@"1", @"2", @"5", @"10", @"15", @"20",@"25", @"30",@"35", @"40", @"45", @"50", @"55", @"60"];
    self.distanceUnit = @[@"m"];
    
}
- (IBAction)keyboardTouched:(id)sender {
    [self.stateTF resignFirstResponder];
}


//PickerView
- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
    
    return 2;
}


- (NSInteger) pickerView: (UIPickerView *) pickerView numberOfRowsInComponent: (NSInteger) component {
    if (pickerView == self.timePicker) {
        if (component == pickerViewComponent) {
            return [self.time count];}
        else {
            
            return [self.timeUnit count];
        }
    } else {
        if (component == pickerViewComponent) {
            
            return [self.distance count];
        }
        
        else {
            
            return [self.distanceUnit count];
        }
        
    }
}


- (NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (NSInteger) row
             forComponent: (NSInteger) component {
    if (pickerView == self.timePicker) {
        
        if (component == pickerViewComponent){
            
            return self.time[row];
        }
        
        else {
            return self.timeUnit[row];
        }
    } else {
        if (component == pickerViewComponent){
            
            return self.distance[row];
        }
        else {
            return self.distanceUnit[row];
        }
        
    }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    NSInteger timeRow = [self.timePicker selectedRowInComponent:
                         pickerViewComponent];
    
    NSInteger timeUnitRow = [self.timePicker selectedRowInComponent:
                             pickerViewComponent1 ];
    NSInteger distanceRow = [self.distancePicker selectedRowInComponent:
                             pickerViewComponent];
    
    NSInteger distanceUnitRow = [self.distancePicker selectedRowInComponent:
                                 pickerViewComponent1];
    
    NSString *time = self.time[timeRow];
    NSLog(@"time %@", time);
    NSString *timeUnit = self.timeUnit[timeUnitRow];
    NSLog(@"time unit %@", timeUnit);
    NSString *distance = self.distance[distanceRow];
    NSLog(@"distance %@", distance);
    NSString *distanceUnit = self.distanceUnit[distanceUnitRow];
    NSLog(@"distance unit %@", distanceUnit);
    //NSString *distanceUnit=[self.distanceUnit objectAtIndex:row];
    
}

//managing textfields
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual: self.streetTF]) {
        [self.cityTF becomeFirstResponder];
    } else if ([textField isEqual: self.cityTF]) {
        [self.stateTF becomeFirstResponder];
    } else if ([textField isEqual: self.stateTF]) {
        [self.zipTF becomeFirstResponder];
    } else {
        [self.zipTF resignFirstResponder];
    }
    
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event{
    [self.zipTF resignFirstResponder];
}
//managing prcticality of textfields
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *changedString = [textField.text
                               stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual: self.streetTF]) {
        [self enableSaveButton: changedString
                          city: self.cityTF.text
                         state: self.stateTF.text
                           zip: self.zipTF.text];
    } else if ([textField isEqual: self.cityTF]) {
        [self enableSaveButton: self.streetTF.text
                          city: changedString
                         state: self.stateTF.text
                           zip: self.zipTF.text];
    } else if ([textField isEqual: self.stateTF]) {
        [self enableSaveButton: self.streetTF.text
                          city: self.cityTF.text
                         state: changedString
                           zip: self.zipTF.text];
    } else {
        [self enableSaveButton: self.stateTF.text
                          city: self.cityTF.text
                         state: self.stateTF.text
                           zip: changedString];
    }
    
    return YES;
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    [self enableSaveButton: self.streetTF.text
                      city: self.cityTF.text
                     state: self.stateTF.text
                       zip: self.zipTF.text
     ];
    
    return YES;
}
- (void)enableSaveButton: (NSString *) street
                    city: (NSString *) city
                   state: (NSString *) state
                     zip: (NSString *) zip{
    
    
}

//hitting set button

- (IBAction)searchButtonTouched:(id)sender {
    
    
    if(self.streetTF.text.length >0 && self.cityTF.text.length>0 && self.stateTF.text.length>0 && self.zipTF.text.length>0)
    {
        
        //saves address
        [self.model insertTheAddress:self.streetTF.text city: self.cityTF.text state:self.stateTF.text zip:self.zipTF.text];
        
        //pickers
        NSInteger timeRow = [self.timePicker selectedRowInComponent:
                             pickerViewComponent];
        
        NSInteger timeUnitRow = [self.timePicker selectedRowInComponent:
                                 pickerViewComponent1 ];
        NSInteger distanceRow = [self.distancePicker selectedRowInComponent:
                                 pickerViewComponent];
        
        NSInteger distanceUnitRow = [self.distancePicker selectedRowInComponent:
                                     pickerViewComponent1];
        
        NSString *time = self.time[timeRow];
        NSLog(@"final time %@", time);
        NSString *timeUnit = self.timeUnit[timeUnitRow];
        NSLog(@"final time unit %@", timeUnit);
        NSString *distance = self.distance[distanceRow];
        NSLog(@"final distance %@", distance);
        NSString *distanceUnit = self.distanceUnit[distanceUnitRow];
        NSLog(@"final distance unit %@", distanceUnit);
        [self.modelP insertThePicker:self.time[timeRow] dist:self.distance[distanceRow]];
        [self reset];
        
        //show alert
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle: @"Got it!"
                                    message: @"You are all set! Click on the map to track your location and arrival time. We will wake u up before u get there!"
                                    preferredStyle: UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else //alert to make sure they enter the address
    {
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle: @"Hmmm"
                                    message: @"Please add an address first!!"
                                    preferredStyle: UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       
                                   }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


//reset settings
-(void) reset {
    self.streetTF.text=@"";
    self.cityTF.text=@"";
    self.stateTF.text=@"";
    self.zipTF.text=@"";
    [_timePicker selectRow:0 inComponent:0 animated:YES];
    [_distancePicker selectRow:0 inComponent:0 animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

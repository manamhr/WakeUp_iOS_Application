//
//
//  Mana Mehraein
//  mehraein@usc.edu
//  FavTableViewController.m
//  WAKEUP
//
//  Created by Mana Mehraein on 4/21/18.
//  Copyright © 2018 Mana Mehraein. All rights reserved.
//

#import "FavTableViewController.h"
#import "Map.h"
#import "MapModel.h"
#import "ViewController.h"

@interface FavTableViewController () 

@property(nonatomic, readonly, copy) NSString *reuseIdentifier;
//@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) MapModel* model;

@end

@implementation FavTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    //self.navItem.title=self.textTitle;
    self.model = [MapModel sharedModel];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    /* self.navigationController.navigationBarHidden = NO;
     self.navigationItem.hidesBackButton = YES;
     */
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
}
-(void) viewWillAppear:(BOOL)animated{
    // [super viewDidAppear];
    
    [ self.tableView reloadData];
    
}
/*
 - (void)viewDidDisappear {
 self.navigationItem.rightBarButtonItem = nil;
 self.navigationController.navigationBarHidden = YES;
 }
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // the counts model
    return [self.model numberOfFavs];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Map* address = [self.model addressAtIndex: indexPath.row];
    cell.textLabel.text = [address street];
    cell.detailTextLabel.text = [address street];
    
    return cell;
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [self.model removeFavAtIndex: indexPath.row];
        [tableView reloadData];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addAddressSegue"])
    {
        ViewController* avc=[segue destinationViewController];
        
        avc.streetHolder =@"Add Street";
        avc.cityHolder =@"Add City";
        avc.stateHolder =@"Add State";
        avc.zipHolder = @"Add ZipCode";
        
        
        avc.addBlock = ^(NSString* street, NSString* city, NSString* state, NSString* zip )
        
        {
            if(street !=nil && city != nil && state !=nil && zip !=nil)
            {
                // Add to model
                [self.model insertTheAddress: street city:city state:state zip:zip];
                //NSLog(@"what is happening");
                //update the table view
                [self.tableView reloadData];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            
        };
        
    }
}
/*
 
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 //   if(!self.detailView){
 //  self.detailView = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
 //}
 
 self.detailView = [ViewController alloc];
 self.detailView.row = [indexPath row];
 [self.navigationController pushViewController:self.detailView animated:YES];
 }
 */

@end

//
//  ProfileViewController.m
//  Nellodee
//
//  Created by Ada Hopper on 26/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "BasicProfileViewController.h"
#import "AboutViewController.h"
#import "BasicInfoWS.h"
#import "AboutMeWS.h"
#import "CategoriesWS.h"
//#import "MeService.h"
#import "TagsViewController.h"
#import "CategoriesViewController.h"

@implementation ProfileViewController

@synthesize options;
@synthesize basicInfoWS, aboutMeWS,categoriesWS;


#define BASIC 0
#define ABOUT 1
#define CATEGORIES 2
#define PUBLICATIONS 3

+ (NSArray *) defaultOptions{
    return [NSArray arrayWithObjects:@"Basic Information", @"About me", @"Categories", @"Publications",nil];
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    if (self != nil){
        self->options = [[[self class] defaultOptions] mutableCopy];
        assert(self->options !=nil);
    }
    // Update the view with current data before it is displayed.
    [super viewWillAppear:animated];
    
    // Scroll the table view to the top before it appears
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    self.title = @"Profile";
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There are three sections, for date, genre, and characters, in that order.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

	static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    cell.textLabel.text = [[self.options objectAtIndex:indexPath.row] description];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //MeService *me =[[MeService alloc] init];
    //[me meService];
	
    if([indexPath row] == BASIC){
		basicInfoWS = [[BasicInfoWS alloc] init];
		[basicInfoWS meService];
		
        BasicProfileViewController *profileView = [[BasicProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        // Push the detail view controller.
        [[self navigationController] pushViewController:profileView animated:YES];
        [profileView release];
        

        
    }
    else if ([indexPath row] == ABOUT   ){
		aboutMeWS = [[AboutMeWS alloc] init];
		[aboutMeWS meService];
		
        AboutViewController *aboutView = [[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[[self navigationController] pushViewController:aboutView animated:YES];
        [aboutView release];

        
    }
    else if ([indexPath row] == CATEGORIES   ){
		categoriesWS = [[CategoriesWS alloc] init];
		[categoriesWS meService];
		CategoriesViewController *categoriesView =[[CategoriesViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        // Push the detail view controller.
        [[self navigationController] pushViewController:categoriesView animated:YES];
        [categoriesView release];
        
    }
    else{
        
        /*
         When a row is selected, create the detail view controller and set its detail item to the item associated with the selected row.
         */
        //TagsViewController *profileViewController = [[TagsViewController alloc] init];
        
        // Push the detail view controller.
        //[[self navigationController] pushViewController:profileViewController animated:YES];
        //[profileViewController release];
    }
    
}


-(void) dealloc{
	[categoriesWS release];
	[aboutMeWS release];
	[basicInfoWS release];
	[options release];
	[super dealloc];
}
@end

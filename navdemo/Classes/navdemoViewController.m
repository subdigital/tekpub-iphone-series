//
//  navdemoViewController.m
//  navdemo
//
//  Created by Ben Scheirman on 6/20/10.
//  Copyright flux88 software 2010. All rights reserved.
//

#import "navdemoViewController.h"
#import "SecondViewController.h"

@implementation navdemoViewController

-(IBAction)pushMeTapped {
	SecondViewController *controller = [[SecondViewController alloc] initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithTitle:@" "
											  style:UIBarButtonItemStyleBordered 
											  target:nil action:nil] autorelease];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

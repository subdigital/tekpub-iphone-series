//
//  TodoEditorController.m
//  TekpubTodo
//
//  Created by Ben Scheirman on 4/6/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "TodoEditorController.h"


@implementation TodoEditorController

@synthesize delegate, defaultText;

-(IBAction)save {
	if(delegate != nil)
		[delegate todoEditor:self didFinishWithResult:YES];
}

-(IBAction)cancel {
	if(delegate != nil)
		[delegate todoEditor:self didFinishWithResult:NO];
}

-(NSString *)text {
	return [textField text];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark tableview datasource/delegate methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Text";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @"Please enter a nice description";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
													reuseIdentifier:@""] autorelease];
	
	CGRect frame = CGRectInset(cell.contentView.bounds, 25, 10);
	textField = [[UITextField alloc] initWithFrame:frame];
	
	if(defaultText != nil)
		textField.text = defaultText;
	
	textField.delegate = self;
	
	[cell.contentView addSubview:textField];

	[textField release];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	[textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)txtField {
	[textField resignFirstResponder];
	return NO;
}

#pragma mark -
#pragma mark cleanup

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

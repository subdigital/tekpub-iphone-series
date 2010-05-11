//
//  TekpubTodoViewController.m
//  TekpubTodo
//
//  Created by Ben Scheirman on 3/1/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TekpubTodoViewController.h"
#import "Todo.h"
#import "TodoEditorController.h"
#import "TekpubTodoAppDelegate.h"

@implementation TekpubTodoViewController

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"# rows called, returning %d", [todoItems count]);
	return [todoItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	
	Todo *todo = [todoItems objectAtIndex:indexPath.row];
	cell.textLabel.text = todo.text;
	
	if(todo.completed) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
								forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		//[todoItems removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
						 withRowAnimation:UITableViewRowAnimationRight];
	}
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void) presentTodoEditor:(NSString *)text  {
	TodoEditorController *editor = [[TodoEditorController alloc] initWithNibName:@"TodoEditorController" bundle:nil];
	editor.defaultText = text;
	editor.delegate = self;
	[self presentModalViewController:editor animated:YES];
	[editor release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	Todo *todo = [todoItems objectAtIndex:indexPath.row];
	
	if(editing) {
		lastEditedTodo = todo;
		[self presentTodoEditor:todo.text];

	} else {
		
		todo.completed = !todo.completed;
		[tableView reloadData];
			
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark event handlers

-(IBAction)addButtonPushed {
	lastEditedTodo = nil;
	[self presentTodoEditor:nil];
}

-(IBAction)edit {
	editing = !editing;
	[_tableView setEditing:editing animated:YES];
}

-(void)todoEditor:(TodoEditorController *)editor didFinishWithResult:(BOOL)result {
	if(result) {
		//handle save
		NSString *text = [editor text];
		
		if (lastEditedTodo == nil) {
		
//			Todo *todo = [[Todo alloc] initWithText:text];
//			[todoItems addObject:todo];
//			[todo release];
			
		} else {
			lastEditedTodo.text = text;
		}
		
		[_tableView reloadData];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark initialization

- (void)addTodo:(NSString *)text {
	Todo *todo = [[Todo alloc] initWithText:text];
	//[todoItems addObject:todo];
	[todo release];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		db = [[TodoDatabase alloc] initWithFileName:@"todo.db"];
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	todoItems = [[db fetchTodos] retain];
}

#pragma mark -
#pragma mark Cleanup

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
	[todoItems release];
    [super dealloc];
}

@end

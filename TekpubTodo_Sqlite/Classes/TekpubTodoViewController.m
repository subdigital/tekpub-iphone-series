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
#import "FMDBTodoDatabase.h"

@implementation TekpubTodoViewController

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
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
		Todo *todo = [todoItems objectAtIndex:indexPath.row];
		[db deleteTodo:todo];
		[self loadTodos];
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
		[db updateTodo:todo];
		
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
		
			Todo *todo = [[Todo alloc] initWithText:text];
			[db insertTodo:todo];
			[todo release];
			
			[self reload];
			
		} else {
			
			lastEditedTodo.text = text;
			[db updateTodo:lastEditedTodo];
			
		}
		
		[_tableView reloadData];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		db = [[FMDBTodoDatabase alloc] initWithFileName:@"todo.db"];
	}
	
	return self;
}

- (void)loadTodos {
	if (todoItems != nil) {
		[todoItems release];
	}
	
	todoItems = [[db fetchTodos] retain];
}

- (void)reload {
	[self loadTodos];
	[_tableView reloadData];
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

//
//  TekpubTodoViewController.h
//  TekpubTodo
//
//  Created by Ben Scheirman on 3/1/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoEditorController.h"
#import "Todo.h"
#import "TodoDatabase.h"
	
@interface TekpubTodoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TodoEditorDelegate> {
	UINavigationBar *navBar;
	NSArray *todoItems;
	IBOutlet UITableView* _tableView;
	BOOL editing;
	Todo *lastEditedTodo;
	TodoDatabase *db;
}

-(IBAction)edit;
-(IBAction)addButtonPushed;
-(void)loadTodos;
-(void)reload;

@end


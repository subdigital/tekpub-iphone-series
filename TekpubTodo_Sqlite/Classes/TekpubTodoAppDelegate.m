//
//  TekpubTodoAppDelegate.m
//  TekpubTodo
//
//  Created by Ben Scheirman on 3/1/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TekpubTodoAppDelegate.h"
#import "TekpubTodoViewController.h"
#import "TodoDatabase.h"

@implementation TekpubTodoAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {        
	NSLog(@"AppDelegate: MakeWritableCopy");
	[TodoDatabase makeWritableCopy:@"todo.db"];

   // Override point for customization after app launch    
   [window addSubview:viewController.view];
   [window makeKeyAndVisible];	
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

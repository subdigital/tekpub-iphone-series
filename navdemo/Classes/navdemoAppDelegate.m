//
//  navdemoAppDelegate.m
//  navdemo
//
//  Created by Ben Scheirman on 6/20/10.
//  Copyright flux88 software 2010. All rights reserved.
//

#import "navdemoAppDelegate.h"
#import "navdemoViewController.h"

@implementation navdemoAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

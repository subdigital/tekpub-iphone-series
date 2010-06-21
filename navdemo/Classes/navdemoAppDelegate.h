//
//  navdemoAppDelegate.h
//  navdemo
//
//  Created by Ben Scheirman on 6/20/10.
//  Copyright flux88 software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class navdemoViewController;

@interface navdemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;

@end


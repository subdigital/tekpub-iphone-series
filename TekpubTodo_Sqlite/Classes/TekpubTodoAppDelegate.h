//
//  TekpubTodoAppDelegate.h
//  TekpubTodo
//
//  Created by Ben Scheirman on 3/1/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TekpubTodoViewController;

@interface TekpubTodoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TekpubTodoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TekpubTodoViewController *viewController;

@end


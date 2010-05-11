//
//  TodoEditorController.h
//  TekpubTodo
//
//  Created by Ben Scheirman on 4/6/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TodoEditorDelegate;

@interface TodoEditorController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	id<TodoEditorDelegate> delegate;
	UITextField *textField;
	NSString *defaultText;
}

@property (nonatomic, assign) id<TodoEditorDelegate> delegate; 
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, copy) NSString *defaultText;

-(IBAction)save;
-(IBAction)cancel;

@end

@protocol TodoEditorDelegate

-(void)todoEditor:(TodoEditorController *)editor didFinishWithResult:(BOOL)result;

@end



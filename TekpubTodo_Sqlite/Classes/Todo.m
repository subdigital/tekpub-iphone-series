//
//  Todo.m
//  TekpubTodo
//
//  Created by Ben Scheirman on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Todo.h"

@implementation Todo

@synthesize todoId, text, completed, dateAdded;

-(id)init {
	if(self = [super init]) {
		//set the date to today
		dateAdded = [NSDate date];
	}
	
	return self;
}

-(id)initWithText:(NSString *)txt {
	if([self init]) {
		self.text = txt;
	}
	
	return self;
}

@end

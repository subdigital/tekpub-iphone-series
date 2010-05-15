//
//  TodoDatabase.h
//  TekpubTodo
//
//  Created by Ben Scheirman on 5/10/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Todo.h"

@interface TodoDatabase : NSObject {
	NSString *pathToDb;
}

@property (nonatomic, readonly) NSString *pathToDb;

-(id)initWithFileName:(NSString *)filename;

-(NSArray *)fetchTodos;
-(void)insertTodo:(Todo *)todo;
-(void)updateTodo:(Todo *)todo;
-(void)deleteTodo:(Todo *)todo;

+(void)makeWritableCopy:(NSString *)filename;

@end

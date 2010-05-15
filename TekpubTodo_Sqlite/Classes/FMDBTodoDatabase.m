//
//  FMDBTodoDatabase.m
//  TekpubTodo
//
//  Created by Ben Scheirman on 5/15/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "FMDBTodoDatabase.h"


@implementation FMDBTodoDatabase

-(id)initWithFileName:(NSString *)filename {
	if(self = [super initWithFileName:filename]) {
		fmdb = [[FMDatabase alloc] initWithPath:self.pathToDb];
	}
	
	return self;
}

-(NSArray *)fetchTodos {
	[fmdb open];
	
	NSMutableArray *results = [[NSMutableArray alloc] init];
	FMResultSet *rs = [fmdb executeQuery:@"SELECT * FROM todos"];
	while ([rs next]) {
		Todo *todo = [[Todo alloc] init];
		todo.todoId = [rs intForColumn:@"id"];
		todo.text = [rs stringForColumn:@"text"];
		todo.completed = [rs boolForColumn:@"completed"];
		
		[results addObject:todo];
	}
	
	[fmdb close];
	
	return results;
}

-(void)insertTodo:(Todo *)todo {
	[fmdb open];
	[fmdb executeUpdate:@"INSERT INTO todos(text, completed) VALUES(?, ?);", todo.text, [NSNumber numberWithBool:todo.completed]];
	[fmdb close];
}

-(void)updateTodo:(Todo *)todo {
	[fmdb open];
	[fmdb executeUpdate:@"UPDATE todos SET text = ?, completed = ? WHERE id = ?;", 
		todo.text, 
		[NSNumber numberWithBool:todo.completed], 
		[NSNumber numberWithInt:todo.todoId]];
		
	[fmdb close];
	
}

-(void)deleteTodo:(Todo *)todo {
	[fmdb open];
	[fmdb executeUpdate:@"DELETE FROM todos WHERE id = ?;", [NSNumber numberWithInt:todo.todoId]];
	[fmdb close];	
}


-(void)dealloc {
	[fmdb release];
	
	[super dealloc];
}

@end

//
//  TodoDatabase.m
//  TekpubTodo
//
//  Created by Ben Scheirman on 5/10/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "TodoDatabase.h"
#import "FileHelpers.h"
#import "Todo.h"

@implementation TodoDatabase

+(void)makeWritableCopy:(NSString *)filename {
	
	BOOL overwiteDatabase = YES;
	NSString *destinationPath = [DocumentsDirectory() stringByAppendingPathComponent:filename];

	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *filePart = [filename stringByDeletingPathExtension];
	NSString *extension = [filename pathExtension];
	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:filePart ofType:extension];
	
	if([fileManager fileExistsAtPath:destinationPath]) {
		if (overwiteDatabase) {
			[fileManager removeItemAtPath:destinationPath error:nil];
		} else {
			return;
		}
	}	
	
	NSError *error = nil;
	BOOL copied = [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&error];
	if (copied) {
		NSLog(@"Writable version of %@ saved to documents directory.", filename);
	} else {
		NSLog(@"An error occurred while copying! %@", [error localizedDescription]);
	}
}

-(id)initWithFileName:(NSString *)filename {
	if(self = [super init]) {
		pathToDb = [[DocumentsDirectory() stringByAppendingPathComponent:filename] copy];
	}
	
	return self;
}

-(NSArray *)fetchTodos {
	sqlite3 *db;
	int status = sqlite3_open([pathToDb cStringUsingEncoding:NSUTF8StringEncoding], &db);
	
	if(status != SQLITE_OK) {
		NSLog(@"ERROR:  Opening sqlite database ==> %s", sqlite3_errmsg(db));
		sqlite3_close(db);
		exit(1);
	}
	
	const char * sql = "SELECT id, text, completed FROM todos ORDER BY id";	
	sqlite3_stmt *statement;
	sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
	
	NSMutableArray *todos = [[NSMutableArray alloc] init];
	
	NSLog(@"Executing query: %s", sql);
	status = sqlite3_step(statement);
	while (status == SQLITE_ROW) {
		//process row
		NSLog(@"Processing row!");
		
		Todo *todo = [[Todo alloc] init];
		todo.todoId = sqlite3_column_int(statement, 0);
		const char * s = (const char *)sqlite3_column_text(statement, 1);
		todo.text = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
		todo.completed = sqlite3_column_int(statement, 2);
		
		[todos addObject:todo];
		
		status = sqlite3_step(statement);
	}
	
	NSLog(@"Status code: %d", status);
	
	if (status != SQLITE_DONE) {
		NSLog(@"Error executing statement: %s.  The error was: %s", sql, sqlite3_errmsg(db));
		exit(1);
	}
	
	return todos;
}

@end

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

@synthesize pathToDb;

+(void)makeWritableCopy:(NSString *)filename {
	
	BOOL overwiteDatabase = NO;
	NSString *destinationPath = [DocumentsDirectory() stringByAppendingPathComponent:filename];

	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *filePart = [filename stringByDeletingPathExtension];
	NSString *extension = [filename pathExtension];
	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:filePart ofType:extension];
	
	if([fileManager fileExistsAtPath:destinationPath]) {
		if (overwiteDatabase) {
			NSLog(@"Removing existing database...");
			[fileManager removeItemAtPath:destinationPath error:nil];
		} else {
			NSLog(@"Skipping migrate, database already exists.");
			return;
		}
	}	
	
	NSError *error = nil;
	NSLog(@"Copying database from %@ to %@", sourcePath, destinationPath);
	BOOL copied = [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&error];
	if (copied) {
		NSLog(@"Writable version of %@ saved to documents directory.", filename);
	} else {
		NSLog(@"An error occurred while copying! %@", [error localizedDescription]);
	}
}

-(sqlite3_stmt *)prepareStatement:(NSString *)sql forDb:(sqlite3 *)db {
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
		NSLog(@"ERROR Preparing statement %@", sql);
		exit(1);
	}
	
	return stmt;
}

-(id)initWithFileName:(NSString *)filename {
	if(self = [super init]) {
		pathToDb = [[DocumentsDirectory() stringByAppendingPathComponent:filename] copy];
	}
	
	return self;
}

-(sqlite3 *)openDatabase {
	sqlite3 *db;
	int status = sqlite3_open([pathToDb cStringUsingEncoding:NSUTF8StringEncoding], &db);
	
	if(status != SQLITE_OK) {
		NSLog(@"ERROR:  Opening sqlite database ==> %s", sqlite3_errmsg(db));
		sqlite3_close(db);
		exit(1);
	}
	
	return db;
}

-(NSInteger)lastInsertId:(sqlite3*)db {
	sqlite3_stmt *stmt = [self prepareStatement:@"SELECT last_insert_rowid()" forDb:db];
	
	if(sqlite3_step(stmt) != SQLITE_ROW) {
		NSLog(@"ERROR Getting last insert rowid...");
		exit(1);
	}
	
	NSInteger rowid = sqlite3_column_int(stmt, 0);
	sqlite3_finalize(stmt);
	
	return rowid;
}

-(void)insertTodo:(Todo *)todo {
	sqlite3 *db = [self openDatabase];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(db, "INSERT INTO todos(text, completed) VALUES(?, ?);", -1, &stmt, NULL) != SQLITE_OK) {
		NSLog(@"Error preparing insert statement");
		exit(1);
	}
	
	sqlite3_bind_text(stmt, 1, [todo.text UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(stmt, 2, todo.completed);
	
	if(sqlite3_step(stmt) != SQLITE_DONE) {
		NSLog(@"ERROR EXECUTING INSERT");
		exit(1);
	}
	
	sqlite3_finalize(stmt);
	
	todo.todoId = [self lastInsertId:db];
	
	sqlite3_close(db);
}

-(void)updateTodo:(Todo *)todo {
	sqlite3 *db = [self openDatabase];

	const char * sql = "UPDATE todos SET text=?, completed=? WHERE id=?";
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
		NSLog(@"ERROR PREPARING STATEMENT");
	}
	
	sqlite3_bind_text(statement, 1, [todo.text UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(statement, 2, todo.completed);
	sqlite3_bind_int(statement, 3, todo.todoId);
	
	NSLog(@"Executing: %s", sql);
	NSInteger status = sqlite3_step(statement);
	
	NSLog(@"Status code: %d", status);
	sqlite3_finalize(statement);
	
	if (status != SQLITE_DONE) {
		NSLog(@"Error executing statement: %s.  The error was: %s", sql, sqlite3_errmsg(db));
		exit(1);
	}
	
	sqlite3_close(db);
}

-(void)deleteTodo:(Todo *)todo {
	sqlite3 *db = [self openDatabase];
	
	NSString  *sql = @"DELETE FROM todos WHERE id=?";
	sqlite3_stmt *stmt = [self prepareStatement:sql forDb:db];
	
	NSLog(@"Executing %@", sql);
	sqlite3_bind_int(stmt, 1, todo.todoId);
	NSLog(@"Binding id to %d", todo.todoId);
	
	if(sqlite3_step(stmt) != SQLITE_DONE) {
		NSLog(@"Error deleting todo");
		exit(1);
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
}

-(NSArray *)fetchTodos {
	sqlite3 *db = [self openDatabase];
	
	const char * sql = "SELECT id, text, completed FROM todos ORDER BY id";	
	sqlite3_stmt *statement;
	sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
	
	NSMutableArray *todos = [[NSMutableArray alloc] init];
	
	NSLog(@"Executing query: %s", sql);
	NSInteger status = sqlite3_step(statement);
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
	sqlite3_finalize(statement);
	
	if (status != SQLITE_DONE) {
		NSLog(@"Error executing statement: %s.  The error was: %s", sql, sqlite3_errmsg(db));
		exit(1);
	}
	
	sqlite3_close(db);
	
	return todos;
}

@end

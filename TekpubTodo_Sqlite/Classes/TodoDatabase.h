//
//  TodoDatabase.h
//  TekpubTodo
//
//  Created by Ben Scheirman on 5/10/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface TodoDatabase : NSObject {
	NSString *pathToDb;
}

//NSString *DB_FILENAME = @"todo.db";

-(id)initWithFileName:(NSString *)filename;
-(NSArray *)fetchTodos;

+(void)makeWritableCopy:(NSString *)filename;

@end

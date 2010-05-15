//
//  FMDBTodoDatabase.h
//  TekpubTodo
//
//  Created by Ben Scheirman on 5/15/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoDatabase.h"
#import "FMDatabase.h"


@interface FMDBTodoDatabase : TodoDatabase {
	FMDatabase *fmdb;
}

@end

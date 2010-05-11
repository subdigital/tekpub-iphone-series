//
//  FileHelpers.m
//  TekpubTodo
//
//  Created by Ben Scheirman on 5/10/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "FileHelpers.h"

NSString* DocumentsDirectory() {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}
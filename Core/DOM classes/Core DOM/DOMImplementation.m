//
//  DOMImplementation.m
//  SVGKit
//
//  Created by adam on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOMImplementation.h"

@implementation DOMImplementation

-(BOOL) hasFeature:(NSString*) feature version:(NSString*) version
{
	NSAssert( FALSE, @"Not implemented yet" );
	return FALSE;
}

// Introduced in DOM Level 2:
-(DocumentType*) createDocumentType:(NSString*) qualifiedName publicId:(NSString*) publicId systemId:(NSString*) systemId
{
	NSAssert( FALSE, @"Not implemented yet" );
	return nil;
}


// Introduced in DOM Level 2:
-(Document*) createDocument:(NSString*) namespaceURI qualifiedName:(NSString*) qualifiedName doctype:(DocumentType*) doctype
{
	NSAssert( FALSE, @"Not implemented yet" );
	return nil;
}

@end

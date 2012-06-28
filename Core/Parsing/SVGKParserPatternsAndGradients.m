//
//  SVGKParserPatternsAndGradients.m
//  SVGKit
//
//  Created by adam applecansuckmybigtodger on 28/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SVGKParserPatternsAndGradients.h"

#import "SVGSVGElement.h"
#import "SVGCircleElement.h"
#import "SVGDefsElement.h"
#import "SVGDescriptionElement.h"
//#import "SVGKSource.h"
#import "SVGEllipseElement.h"
#import "SVGGroupElement.h"
#import "SVGImageElement.h"
#import "SVGLineElement.h"
#import "SVGPathElement.h"
#import "SVGPolygonElement.h"
#import "SVGPolylineElement.h"
#import "SVGRectElement.h"
#import "SVGTitleElement.h"

@implementation SVGKParserPatternsAndGradients

- (void)dealloc {
	
	[super dealloc];
}

-(NSArray*) supportedNamespaces
{
	return [NSArray arrayWithObjects:
			@"http://www.w3.org/2000/svg",
			nil];
}

/** "tags supported" is exactly the set of all SVGElement subclasses that already exist */
-(NSArray*) supportedTags
{
	return [NSMutableArray arrayWithObjects:@"pattern", @"gradient", nil];
}

- (NSObject*) handleStartElement:(NSString *)name document:(SVGKSource*) SVGKSource xmlns:(NSString*) prefix attributes:(NSMutableDictionary *)attributes parseResult:(SVGKParseResult *)parseResult {
		
	NSAssert( FALSE, @"Patterns and gradients are not supported by SVGKit yet - no-one has implemented them" );
	
	return nil;
}

-(BOOL) createdItemShouldStoreContent:(NSObject*) item
{
	NSAssert( FALSE, @"Patterns and gradients are not supported by SVGKit yet - no-one has implemented them" );
	
		return false;
}

-(void) addChildObject:(NSObject*)child toObject:(NSObject*)parent parseResult:(SVGKParseResult *)parseResult
{
	NSAssert( FALSE, @"Patterns and gradients are not supported by SVGKit yet - no-one has implemented them" );
}

-(void) parseContent:(NSMutableString*) content forItem:(NSObject*) item
{
	NSAssert( FALSE, @"Patterns and gradients are not supported by SVGKit yet - no-one has implemented them" );
}

@end

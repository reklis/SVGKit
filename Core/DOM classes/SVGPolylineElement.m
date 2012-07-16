//
//  SVGPolylineElement.m
//  SVGKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "SVGPolylineElement.h"

#import "SVGUtils.h"

#import "SVGElement_ForParser.h" // to resolve Xcode circular dependencies; in long term, parsing SHOULD NOT HAPPEN inside any class whose name starts "SVG" (because those are reserved classes for the SVG Spec)


@implementation SVGPolylineElement

- (void)parseAttributes:(NSDictionary *)attributes parseResult:(SVGKParseResult *)parseResult {
	[super parseAttributes:attributes parseResult:parseResult];
	
	id value = nil;
	
	if ((value = [attributes objectForKey:@"points"])) {
		CGMutablePathRef path = createPathFromPointsInString([value UTF8String], NO);
		
		[self setPathByCopyingPathFromLocalSpace:path];
		CGPathRelease(path);
	}
}

@end

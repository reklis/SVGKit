//
//  SVGPolylineElement.m
//  SVGKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "SVGPolylineElement.h"

#import "SVGUtils.h"

@implementation SVGPolylineElement

- (NSError*)parseAttributes:(NSDictionary *)attributes {
	[super parseAttributes:attributes];
	
	id value = nil;
	
	if ((value = [attributes objectForKey:@"points"])) {
		CGMutablePathRef path = createPathFromPointsInString([value UTF8String], NO);
		
		[self setPathByCopyingPathFromLocalSpace:path];
		CGPathRelease(path);
	}
	
	return nil;
}

@end

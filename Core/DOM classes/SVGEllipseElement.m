//
//  SVGEllipseElement.m
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGEllipseElement.h"

#import "SVGElement_ForParser.h" // to resolve Xcode circular dependencies; in long term, parsing SHOULD NOT HAPPEN inside any class whose name starts "SVG" (because those are reserved classes for the SVG Spec)

@implementation SVGEllipseElement

@synthesize cx = _cx;
@synthesize cy = _cy;
@synthesize rx = _rx;
@synthesize ry = _ry;

- (void)parseAttributes:(NSDictionary *)attributes parseResult:(SVGKParseResult *)parseResult {
	[super parseAttributes:attributes parseResult:parseResult];
	
	id value = nil;
	
	if ((value = [attributes objectForKey:@"cx"])) {
		_cx = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"cy"])) {
		_cy = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"rx"])) {
		_rx = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"ry"])) {
		_ry = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"r"])) { // circle
		_rx = [value floatValue];
		_ry = _rx;
	}
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect(path, NULL, CGRectMake(_cx - _rx, _cy - _ry, _rx * 2, _ry * 2));
	
	[self setPathByCopyingPathFromLocalSpace:path];
	CGPathRelease(path);
}

@end

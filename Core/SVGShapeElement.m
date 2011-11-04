//
//  SVGShapeElement.m
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGShapeElement.h"

#import "CGPathAdditions.h"
#import "SVGDefsElement.h"
#import "SVGDocument.h"
#import "SVGElement+Private.h"
#import "SVGPattern.h"

@implementation SVGShapeElement

#define IDENTIFIER_LEN 256

@synthesize opacity = _opacity;

@synthesize fillType = _fillType;
@synthesize fillColor = _fillColor;
@synthesize fillPattern = _fillPattern;

@synthesize strokeWidth = _strokeWidth;
@synthesize strokeColor = _strokeColor;

@synthesize path = _path;

- (void)finalize {
	CGPathRelease(_path);
	[super finalize];
}

- (void)dealloc {
	CGPathRelease(_path);
    
}

- (void)loadDefaults {
	_opacity = 1.0f;
	
	_fillColor = SVGColorMake(0, 0, 0, 255);
	_fillType = SVGFillTypeSolid;
}

- (void)parseAttributes:(NSDictionary *)attributes {
	[super parseAttributes:attributes];
	
	id value = nil;
	
	if ((value = [attributes objectForKey:@"opacity"])) {
		_opacity = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"fill"])) {
		const char *cvalue = [value UTF8String];
		
		if (!strncmp(cvalue, "none", 4)) {
			_fillType = SVGFillTypeNone;
		}
		else if (!strncmp(cvalue, "url", 3)) {
			NSLog(@"Gradients are no longer supported");
			_fillType = SVGFillTypeNone;
		}
		else {
			_fillColor = SVGColorFromString([value UTF8String]);
			_fillType = SVGFillTypeSolid;
		}
	}
	
	if ((value = [attributes objectForKey:@"stroke-width"])) {
		_strokeWidth = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"stroke"])) {
		const char *cvalue = [value UTF8String];
		
		if (!strncmp(cvalue, "none", 4)) {
			_strokeWidth = 0.0f;
		}
		else {
			_strokeColor = SVGColorFromString(cvalue);
			if (!_strokeWidth)
				_strokeWidth = 1.0f;
		}
	}
	
	if ((value = [attributes objectForKey:@"stroke-opacity"])) {
		_strokeColor.a = (uint8_t) ([value floatValue] * 0xFF);
	}
	
	if ((value = [attributes objectForKey:@"fill-opacity"])) {
		_fillColor.a = (uint8_t) ([value floatValue] * 0xFF);
	}
}

- (void)loadPath:(CGPathRef)aPath {
	if (_path) {
		CGPathRelease(_path);
		_path = NULL;
	}
	
	if (aPath) {
		_path = CGPathCreateCopy(aPath);
	}
}

- (CALayer *)layer {
	CAShapeLayer *shape = [CAShapeLayer layer];
	shape.name = self.identifier;
	shape.opacity = _opacity;
	
#if OUTLINE_SHAPES
	
#if TARGET_OS_IPHONE
	shape.borderColor = [UIColor redColor].CGColor;
#endif
	
	shape.borderWidth = 1.0f;
#endif
	
    CGRect rect = CGRectIntegral(CGPathGetPathBoundingBox(_path));
	
	CGPathRef path = CGPathCreateByOffsettingPath(_path, rect.origin.x, rect.origin.y);
	
	shape.path = path;
	CGPathRelease(path);
	
	shape.frame = rect;
	
	if (_strokeWidth) {
		shape.lineWidth = _strokeWidth;
		shape.strokeColor = CGColorWithSVGColor(_strokeColor).CGColor;
	}
	
	if (_fillType == SVGFillTypeNone) {
		shape.fillColor = nil;
	}
	else if (_fillType == SVGFillTypeSolid) {
		shape.fillColor = CGColorWithSVGColor(_fillColor).CGColor;
	}
    
    if (nil != _fillPattern) {
        shape.fillColor = [_fillPattern CGColor];
    }
	
	if ([shape respondsToSelector:@selector(setShouldRasterize:)]) {
		[shape performSelector:@selector(setShouldRasterize:)
					withObject:[NSNumber numberWithBool:YES]];
	}
	
	return shape;
}

- (void)layoutLayer:(CALayer *)layer { }

@end

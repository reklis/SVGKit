//
//  SVGDocument.m
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGDocument.h"

#import "SVGDefsElement.h"
#import "SVGDescriptionElement.h"
#import "SVGElement+Private.h"
#import "SVGParser.h"
#import "SVGTitleElement.h"
#import "SVGPathElement.h"

@interface SVGDocument ()

@property (nonatomic, copy) NSString *version;

- (BOOL)parseData:(NSData *)data;

- (SVGElement *)findFirstElementOfClass:(Class)class;

@end


@implementation SVGDocument

@synthesize width = _width;
@synthesize height = _height;
@synthesize version = _version;

@dynamic title, desc, defs;

/* TODO: parse 'viewBox' */

+ (id)documentNamed:(NSString *)name {
	NSParameterAssert(name != nil);
	
	NSBundle *bundle = [NSBundle mainBundle];
	
	if (!bundle)
		return nil;
	
	NSString *newName = [name stringByDeletingPathExtension];
	NSString *extension = [name pathExtension];
    if ([@"" isEqualToString:extension]) {
        extension = @"svg";
    }
	
	NSString *path = [bundle pathForResource:newName ofType:extension];
	
	if (!path)
		return nil;
	
	return [self documentWithContentsOfFile:path];
}

+ (id)documentWithContentsOfFile:(NSString *)aPath {
	return [[[self class] alloc] initWithContentsOfFile:aPath];
}

+ (id)documentWithData:(NSData *)data {
    return [[[self class] alloc] initWithData:data];
}

- (id)initWithContentsOfFile:(NSString *)aPath {
	NSParameterAssert(aPath != nil);
    
    NSData *data = [NSData dataWithContentsOfFile:aPath];
	
	return [self initWithData:data];
}

- (id)initWithData:(NSData *)data {
	self = [super initWithDocument:self name:@"svg"];
	if (self) {
		_width = _height = 100;
		
		if (![self parseData:data]) {
			return nil;
		}
	}
    
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithDocument:self name:@"svg"];
	if (self) {
        _width = CGRectGetWidth(frame);
        _height = CGRectGetHeight(frame);
    }
	return self;
}


- (BOOL)parseData:(NSData *)data {
	NSError *error = nil;
	
	SVGParser *parser = [[SVGParser alloc] initWithData:data document:self];
	
	if (![parser parse:&error]) {
		NSLog(@"Parser error: %@", error);
		
		return NO;
	}
	
	
	return YES;
}

- (CALayer *)layer {
	CALayer *layer = [CALayer layer];
	layer.frame = CGRectMake(0.0f, 0.0f, _width, _height);
	
	return layer;
}

- (void)layoutLayer:(CALayer *)layer { }

- (SVGElement *)findFirstElementOfClass:(Class)class {
	for (SVGElement *element in self.children) {
		if ([element isKindOfClass:class])
			return element;
	}
	
	return nil;
}

- (NSString *)title {
	return [self findFirstElementOfClass:[SVGTitleElement class]].stringValue;
}

- (NSString *)desc {
	return [self findFirstElementOfClass:[SVGDescriptionElement class]].stringValue;
}

- (SVGDefsElement *)defs {
	return (SVGDefsElement *) [self findFirstElementOfClass:[SVGDefsElement class]];
}

- (void)parseAttributes:(NSDictionary *)attributes {
	[super parseAttributes:attributes];
	
	id value = nil;
	
	if ((value = [attributes objectForKey:@"width"])) {
		_width = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"height"])) {
		_height = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"version"])) {
		self.version = value;
	}
}

#if NS_BLOCKS_AVAILABLE

- (void) applyAggregator:(SVGElementAggregationBlock)aggregator toElement:(SVGElement < SVGLayeredElement > *)element
{
	if (![element.children count]) {
		return;
	}
	
	for (SVGElement *child in element.children) {
		if ([child conformsToProtocol:@protocol(SVGLayeredElement)]) {
			SVGElement<SVGLayeredElement>* layeredElement = (SVGElement<SVGLayeredElement>*)child;
            if (layeredElement) {
                aggregator(layeredElement);
                
                [self applyAggregator:aggregator
                            toElement:layeredElement];
            }
		}
	}
}

- (void) applyAggregator:(SVGElementAggregationBlock)aggregator
{
    [self applyAggregator:aggregator toElement:self];
}

#endif

@end

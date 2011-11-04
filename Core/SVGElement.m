//
//  SVGElement.m
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGElement.h"

@interface SVGElement ()

@property (nonatomic, copy) NSString *stringValue;

@end


@implementation SVGElement

@synthesize document = _document;

@synthesize children = _children;
@synthesize stringValue = _stringValue;
@synthesize localName = _localName;

@synthesize identifier = _identifier;

+ (BOOL)shouldStoreContent {
	return NO;
}

- (id)init {
    self = [super init];
    if (self) {
		[self loadDefaults];
        _children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithDocument:(SVGDocument *)aDocument name:(NSString *)name {
	self = [self init];
	if (self) {
		_document = aDocument;
		_localName = name;
	}
	return self;
}


- (void)loadDefaults {
	// to be overriden by subclasses
}

- (void)addChild:(SVGElement *)element {
	[_children addObject:element];
}

- (void)parseAttributes:(NSDictionary *)attributes {
	// to be overriden by subclasses
	// make sure super implementation is called
	
	id value = nil;
	
	if ((value = [attributes objectForKey:@"id"])) {
		_identifier = [value copy];
	}
}

- (void)parseContent:(NSString *)content {
	self.stringValue = content;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ %p | localName=%@ | stringValue=%@ | children=%d>", 
			[self class], self, _localName, _stringValue, [_children count]];
}

@end

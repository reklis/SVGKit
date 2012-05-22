//
//  Attr.m
//  SVGKit
//
//  Created by adam on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Attr.h"

/*
 @property(nonatomic,retain,readonly) NSString* name;
 @property(nonatomic,readonly) BOOL specified;
 @property(nonatomic,retain,readonly) NSString* value;
 
 // Introduced in DOM Level 2:
 @property(nonatomic,retain,readonly) Element* ownerElement;
*/

@implementation Attr

@synthesize name;
@synthesize specified;
@synthesize value;

// Introduced in DOM Level 2:
@synthesize ownerElement;

- (id)initWithName:(NSString*) n {
    self = [super init];
    if (self) {
        self.nodeName = self.name = n;
    }
    return self;
}

- (id)initWithNamespace:(NSString*) ns qualifiedName:(NSString*) qn {
    self = [super init];
    if (self) {
        self.nodeName = qn;
		self.namespaceURI = ns;
		self.name = qn;
		
		NSAssert( FALSE, @"Spec requires us to set two more properties using a process I don't understand: Node.prefix = prefix, extracted from qualifiedName, or null if there is no prefix. Node.localName = local name, extracted from qualifiedName" );
    }
    return self;
}

- (void)dealloc {
    self.name = nil;
	self.value = nil;
    [super dealloc];
}

@end

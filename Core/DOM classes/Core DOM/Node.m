//
//  Node.m
//  SVGKit
//
//  Created by adam on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Node.h"

#import "NodeList+Mutable.h"

@interface Node()
@property(nonatomic,retain,readonly) NSString* nodeName;
@property(nonatomic,retain,readonly) NSString* nodeValue;

@property(nonatomic,retain,readonly) SKNodeType nodeType;
@property(nonatomic,retain,readonly) Node* parentNode;
@property(nonatomic,retain,readonly) NodeList* childNodes;
@property(nonatomic,retain,readonly) Node* firstChild;
@property(nonatomic,retain,readonly) Node* lastChild;
@property(nonatomic,retain,readonly) Node* previousSibling;
@property(nonatomic,retain,readonly) Node* nextSibling;
@property(nonatomic,retain,readonly) NamedNodeMap* attributes;
 
 @property(nonatomic,retain,readonly) Document* ownerDocument;
 
 // Introduced in DOM Level 2:
 @property(nonatomic,retain,readonly) NSString* namespaceURI;
 
 // Introduced in DOM Level 2:
 @property(nonatomic,retain,readonly) NSString* prefix;
 
 // Introduced in DOM Level 2:
 @property(nonatomic,retain,readonly) NSString* localName;
 
 // Introduced in DOM Level 2:
 @property(nonatomic) BOOL hasAttributes;

@end

@implementation Node

@synthesize nodeName;
@synthesize nodeValue;

@synthesize nodeType;
@synthesize parentNode;
@synthesize childNodes;
@synthesize firstChild;
@synthesize lastChild;
@synthesize previousSibling;
@synthesize nextSibling;
@synthesize attributes;

// Modified in DOM Level 2:
@synthesize ownerDocument;

- (id)initType:(SKNodeType) nt
{
    self = [super init];
    if (self) {
        switch( nt )
		{
			case SKNodeType_ELEMENT_NODE:
			{
				self.attributes = [[[NamedNodeMap alloc] init] autorelease];
			}break;
				
			case SKNodeType_ATTRIBUTE_NODE:
			case SKNodeType_TEXT_NODE:
			case SKNodeType_CDATA_SECTION_NODE:
			case SKNodeType_ENTITY_REFERENCE_NODE:
			case SKNodeType_ENTITY_NODE:
			case SKNodeType_PROCESSING_INSTRUCTION_NODE:
			case SKNodeType_COMMENT_NODE:
			case SKNodeType_DOCUMENT_NODE:
			case SKNodeType_DOCUMENT_TYPE_NODE:
			case SKNodeType_DOCUMENT_FRAGMENT_NODE:
			case SKNodeType_NOTATION_NODE:
			{
				
			}break;
		}
		
		self.childNodes = [[[NodeList alloc] init] autorelease];
    }
    return self;
}

- (id)initAttr:(NSString*) n value:(NSString*) v {
    self = [self initType:SKNodeType_ATTRIBUTE_NODE];
    if (self) {
        self.nodeName = n;
		self.nodeValue = v;
    }
    return self;
}
- (id)initCDATASection:(NSString*) n value:(NSString*) v {
    self = [self initType:SKNodeType_CDATA_SECTION_NODE];
    if (self) {
        self.nodeName = n;
		self.nodeValue = v;
    }
    return self;
}
- (id)initComment:(NSString*) n value:(NSString*) v {
    self = [self initType:SKNodeType_COMMENT_NODE];
    if (self) {
        self.nodeName = n;
		self.nodeValue = v;
    }
    return self;
}
- (id)initDocument:(NSString*) n {
    self = [self initType:SKNodeType_DOCUMENT_NODE];
    if (self) {
        self.nodeName = n;
    }
    return self;
}
- (id)initDocumentFragment:(NSString*) n {
    self = [self initType:SKNodeType_DOCUMENT_FRAGMENT_NODE];
    if (self) {
        self.nodeName = n;
    }
    return self;
}
- (id)initDocumentType:(NSString*) n {
    self = [self initType:SKNodeType_DOCUMENT_TYPE_NODE];
    if (self) {
        self.nodeName = n;
    }
    return self;
}
- (id)initElement:(NSString*) n {
    self = [self initType:SKNodeType_ELEMENT_NODE];
    if (self) {
        self.nodeName = n;
    }
    return self;
}
- (id)initEntity:(NSString*) n {
    self = [self initType:SKNodeType_ENTITY_NODE];
    if (self) {
        self.nodeName = n;
    }
    return self;
}
- (id)initEntityReference:(NSString*) n {
    self = [self initType:SKNodeType_ENTITY_REFERENCE_NODE];
    if (self) {
        self.nodeName = n;
    }
    return self;
}
- (id)initNotation:(NSString*) n {
    self = [self initType:SKNodeType_NOTATION_NODE];
    if (self) {
        self.nodeName = n;
    }
    return self;
}
- (id)initProcessingInstruction:(NSString*) n value:(NSString*) v {
    self = [self initType:SKNodeType_PROCESSING_INSTRUCTION_NODE];
    if (self) {
        self.nodeName = n;
		self.nodeValue = v;
    }
    return self;
}
- (id)initText:(NSString*) n value:(NSString*) v {
    self = [self initType:SKNodeType_TEXT_NODE];
    if (self) {
        self.nodeName = n;
		self.nodeValue = v;
    }
    return self;
}


-(Node*) insertBefore:(Node*) newChild refChild:(Node*) refChild
{
	if( refChild == nil )
	{
		[self.childNodes.internalArray addObject:newChild];
	}
	else
	{
		[self.childNodes.internalArray insertObject:newChild atIndex:[self.childNodes.internalArray indexOfObject:refChild]];
	}
}

-(Node*) replaceChild:(Node*) newChild oldChild:(Node*) oldChild
{
	if( newChild.nodeType == SKNodeType_DOCUMENT_FRAGMENT_NODE )
	{
		/** Spec:
		 
		 "If newChild is a DocumentFragment object, oldChild is replaced by all of the DocumentFragment children, which are inserted in the same order. If the newChild is already in the tree, it is first removed."
		 */
		
		int oldIndex = [self.childNodes.internalArray indexOfObject:oldChild];
		
		NSAssert( FALSE, @"We should be recursing down the tree to find 'newChild' at any location, and removing it - required by spec - but we have no convenience method for that search, yet" );
		
		for( Node* child in newChild.childNodes.internalArray )
		{
			[self.childNodes.internalArray insertObject:child atIndex:oldIndex++];
		}
		
		return oldChild;
	}
	else
	{
		[self.childNodes.internalArray replaceObjectAtIndex:[self.childNodes.internalArray indexOfObject:oldChild] withObject:newChild];
		
		return oldChild;
	}
}
-(Node*) removeChild:(Node*) oldChild
{
	[self.childNodes.internalArray removeObject:oldChild];
	
	return oldChild;
}

-(Node*) appendChild:(Node*) newChild
{
	[self.childNodes.internalArray removeObject:newChild]; // required by spec
	[self.childNodes.internalArray addObject:newChild];
	return newChild;
}

-(BOOL)hasChildNodes
{
	return [self.childNodes.length > 0];
}

-(Node*) cloneNode:(BOOL) deep
{
	NSAssert( FALSE, @"Not implemented yet - read the spec. Sounds tricky. I'm too tired, and would probably screw it up right now" );
}

// Modified in DOM Level 2:
-(void) normalize
{
	NSAssert( FALSE, @"Not implemented yet - read the spec. Sounds tricky. I'm too tired, and would probably screw it up right now" );
}

// Introduced in DOM Level 2:
-(BOOL) isSupportedFeature:(NSString*) feature version:(NSString*) version
{
	NSAssert( FALSE, @"Not implemented yet - read the spec. I have literally no idea what this is supposed to do." );
}

// Introduced in DOM Level 2:
@synthesize namespaceURI;

// Introduced in DOM Level 2:
@synthesize prefix;

// Introduced in DOM Level 2:
@synthesize localName;

// Introduced in DOM Level 2:
-(BOOL)hasAttributes
{
	if( self.attributes == nil )
		return FALSE;
	
	return (self.attributes.length > 0 );
}

@end

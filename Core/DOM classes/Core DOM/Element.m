#import "Element.h"

#import "NamedNodeMap.h"

@interface Element()
@property(nonatomic,retain,readwrite) NSString* tagName;
@end

@implementation Element

@synthesize tagName;

- (id)initWithLocalName:(NSString*) n attributes:(NSMutableDictionary*) attributes {
    self = [super initElement:n];
    if (self) {
        self.tagName = n;
		
		/** FIXME: read the spec and add two versions of this, one that uses NAMESPACED attributes,
		 and one that doesn't.
		 
		 Yes, DOM is a total Pain In The A** to implement - the different versions are mostly
		 separate, parallel, specs
		 */
		for( NSString* attributeName in attributes.allKeys )
		{
			[self setAttribute:attributeName value:[attributes objectForKey:attributeName]];
		}
    }
    return self;
}
- (id)initWithQualifiedName:(NSString*) n inNameSpaceURI:(NSString*) nsURI attributes:(NSMutableDictionary*) attributes {
    self = [super initElement:n inNameSpaceURI:nsURI];
    if (self) {
        self.tagName = n;
		
		/** FIXME: read the spec and add two versions of this, one that uses NAMESPACED attributes,
		 and one that doesn't.
		 
		 Yes, DOM is a total Pain In The A** to implement - the different versions are mostly
		 separate, parallel, specs
		 */
		for( NSString* attributeName in attributes.allKeys )
		{
			[self setAttribute:attributeName value:[attributes objectForKey:attributeName]];
		}
    }
    return self;
}


-(NSString*) getAttribute:(NSString*) name
{
	Attr* result = (Attr*) [self.attributes getNamedItem:name];
	
	if( result == nil || result.value == nil )
		return @""; // according to spec
	else
		return result.value;
}

-(void) setAttribute:(NSString*) name value:(NSString*) value
{
	Attr* att = [[[Attr alloc] initAttr:name value:value] autorelease];
	
	[self.attributes setNamedItem:att];
}

-(void) removeAttribute:(NSString*) name
{
	[self.attributes removeNamedItem:name];
	
	NSAssert( FALSE, @"Not fully implemented. Spec says: If the removed attribute is known to have a default value, an attribute immediately appears containing the default value as well as the corresponding namespace URI, local name, and prefix when applicable." );
}

-(Attr*) getAttributeNode:(NSString*) name
{
	return (Attr*) [self.attributes getNamedItem:name];
}

-(Attr*) setAttributeNode:(Attr*) newAttr
{
	Attr* oldAtt = (Attr*) [self.attributes getNamedItem:newAttr.nodeName];
	
	[self.attributes setNamedItem:newAttr];
	
	return oldAtt;
}

-(Attr*) removeAttributeNode:(Attr*) oldAttr
{
	[self.attributes removeNamedItem:oldAttr.nodeName];
	
	NSAssert( FALSE, @"Not fully implemented. Spec: If the removed Attr  has a default value it is immediately replaced. The replacing attribute has the same namespace URI and local name, as well as the original prefix, when applicable. " );
	
	return oldAttr;
}

-(NodeList*) getElementsByTagName:(NSString*) name
{
	NSAssert( FALSE, @"Not implemented yet" );
	return nil;
}

// Introduced in DOM Level 2:
-(NSString*) getAttributeNS:(NSString*) namespaceURI localName:(NSString*) localName
{
	NSAssert( FALSE, @"Not implemented yet" );
	return nil;
}

// Introduced in DOM Level 2:
-(void) setAttributeNS:(NSString*) namespaceURI qualifiedName:(NSString*) qualifiedName value:(NSString*) value
{
	NSAssert( FALSE, @"Not implemented yet" );
}

// Introduced in DOM Level 2:
-(void) removeAttributeNS:(NSString*) namespaceURI localName:(NSString*) localName
{
	NSAssert( FALSE, @"Not implemented yet" );
}

// Introduced in DOM Level 2:
-(Attr*) getAttributeNodeNS:(NSString*) namespaceURI localName:(NSString*) localName
{
	NSAssert( FALSE, @"Not implemented yet" );
	return nil;
}

// Introduced in DOM Level 2:
-(Attr*) setAttributeNodeNS:(Attr*) newAttr
{
	NSAssert( FALSE, @"Not implemented yet" );
	return nil;
}

// Introduced in DOM Level 2:
-(NodeList*) getElementsByTagNameNS:(NSString*) namespaceURI localName:(NSString*) localName
{
	NSAssert( FALSE, @"Not implemented yet" );
	return nil;
}

// Introduced in DOM Level 2:
-(BOOL) hasAttribute:(NSString*) name
{
	NSAssert( FALSE, @"Not implemented yet" );
	return FALSE;
}

// Introduced in DOM Level 2:
-(BOOL) hasAttributeNS:(NSString*) namespaceURI localName:(NSString*) localName
{
	NSAssert( FALSE, @"Not implemented yet" );
	return FALSE;
}

@end

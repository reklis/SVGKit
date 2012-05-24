#import "Element.h"

@interface Element()
@property(nonatomic,retain,readwrite) NSString* tagName;

@property(nonatomic,retain) NSMutableDictionary* attributesByName;
@end

@implementation Element

@synthesize tagName;
@synthesize attributesByName;

- (id)initType:(SKNodeType) nt
{
    self = [super initType:nt];
    if (self) {
        self.attributesByName = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSString*) getAttribute:(NSString*) name
{
	Attr* result = [self.attributesByName valueForKey:name];
	
	if( result == nil || result.value == nil )
		return @""; // according to spec
	else
		return result.value;
}

-(void) setAttribute:(NSString*) name value:(NSString*) value
{
	Attr* att = [[Attr alloc] initAttr:name value:value];
	
	[self.attributesByName setValue:att forKey:name];
}

-(void) removeAttribute:(NSString*) name
{
	[self.attributesByName removeObjectForKey:name];
	
	NSAssert( FALSE, @"Not fully implemented. Spec says: If the removed attribute is known to have a default value, an attribute immediately appears containing the default value as well as the corresponding namespace URI, local name, and prefix when applicable." );
}

-(Attr*) getAttributeNode:(NSString*) name
{
	return [self.attributesByName valueForKey:name];
}

-(Attr*) setAttributeNode:(Attr*) newAttr
{
	Attr* oldAtt = [self.attributesByName objectForKey:newAttr.nodeName];
	
	[self.attributesByName setValue:newAttr forKey:newAttr.nodeName];
	
	return oldAtt;
}

-(Attr*) removeAttributeNode:(Attr*) oldAttr
{
	[self.attributesByName removeObjectForKey:oldAttr.nodeName];
	
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

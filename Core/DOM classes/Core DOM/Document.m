#import "Document.h"

/*
 @property(nonatomic,retain,readonly) DocumentType     doctype;
 @property(nonatomic,retain,readonly) DOMImplementation  implementation;
 @property(nonatomic,retain,readonly) Element          documentElement;

*/

@implementation Document

@synthesize doctype;
@synthesize implementation;
@synthesize documentElement;


-(Element*) createElement:(NSString*) tagName
{
	NSAssert( FALSE, @"This is not implemented, but is required by the spec to: Creates an element of the type specified. In addition, if there are known attributes with default values, Attr nodes representing them are automatically created and attached to the element." );
	return nil;
}

-(DocumentFragment*) createDocumentFragment
{
	return [[[DocumentFragment alloc] initDocumentFragment:nil] autorelease];
}

-(Text*) createTextNode:(NSString*) data
{
	return [[[Text alloc] initText:nil value:data] autorelease];
}

-(Comment*) createComment:(NSString*) data
{
	return [[[Comment alloc] initComment:nil value:data] autorelease];
}

-(CDATASection*) createCDATASection:(NSString*) data
{
	return [[[CDATASection alloc] initCDATASection:nil value:data] autorelease];
}

-(ProcessingInstruction*) createProcessingInstruction:(NSString*) target data:(NSString*) data
{
	return [[[ProcessingInstruction alloc] initProcessingInstruction:target value:data] autorelease];
}

-(Attr*) createAttribute:(NSString*) data
{
	return [[[Attr alloc] initAttr:data value:nil] autorelease];
}

-(EntityReference*) createEntityReference:(NSString*) data
{
	NSAssert( FALSE, @"Not implemented. According to spec: Creates an EntityReference object. In addition, if the referenced entity is known, the child list of the EntityReference  node is made the same as that of the corresponding Entity  node. Note: If any descendant of the Entity node has an unbound namespace prefix, the corresponding descendant of the created EntityReference node is also unbound; (its namespaceURI is null). The DOM Level 2 does not support any mechanism to resolve namespace prefixes." );
	return nil;
}

-(NodeList*) getElementsByTagName:(NSString*) data
{
	NSAssert( FALSE, @"Not implemented. According to spec: Returns a NodeList  of all the Elements  with a given tag name in the order in which they are encountered in a preorder traversal of the Document tree." );
	return nil;
}

// Introduced in DOM Level 2:
-(Node*) importNode:(Node*) importedNode deep:(BOOL) deep
{
	NSAssert( FALSE, @"Not implemented." );
	return nil;
}

// Introduced in DOM Level 2:
-(Element*) createElementNS:(NSString*) namespaceURI qualifiedName:(NSString*) qualifiedName
{
	NSAssert( FALSE, @"This should be implemented to share code with createAttributeNS: method below" );
	return nil;
}

// Introduced in DOM Level 2:
-(Attr*) createAttributeNS:(NSString*) namespaceURI qualifiedName:(NSString*) qualifiedName
{
	NSAssert( FALSE, @"This should be re-implemented to share code with createElementNS: method above" );
	Attr* newAttr = [[[Attr alloc] initWithNamespace:namespaceURI qualifiedName:qualifiedName] autorelease];
	return newAttr;
}

// Introduced in DOM Level 2:
-(NodeList*) getElementsByTagNameNS:(NSString*) namespaceURI qualifiedName:(NSString*) localName
{
	NSAssert( FALSE, @"Not implemented. According to spec: Returns a NodeList  of all the Elements  with a given local name and namespace URI in the order in which they are encountered in a preorder traversal of the Document tree." );
	return nil;
}

// Introduced in DOM Level 2:
-(Element*) getElementById:(NSString*) elementId
{
	/**
	 Hard-coding this to SVG, where only attributes tagged "id" are ID attributes
	 */
	NSAssert( FALSE, @"At this point, we have to recurse down the tree looking at the id's of each SVG element. This is already implemented in old SVGKit, need to copy/paste/debug the code" );
	return nil;
}

@end

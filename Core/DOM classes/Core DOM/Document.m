#import "Document.h"
#import "Document+Mutable.h"

#import "NodeList+Mutable.h" // needed for access to underlying array, because SVG doesnt specify how lists are made mutable

@interface Document()
/*! private method used in implementation of the getElementsByTagName method */
-(void) privateGetElementsByTagName:(NSString*) tagName childrenOfElement:(Node*) parent addToList:(NodeList*) accumulator;
@end

@implementation Document

@synthesize doctype;
@synthesize implementation;
@synthesize documentElement;


-(Element*) createElement:(NSString*) tagName
{
	Element* newElement = [[Element alloc] initElement:tagName];
	
	NSLog( @"[%@] WARNING: SVG Spec, missing feature: if there are known attributes with default values, Attr nodes representing them SHOULD BE automatically created and attached to the element.", [self class] );
	
	return newElement;
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
	NodeList* accumulator = [[NodeList alloc] init];
	[self privateGetElementsByTagName:data childrenOfElement:self.documentElement addToList:accumulator];
	
	return accumulator;
}

-(void) privateGetElementsByTagName:(NSString*) tagName childrenOfElement:(Node*) parent addToList:(NodeList*) accumulator
{
	/** According to spec, this is only valid for ELEMENT nodes */
	if( [parent isKindOfClass:[Element class]] )
	{
		/** According to spec, "tag name" for an Element is the value of its .nodeName property; that means SOMETIMES its a qualified name! */
		if( [tagName isEqualToString:@"*"]
		|| [parent.nodeName isEqualToString:tagName] )
		{
			[accumulator.internalArray addObject:parent];
		}
	}
	
	for( Node* childNode in parent.childNodes )
	{
		[self privateGetElementsByTagName:tagName childrenOfElement:childNode addToList:accumulator];
	}
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
	Element* newElement = [[Element alloc] initWithQualifiedName:qualifiedName inNameSpaceURI:[NSURL URLWithString:namespaceURI]];
	
	NSLog( @"[%@] WARNING: SVG Spec, missing feature: if there are known attributes with default values, Attr nodes representing them SHOULD BE automatically created and attached to the element.", [self class] );
	
	return newElement;
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

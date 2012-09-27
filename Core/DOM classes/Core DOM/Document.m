#import "Document.h"
#import "Document+Mutable.h"

#import "NodeList+Mutable.h" // needed for access to underlying array, because SVG doesnt specify how lists are made mutable

@interface Document()
/*! private method used in implementation of the MULTIPLE getElementsByTagName methods */
-(void) privateGetElementsByName:(NSString*) name inNamespace:(NSString*) namespaceURI childrenOfElement:(Node*) parent addToList:(NodeList*) accumulator;
@end

@implementation Document

@synthesize doctype;
@synthesize implementation;
@synthesize documentElement;


-(Element*) createElement:(NSString*) tagName
{
	Element* newElement = [[Element alloc] initWithLocalName:tagName attributes:nil];
	
	NSLog( @"[%@] WARNING: SVG Spec, missing feature: if there are known attributes with default values, Attr nodes representing them SHOULD BE automatically created and attached to the element.", [self class] );
	
	return newElement; /** NOTE: clang says this is a leak - it is NOT, it is a REQUIRED RETAIN COUNT, as per SVG Spec */
}

-(DocumentFragment*) createDocumentFragment
{
	return [[[DocumentFragment alloc] init] autorelease];
}

-(Text*) createTextNode:(NSString*) data
{
	return [[[Text alloc] initWithValue:data] autorelease];
}

-(Comment*) createComment:(NSString*) data
{
	return [[[Comment alloc] initWithValue:data] autorelease];
}

-(CDATASection*) createCDATASection:(NSString*) data
{
	return [[[CDATASection alloc] initWithValue:data] autorelease];
}

-(ProcessingInstruction*) createProcessingInstruction:(NSString*) target data:(NSString*) data
{
	return [[[ProcessingInstruction alloc] initProcessingInstruction:target value:data] autorelease];
}

-(Attr*) createAttribute:(NSString*) n
{
	return [[[Attr alloc] initWithName:n value:@""] autorelease];
}

-(EntityReference*) createEntityReference:(NSString*) data
{
	NSAssert( FALSE, @"Not implemented. According to spec: Creates an EntityReference object. In addition, if the referenced entity is known, the child list of the EntityReference  node is made the same as that of the corresponding Entity  node. Note: If any descendant of the Entity node has an unbound namespace prefix, the corresponding descendant of the created EntityReference node is also unbound; (its namespaceURI is null). The DOM Level 2 does not support any mechanism to resolve namespace prefixes." );
	return nil;
}

-(NodeList*) getElementsByTagName:(NSString*) data
{
	NodeList* accumulator = [[[NodeList alloc] init] autorelease];
	[self privateGetElementsByName:data inNamespace:nil childrenOfElement:self.documentElement addToList:accumulator];
	
	return accumulator;
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
	Element* newElement = [[Element alloc] initWithQualifiedName:qualifiedName inNameSpaceURI:namespaceURI attributes:nil];
	
	NSLog( @"[%@] WARNING: SVG Spec, missing feature: if there are known attributes with default values, Attr nodes representing them SHOULD BE automatically created and attached to the element.", [self class] );
	
	return newElement; /** NOTE: clang says this is a leak - it is NOT, it is a REQUIRED RETAIN COUNT, as per SVG Spec */
}

// Introduced in DOM Level 2:
-(Attr*) createAttributeNS:(NSString*) namespaceURI qualifiedName:(NSString*) qualifiedName
{
	NSAssert( FALSE, @"This should be re-implemented to share code with createElementNS: method above" );
	Attr* newAttr = [[[Attr alloc] initWithNamespace:namespaceURI qualifiedName:qualifiedName value:@""] autorelease];
	return newAttr;
}

// Introduced in DOM Level 2:
-(NodeList*) getElementsByTagNameNS:(NSString*) namespaceURI localName:(NSString*) localName
{
	NodeList* accumulator = [[[NodeList alloc] init] autorelease];
	[self privateGetElementsByName:localName inNamespace:namespaceURI childrenOfElement:self.documentElement addToList:accumulator];
	
	return accumulator;
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

#pragma mark - Non-Spec methods required to implement the Spec methods

/*! This useful method provides both the DOM level 1 and the DOM level 2 implementations of searching the tree for a node - because THEY ARE DIFFERENT
 yet very similar
 */
-(void) privateGetElementsByName:(NSString*) name inNamespace:(NSString*) namespaceURI childrenOfElement:(Node*) parent addToList:(NodeList*) accumulator
{
	/** According to spec, this is only valid for ELEMENT nodes */
	if( [parent isKindOfClass:[Element class]] )
	{
		if( namespaceURI != nil && ! [parent.namespaceURI isEqualToString:namespaceURI] )
		{
			// skip
		}
		else
		{
			Element* parentAsElement = (Element*) parent;
			
			/** According to spec, "tag name" for an Element is the value of its .nodeName property; that means SOMETIMES its a qualified name! */
			BOOL includeThisNode = FALSE;
			
			
			if( [name isEqualToString:@"*"] )
				includeThisNode = TRUE;
			
			if( !includeThisNode )
			{
				if( namespaceURI == nil ) // No namespace? then do a qualified compare
				{
					includeThisNode = [parentAsElement.tagName isEqualToString:name];
				}
				else // namespace? then do an UNqualified compare
				{
					includeThisNode = [parentAsElement.localName isEqualToString:name];
				}
			}
			
			if( includeThisNode )
			{
				[accumulator.internalArray addObject:parent];
			}
		}
	}
	
	for( Node* childNode in parent.childNodes )
	{
		[self privateGetElementsByName:name inNamespace:namespaceURI childrenOfElement:childNode addToList:accumulator];
	}
}

@end

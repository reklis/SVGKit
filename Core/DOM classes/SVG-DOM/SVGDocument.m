/**
 SVGDocument
 
 SVG spec defines this as part of the DOM version of SVG:
 
 http://www.w3.org/TR/SVG11/struct.html#InterfaceSVGDocument
 */

#import "SVGDocument.h"
#import "SVGDocument_Mutable.h"

#import "SKBasicDataTypes.h"

#import "NodeList+Mutable.h"

@interface SVGDocument()
-(void) privateGetElementsByTagName:(NSString*) tagName childrenOfElement:(SVGElement*) parent addToList:(NodeList*) accumulator;
@end

@implementation SVGDocument


@synthesize title;
@synthesize referrer;
@synthesize domain;
@synthesize URL;
@synthesize rootElement;

-(NodeList*) getElementsByTagName:(NSString*) data
{
	NodeList* accumulator = [[NodeList alloc] init];
	[self privateGetElementsByTagName:data childrenOfElement:self.rootElement addToList:accumulator];
	
	return accumulator;
}

-(void) privateGetElementsByTagName:(NSString*) tagName childrenOfElement:(SVGElement*) parent addToList:(NodeList*) accumulator
{
	if( [parent.localName isEqualToString:tagName] )
		[accumulator.internalArray addObject:parent];
	
	for( SVGElement* childElement in parent.children )
	{
		[self privateGetElementsByTagName:tagName childrenOfElement:childElement addToList:accumulator];
	}
}

@end

#import "SVGKParserSVG.h"

#import "SVGSVGElement.h"
#import "SVGCircleElement.h"
#import "SVGDefsElement.h"
#import "SVGDescriptionElement.h"
//#import "SVGKSource.h"
#import "SVGEllipseElement.h"
#import "SVGGroupElement.h"
#import "SVGImageElement.h"
#import "SVGLineElement.h"
#import "SVGPathElement.h"
#import "SVGPolygonElement.h"
#import "SVGPolylineElement.h"
#import "SVGRectElement.h"
#import "SVGTitleElement.h"

#import "SVGDocument_Mutable.h"

@implementation SVGKParserSVG

static NSDictionary *elementMap;

- (id)init {
	self = [super init];
	if (self) {
		
		if (!elementMap) {
			elementMap = [[NSDictionary dictionaryWithObjectsAndKeys:
						   [SVGSVGElement class], @"svg",
                          [SVGCircleElement class], @"circle",
                          [SVGDefsElement class], @"defs",
                          [SVGDescriptionElement class], @"description",
                          [SVGEllipseElement class], @"ellipse",
                          [SVGGroupElement class], @"g",
                          [SVGImageElement class], @"image",
                          [SVGLineElement class], @"line",
                          [SVGPathElement class], @"path",
                          [SVGPolygonElement class], @"polygon",
                          [SVGPolylineElement class], @"polyline",
                          [SVGRectElement class], @"rect",
                          [SVGTitleElement class], @"title", nil] retain];
		}
	}
	return self;
}

- (void)dealloc {
	
	[super dealloc];
}

-(NSArray*) supportedNamespaces
{
	return [NSArray arrayWithObjects:
			 @"http://www.w3.org/2000/svg",
			nil];
}

/** "tags supported" is exactly the set of all SVGElement subclasses that already exist */
-(NSArray*) supportedTags
{
	return [NSMutableArray arrayWithArray:[elementMap allKeys]];
}

- (NSObject*) handleStartElement:(NSString *)name document:(SVGKSource*) SVGKSource xmlns:(NSString*) prefix attributes:(NSMutableDictionary *)attributes parseResult:(SVGKParseResult *)parseResult parentStackItem:(SVGKParserStackItem*) parentStackItem 
{
	if( [[self supportedNamespaces] containsObject:prefix] )
	{
		Class elementClass = [elementMap objectForKey:name];
		
		if (!elementClass) {
			elementClass = [SVGElement class];
			NSLog(@"Support for '%@' element has not been implemented", name);
		}
		
		id style = nil;
		
		if ((style = [attributes objectForKey:@"style"])) {
			[attributes removeObjectForKey:@"style"];
			[attributes addEntriesFromDictionary:[SVGKParser NSDictionaryFromCSSAttributes:style]];
		}
		
		SVGElement *element = [[[elementClass alloc] initWithName:name] autorelease];
		[element parseAttributes:attributes];
		
		/** special case: <svg:svg ... version="XXX"> */
		if( [@"svg" isEqualToString:name] )
		{
			NSString* svgVersion = nil;
			if ((svgVersion = [attributes objectForKey:@"version"])) {
				SVGKSource.svgLanguageVersion = svgVersion;
			}
			
			/** According to spec, if the first XML node is an SVG node, then it
			 becomes TWO THINGS:
			 
			 - An SVGSVGElement
			 *and*
			 - An SVGDocument
			 - ...and that becomes "the root SVGDocument"
			 
			 If it's NOT the first XML node, but it's the first SVG node, then it ONLY becomes:
			 
			 - An SVGSVGElement
			 
			 If it's NOT the first SVG node, then it becomes:
			 
			 - An SVGSVGElement
			 *and*
			 - An SVGDocument
			 
			 Yes. It's Very confusing! Go read the SVG Spec!
			 */
			
			BOOL generateAnSVGDocument = FALSE;
			BOOL overwriteRootSVGDocument = FALSE;
			BOOL overwriteRootOfTree = FALSE;
			
			if( parentStackItem == nil )
			{
				/** This start element is the first item in the document
				 PS: xcode has a new bug for Lion: it can't format single-line comments with two asterisks. This line added because Xcode sucks.
				 */
				generateAnSVGDocument = overwriteRootSVGDocument = overwriteRootOfTree = TRUE;
				
			}
			else if( parseResult.rootOfSVGTree == nil )
			{
				/** It's not the first XML, but it's the first SVG node */
				overwriteRootOfTree = TRUE;
			}
			else
			{
				/** It's not the first SVG node */
				generateAnSVGDocument = TRUE;
			}
			
			/**
			 Handle the complex stuff above about SVGDocument and SVG node
			 */
			if( overwriteRootOfTree )
			{
				parseResult.rootOfSVGTree = (SVGSVGElement*) element;
			}
			if( generateAnSVGDocument )
			{
				SVGDocument* newDocument = [[[SVGDocument alloc] init] autorelease];
				newDocument.rootElement = (SVGSVGElement*) element;
				
				if( overwriteRootSVGDocument )
				{
					parseResult.parsedDocument = newDocument;
				}
				else
				{
					NSAssert( FALSE, @"Currently not supported: multiple SVG nodes (ie secondary Document reference) inside one file" );
				}
			}
			
		}
		
		
		return element;
	}
	
	return nil;
}

-(BOOL) createdItemShouldStoreContent:(NSObject*) item
{
	if( [item isKindOfClass:[SVGElement class]] )
	{
		if ([[item class] shouldStoreContent]) {
			return TRUE;
		}
		else {
			return FALSE;
		}
	}
	else
		return false;
}

-(void) addChildObject:(NSObject*)child toObject:(NSObject*)parent parseResult:(SVGKParseResult *)parseResult parentStackItem:(SVGKParserStackItem *)parentStackItem
{
	SVGElement *parentElement = (SVGElement*) parent;
	
	if( [child isKindOfClass:[SVGElement class]] )
	{
		SVGElement *childElement = (SVGElement*) child;
		
		if ( parent != nil )
		{
			[parentElement addChild:childElement];			
		}
	}
	else
	{
		/*!
		 Unknown tag
		 */
		
		NSAssert( FALSE, @"Asked to add unrecognized child tag of type = %@ to parent = %@", [child class], parent );
	}
}

-(void) parseContent:(NSMutableString*) content forItem:(NSObject*) item
{
	SVGElement* element = (SVGElement*) item;
	
	[element parseContent:content];
}

@end

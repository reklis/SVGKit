//
//  SVGElement.m
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGElement.h"

#import "SVGElement_ForParser.h" //.h" // to solve insane Xcode circular dependencies

@interface SVGElement ()

@property (nonatomic, copy) NSString *stringValue;

@end

/*! main class implementation for the base SVGElement: NOTE: in practice, most of the interesting
 stuff happens in subclasses, e.g.:
 
 SVGShapeElement
 SVGGroupElement
 SVGKImageElement
 SVGLineElement
 SVGPathElement
 ...etc
 */
@implementation SVGElement

@synthesize identifier = _identifier;
@synthesize xmlbase;
@synthesize ownerSVGElement;
@synthesize viewportElement;

@synthesize stringValue = _stringValue;

@synthesize transformRelative = _transformRelative;



+ (BOOL)shouldStoreContent {
	return NO;
}

/*! As per the SVG Spec, the local reference to "viewportElement" depends on the values of the
 attributes of the node - does it have a "width" attribute? */
-(void) reCalculateAndSetViewportElementReference
{
	if( [self.attributes getNamedItem:@"width"] != nil )
		self.viewportElement =  self;
	else
		self.viewportElement = ((SVGElement*) self.parentNode).viewportElement;
}

/*! Override so that we can automatically set / unset the ownerSVGElement and viewportElement properties,
 as required by SVG Spec */
-(void)setParentNode:(Node *)newParent
{
	[super setParentNode:newParent];
	
	/** SVG Spec: if "outermost SVG tag" then both element refs should be nil */
	if( [self isKindOfClass:[SVGSVGElement class]]
	&& (self.parentNode == nil || ! [self.parentNode isKindOfClass:[SVGElement class]]) )
	{
		self.ownerSVGElement = nil;
		self.viewportElement = nil;
	}
	else
	{
		NSAssert( [self.localName isEqualToString:@"svg"] || [newParent isKindOfClass:[SVGElement class]], @"All SVG nodes must have SVGElement superclasses, unless they are an embedded SVG root node, with tag = SVG" );
		
		if( [self isKindOfClass:[SVGSVGElement class]] )
			self.ownerSVGElement = (SVGSVGElement*) self;
		else
			self.ownerSVGElement = ((SVGElement*) newParent).ownerSVGElement;
		
		[self reCalculateAndSetViewportElementReference];
	}
}

/*! Override so that we can automatically set / unset the viewportElement property,
 as required by SVG Spec */
-(void)setAttributes:(NamedNodeMap *)attributes
{
	[super setAttributes:attributes];
	
	[self reCalculateAndSetViewportElementReference];
}

/*! Override so that we can automatically set / unset the viewportElement property,
 as required by SVG Spec */

-(void) setAttribute:(NSString*) name value:(NSString*) value
{
	[super setAttribute:name value:value];
	
	[self reCalculateAndSetViewportElementReference];
}
-(void) removeAttribute:(NSString*) name
{
	[super removeAttribute:name];
	
	[self reCalculateAndSetViewportElementReference];
}
-(Attr*) setAttributeNode:(Attr*) newAttr
{
	Attr* a = [super setAttributeNode:newAttr];
	
	[self reCalculateAndSetViewportElementReference];
	
	return a;
}
-(Attr*) removeAttributeNode:(Attr*) oldAttr
{
	Attr* a = [super removeAttributeNode:oldAttr];
	
	[self reCalculateAndSetViewportElementReference];
	
	return a;
}


- (id)init {
    self = [super initType:SKNodeType_ELEMENT_NODE];
    if (self) {
		[self loadDefaults];
		self.transformRelative = CGAffineTransformIdentity;
    }
    return self;
}

- (id)initWithName:(NSString *)name {
	self = [super initElement:name];
	if (self) {
		self.transformRelative = CGAffineTransformIdentity;
	}
	return self;
}

- (void)dealloc {
	[_stringValue release];
	[_identifier release];
	
	[super dealloc];
}

- (void)loadDefaults {
	// to be overriden by subclasses
}

- (void)parseAttributes:(NSDictionary *)attributes parseResult:(SVGKParseResult *)parseResult  {
	// to be overriden by subclasses
	// make sure super implementation is called
	
	id value = nil;
	
	if ((value = [attributes objectForKey:@"id"])) {
		_identifier = [value copy];
	}
	

	/**
	 http://www.w3.org/TR/SVG/coords.html#TransformAttribute
	 
	 The available types of transform definitions include:
	 
	 * matrix(<a> <b> <c> <d> <e> <f>), which specifies a transformation in the form of a transformation matrix of six values. matrix(a,b,c,d,e,f) is equivalent to applying the transformation matrix [a b c d e f].
	 
	 * translate(<tx> [<ty>]), which specifies a translation by tx and ty. If <ty> is not provided, it is assumed to be zero.
	 
	 * scale(<sx> [<sy>]), which specifies a scale operation by sx and sy. If <sy> is not provided, it is assumed to be equal to <sx>.
	 
	 * rotate(<rotate-angle> [<cx> <cy>]), which specifies a rotation by <rotate-angle> degrees about a given point.
	 If optional parameters <cx> and <cy> are not supplied, the rotate is about the origin of the current user coordinate system. The operation corresponds to the matrix [cos(a) sin(a) -sin(a) cos(a) 0 0].
	 If optional parameters <cx> and <cy> are supplied, the rotate is about the point (cx, cy). The operation represents the equivalent of the following specification: translate(<cx>, <cy>) rotate(<rotate-angle>) translate(-<cx>, -<cy>).
	 
	 * skewX(<skew-angle>), which specifies a skew transformation along the x-axis.
	 
	 * skewY(<skew-angle>), which specifies a skew transformation along the y-axis.
	 */
	if( (value = [attributes objectForKey:@"transform"]) )
	{
		/**
		 http://www.w3.org/TR/SVG/coords.html#TransformAttribute
		 
		 The individual transform definitions are separated by whitespace and/or a comma. 
		 */
		
#if !(TARGET_OS_IPHONE) && ( !defined( __MAC_10_7 ) || __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_6_7 )
		NSLog(@"[%@] WARNING: the transform attribute requires OS X 10.7 or above (we need Regular Expressions! Apple was slow to add them :( ). Ignoring TRANSFORMs in SVG!", [self class] );
#else
		NSError* error = nil;
		NSRegularExpression* regexpTransformListItem = [NSRegularExpression regularExpressionWithPattern:@"[^\\(,]*\\([^\\)]*\\)" options:0 error:&error];
		
		[regexpTransformListItem enumerateMatchesInString:value options:0 range:NSMakeRange(0, [value length]) usingBlock:
		 ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
		{
			NSString* transformString = [value substringWithRange:[result range]];
			
			NSRange loc = [transformString rangeOfString:@"("];
			if( loc.length == 0 )
			{
				NSLog(@"[%@] ERROR: input file is illegal, has an item in the SVG transform attribute which has no open-bracket. Item = %@, transform attribute value = %@", [self class], transformString, value );
				return;
			}
			NSString* command = [transformString substringToIndex:loc.location];
			NSArray* parameterStrings = [[transformString substringFromIndex:loc.location+1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
			
			if( [command isEqualToString:@"translate"] )
			{
				CGFloat xtrans = [(NSString*)[parameterStrings objectAtIndex:0] floatValue];
				CGFloat ytrans = [parameterStrings count] > 1 ? [(NSString*)[parameterStrings objectAtIndex:1] floatValue] : 0.0;
				
				CGAffineTransform nt = CGAffineTransformMakeTranslation(xtrans, ytrans);
				self.transformRelative = CGAffineTransformConcat( self.transformRelative, nt );
				
			}
			else if( [command isEqualToString:@"scale"] )
			{
				NSArray *scaleStrings = [[parameterStrings objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				
				CGFloat xScale = [(NSString*)[scaleStrings objectAtIndex:0] floatValue];
				CGFloat yScale = [scaleStrings count] > 1 ? [(NSString*)[scaleStrings objectAtIndex:1] floatValue] : xScale;
				
				CGAffineTransform nt = CGAffineTransformMakeScale(xScale, yScale);
				self.transformRelative = CGAffineTransformConcat( self.transformRelative, nt );
			}
			else if( [command isEqualToString:@"matrix"] )
			{
				CGFloat a = [(NSString*)[parameterStrings objectAtIndex:0] floatValue];
				CGFloat b = [(NSString*)[parameterStrings objectAtIndex:1] floatValue];
				CGFloat c = [(NSString*)[parameterStrings objectAtIndex:2] floatValue];
				CGFloat d = [(NSString*)[parameterStrings objectAtIndex:3] floatValue];
				CGFloat tx = [(NSString*)[parameterStrings objectAtIndex:4] floatValue];
				CGFloat ty = [(NSString*)[parameterStrings objectAtIndex:5] floatValue];
				
				CGAffineTransform nt = CGAffineTransformMake(a, b, c, d, tx, ty );
				self.transformRelative = CGAffineTransformConcat( self.transformRelative, nt );
				
			}
			else if( [command isEqualToString:@"rotate"] )
			{
				/**
				 This section merged from warpflyght's commit:
				 
				 https://github.com/warpflyght/SVGKit/commit/c1bd9b3d0607635dda14ec03579793fc682763d9
				 
				 */
				NSArray *rotateStrings = [[parameterStrings objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				if( [rotateStrings count] == 1)
				{
					CGFloat degrees = [[rotateStrings objectAtIndex:0] floatValue];
					CGFloat radians = degrees * M_PI / 180.0;
					
					CGAffineTransform nt = CGAffineTransformMakeRotation(radians);
					self.transformRelative = CGAffineTransformConcat( self.transformRelative, nt );
				}
				else if( [rotateStrings count] == 3)
				{
					CGFloat degrees = [[rotateStrings objectAtIndex:0] floatValue];
					CGFloat radians = degrees * M_PI / 180.0;
					CGFloat centerX = [[rotateStrings objectAtIndex:1] floatValue];
					CGFloat centerY = [[rotateStrings objectAtIndex:2] floatValue];
					CGAffineTransform nt = CGAffineTransformIdentity;
					nt = CGAffineTransformConcat( nt, CGAffineTransformMakeTranslation(centerX, centerY) );
					nt = CGAffineTransformConcat( nt, CGAffineTransformMakeRotation(radians) );
					nt = CGAffineTransformConcat( nt, CGAffineTransformMakeTranslation(-1.0 * centerX, -1.0 * centerY) );
					self.transformRelative = CGAffineTransformConcat( self.transformRelative, nt );
					} else
					{
					NSLog(@"[%@] ERROR: input file is illegal, has an SVG matrix transform attribute without the required 1 or 3 parameters. Item = %@, transform attribute value = %@", [self class], transformString, value );
					return;
				}
			}
			else if( [command isEqualToString:@"skewX"] )
			{
				NSLog(@"[%@] ERROR: skew is unsupported: %@", [self class], command );
				
				[parseResult addParseErrorRecoverable: [NSError errorWithDomain:@"SVGKit" code:15184 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																			   @"transform=skewX is unsupported", NSLocalizedDescriptionKey,
																			   nil]
						]];
			}
			else if( [command isEqualToString:@"skewY"] )
			{
				NSLog(@"[%@] ERROR: skew is unsupported: %@", [self class], command );
				[parseResult addParseErrorRecoverable: [NSError errorWithDomain:@"SVGKit" code:15184 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																			   @"transform=skewY is unsupported", NSLocalizedDescriptionKey,
																			   nil]
						]];
			}
			else
			{
				NSAssert( FALSE, @"Not implemented yet: transform = %@ %@", command, transformString );
			}
		}];
		
		NSLog(@"[%@] Set local / relative transform = (%2.2f, %2.2f // %2.2f, %2.2f) + (%2.2f, %2.2f translate)", [self class], self.transformRelative.a, self.transformRelative.b, self.transformRelative.c, self.transformRelative.d, self.transformRelative.tx, self.transformRelative.ty );
#endif
	}

}

/*! implemented making heavy use of the self.viewportElement to optimize performance - I believe this is what the
 SVG Spec authors intended
 
 FIXME: this method could be removed by cut/pasting the code below directly into SVGKImage and its CALayer generation
 code. Previously, this method recursed through the whole tree, but now that it's using the self.viewportElement property
 it's a bit simpler.
 */
-(CGAffineTransform) transformAbsolute
{
	if( self.viewportElement == nil )
		return self.transformRelative;
	else
	{
		/**
		 If this node altered the viewport, then the "inherited" info is whatever its parent had.
		 
		 Otherwise, its whatever the pre-saved self.viewportElement is using.
		 
		 NB: this is an optimization that is built-in to the SVG spec; previous implementation in SVGKit
		 recursed up the entire tree of SVGElement's, even though most SVGElement's are NOT ALLOWED to
		 redefine the viewport
		 */
		if( self.viewportElement == self )
		{
			return CGAffineTransformConcat( self.transformRelative, ((SVGElement*) self.parentNode).viewportElement.transformAbsolute );
		}
		else
			return [self.viewportElement transformAbsolute];
	}
}

- (void)parseContent:(NSString *)content {
	self.stringValue = content;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ %p | id=%@ | localName=%@ | stringValue=%@ | children=%d>", 
			[self class], self, _identifier, self.localName, _stringValue, self.childNodes.length];
}

@end

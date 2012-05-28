#import "SVGKImage.h"

#import "SVGDefsElement.h"
#import "SVGDescriptionElement.h"
#import "SVGKParser.h"
#import "SVGTitleElement.h"
#import "SVGPathElement.h"

#import "SVGKParserSVG.h"

@interface SVGKImage ()

@property (nonatomic, readwrite) SVGLength svgWidth;
@property (nonatomic, readwrite) SVGLength svgHeight;
@property (nonatomic, retain, readwrite) SVGKParseResult* parseErrorsAndWarnings;

@property (nonatomic, retain, readwrite) SVGKSource* source;

@property (nonatomic, retain, readwrite) SVGSVGElement* DOMTree; // needs renaming + (possibly) refactoring
@property (nonatomic, retain, readwrite) CALayer* CALayerTree;

#pragma mark - UIImage methods cloned and re-implemented as SVG intelligent methods
//NOT DEFINED: what is the scale for a SVGKImage? @property(nonatomic,readwrite) CGFloat            scale __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

@end

#pragma mark - main class
@implementation SVGKImage

@synthesize DOMTree, CALayerTree;

@synthesize svgWidth = _width;
@synthesize svgHeight = _height;
@synthesize source;
@synthesize parseErrorsAndWarnings;

+ (SVGKImage *)imageNamed:(NSString *)name {
	NSParameterAssert(name != nil);
	
	NSBundle *bundle = [NSBundle mainBundle];
	
	if (!bundle)
		return nil;
	
	NSString *newName = [name stringByDeletingPathExtension];
	NSString *extension = [name pathExtension];
    if ([@"" isEqualToString:extension]) {
        extension = @"svg";
    }
	
	NSString *path = [bundle pathForResource:newName ofType:extension];
	
	if (!path)
	{
		NSLog(@"[%@] MISSING FILE, COULD NOT CREATE DOCUMENT: filename = %@, extension = %@", [self class], newName, extension);
		return nil;
	}
	
	return [self imageWithContentsOfFile:path];
}

+ (SVGKImage*) imageWithContentsOfURL:(NSURL *)url {
	NSParameterAssert(url != nil);
	
	return [[[[self class] alloc] initWithContentsOfURL:url] autorelease];
}

+ (SVGKImage*) imageWithContentsOfFile:(NSString *)aPath {
	return [[[[self class] alloc] initWithContentsOfFile:aPath] autorelease];
}

- (id)initWithSource:(SVGKSource *)source {
	self = [super init];
	if (self) {
		self.svgWidth = SVGLengthZero;
		self.svgHeight = SVGLengthZero;
		self.source = source;
		
		self.parseErrorsAndWarnings = [SVGKParser parseSourceUsingDefaultSVGKParser:self.source];
		
		if( parseErrorsAndWarnings.rootOfSVGTree != nil )
			self.DOMTree = (SVGSVGElement*) parseErrorsAndWarnings.rootOfSVGTree;
		else
			self.DOMTree = nil;
		
		if ( self.DOMTree == nil )
		{
			NSLog(@"[%@] ERROR: failed to init SVGKImage with source = %@, returning nil from init methods", [self class], source );
			self = nil;
		}
		else
		{
			self.svgWidth = self.DOMTree.documentWidth;
			self.svgHeight = self.DOMTree.documentHeight;
		}
	}
	return self;
}

- (id)initWithContentsOfFile:(NSString *)aPath {
	NSParameterAssert(aPath != nil);
	
	return [self initWithSource:[SVGKSource sourceFromFilename:aPath]];
}

- (id)initWithContentsOfURL:(NSURL *)url {
	NSParameterAssert(url != nil);
	
	return [self initWithSource:[SVGKSource sourceFromURL:url]];
}

- (void)dealloc {
	self.DOMTree = nil;
	self.CALayerTree = nil;
	self.source = nil;
	self.parseErrorsAndWarnings = nil;
	[super dealloc];
}

//TODO mac alternatives to UIKit functions

#if TARGET_OS_IPHONE
+ (UIImage *)imageWithData:(NSData *)data
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}
#endif

- (id)initWithData:(NSData *)data
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}

#pragma mark - UIImage methods we reproduce to make it act like a UIImage

-(CGSize)size
{
	return CGSizeMake( SVGLengthAsApplePoints(self.svgWidth), SVGLengthAsApplePoints(self.svgHeight));
}

-(CGFloat)scale
{
	NSAssert( FALSE, @"image.scale is currently UNDEFINED for an SVGKImage (nothing implemented by SVGKit)" );
	return 0.0;
}

#if TARGET_OS_IPHONE
-(UIImage *)UIImage
{
	NSAssert( FALSE, @"Auto-converting SVGKImage to a rasterized UIImage is not yet implemented by SVGKit" );
	return nil;
}
#endif

// the these draw the image 'right side up' in the usual coordinate system with 'point' being the top-left.

- (void)drawAtPoint:(CGPoint)point                                                        // mode = kCGBlendModeNormal, alpha = 1.0
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}

#pragma mark - unsupported / unimplemented UIImage methods (should add as a feature)
- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}
- (void)drawInRect:(CGRect)rect                                                           // mode = kCGBlendModeNormal, alpha = 1.0
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}
 - (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}

- (void)drawAsPatternInRect:(CGRect)rect // draws the image as a CGPattern
// animated images. When set as UIImageView.image, animation will play in an infinite loop until removed. Drawing will render the first image
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}

#if TARGET_OS_IPHONE
+ (UIImage *)animatedImageNamed:(NSString *)name duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0)  // read sequnce of files with suffix starting at 0 or 1
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}
+ (UIImage *)animatedResizableImageNamed:(NSString *)name capInsets:(UIEdgeInsets)capInsets duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) // squence of files
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}
+ (UIImage *)animatedImageWithImages:(NSArray *)images duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0)
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}
#endif

#pragma mark - CALayer methods: generate the CALayerTree

- (CALayer *)layerWithIdentifier:(NSString *)identifier
{
	return [self layerWithIdentifier:identifier layer:self.CALayerTree];
}

- (CALayer *)layerWithIdentifier:(NSString *)identifier layer:(CALayer *)layer {
	
	if ([[layer valueForKey:kSVGElementIdentifier] isEqualToString:identifier]) {
		return layer;
	}
	
	for (CALayer *child in layer.sublayers) {
		CALayer *resultingLayer = [self layerWithIdentifier:identifier layer:child];
		
		if (resultingLayer)
			return resultingLayer;
	}
	
	return nil;
}

- (CALayer *)newLayerWithElement:(SVGElement <SVGLayeredElement> *)element preTransform:(CGAffineTransform) preTransform {
	CALayer *layer = [element newLayerPreTransformed:preTransform];
	
	NSLog(@"[%@] DEBUG: converted SVG element (class:%@) to CALayer (class:%@) for id = %@", [self class], NSStringFromClass([element class]), NSStringFromClass([layer class]), element.identifier);
	
	if (![element.children count]) {
		return layer;
	}
	
	for (SVGElement *child in element.children) {
		if ([child conformsToProtocol:@protocol(SVGLayeredElement)]) {
			CALayer *sublayer = [self newLayerWithElement:(id<SVGLayeredElement>)child preTransform:preTransform];
			
			if (!sublayer) {
				continue;
            }
			
			[layer addSublayer:sublayer];
		}
	}
	
	if (element != self.DOMTree) {
		[element layoutLayer:layer];
	}
	
    [layer setNeedsDisplay];
	
	return layer;
}

-(CALayer *)newLayerTree
{
	if( self.DOMTree == nil )
		return nil;
	else
	{
		CGAffineTransform preTransform = CGAffineTransformIdentity;
		
		// TODO: calc the correct transform!
		CGRect frameViewBox = self.DOMTree.viewBoxFrame;
		CGRect frameImage = CGRectMake(0,0, SVGLengthAsPixels( self.DOMTree.documentWidth), SVGLengthAsPixels( self.DOMTree.documentHeight ) );
		
		if( ! CGRectIsEmpty( frameViewBox ) )
			preTransform = CGAffineTransformMakeScale( frameImage.size.width / frameViewBox.size.width, frameImage.size.height / frameViewBox.size.height);
		
		return [self newLayerWithElement:self.DOMTree preTransform:preTransform];
	}
}

-(CALayer *)CALayerTree
{
	if( CALayerTree == nil )
	{
		self.CALayerTree = [[self newLayerTree] autorelease];
	}
	
	return CALayerTree;
}


- (void) addSVGLayerTree:(CALayer*) layer withIdentifier:(NSString*) layerID toDictionary:(NSMutableDictionary*) layersByID
{
	// TODO: consider removing this method: it caches the lookup of individual items in the CALayerTree. It's a performance boost, but is it enough to be worthwhile?
	[layersByID setValue:layer forKey:layerID];
	
	if ( [layer.sublayers count] < 1 )
	{
		return;
	}
	
	for (CALayer *subLayer in layer.sublayers)
	{
		NSString* subLayerID = [subLayer valueForKey:kSVGElementIdentifier];
		
		if( subLayerID != nil )
		{
			NSLog(@"[%@] element id: %@ => layer: %@", [self class], subLayerID, subLayer);
			
			[self addSVGLayerTree:subLayer withIdentifier:subLayerID toDictionary:layersByID];
			
		}
	}
}

- (NSDictionary*) dictionaryOfLayers
{
	// TODO: consider removing this method: it caches the lookup of individual items in the CALayerTree. It's a performance boost, but is it enough to be worthwhile?
	NSMutableDictionary* layersByElementId = [NSMutableDictionary dictionary];
	
	CALayer* rootLayer = self.CALayerTree;
	
	[self addSVGLayerTree:rootLayer withIdentifier:self.DOMTree.identifier toDictionary:layersByElementId];
	
	NSLog(@"[%@] ROOT element id: %@ => layer: %@", [self class], self.DOMTree.identifier, rootLayer);
	
    return layersByElementId;
}

@end


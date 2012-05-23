/*
 SVGImage
 
 The main class in SVGKit - this is the one you'll normally interact with
 
 An SVGImage is as close to "the SVG version of a UIImage" as we could possibly get. We cannot
 subclass UIImage because Apple has defined UIImage as immutable - and SVG images actually change
 (each time you zoom in, we want to re-render the SVG as a higher-resolution set of pixels)
 
 We use the exact same method names as UIImage, and try to be literally as identical as possible.
 
 Data:
  - uiImage: not supported yet: will be a cached UIImage that is re-generated on demand. Will enable us to implement an SVGImageView
 that works as a drop-in replacement for UIImageView
  - size: as per the UIImage.size, returns a size in Apple Points (i.e. 320 == width of iPhone, irrespective of Retina)
  - scale: ??? unknown how we'll define this, but could be useful when doing auto-re-render-on-zoom
  - svgWidth: the internal SVGLength used to generate the correct .size
  - svgHeight: the internal SVGLength used to generate the correct .size
  - rootElement: the SVGSVGElement instance that is the root of the parse SVG tree. Use this to access the full SVG document
  - svgDescription: ???
  - title: ???
  - defs: the root <svg:defs> element
 
 */

#import "SKBasicDataTypes.h"
#import "SVGElement.h"
#import "SVGSVGElement.h"
#import "SVGGroupElement.h"

#import "SKParser.h"
#import "SVGSource.h"

@class SVGDefsElement;

@interface SVGImage : NSObject // doesn't extend UIImage because Apple made UIImage immutable
{
}

#if TARGET_OS_IPHONE
@property (nonatomic, readonly) UIImage* UIImage; /** generates an image on the fly */
#endif

@property (nonatomic, readonly) SVGLength svgWidth;
@property (nonatomic, readonly) SVGLength svgHeight;
@property (nonatomic, readonly) SVGSource* source;
@property (nonatomic, readonly) SVGParseResult* parseErrorsAndWarnings;

// convenience accessors to parsed children
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *svgDescription; // 'description' is reserved by NSObject
@property (nonatomic, readonly) SVGDefsElement *defs; // needs renaming + (possibly) refactoring

@property (nonatomic, retain, readonly) SVGSVGElement* DOMTree;
@property (nonatomic, retain, readonly) CALayer* CALayerTree;


#pragma mark - methods to quick load an SVG as an image
+ (SVGImage *)imageNamed:(NSString *)name;      // load from main bundle
+ (SVGImage *)imageWithContentsOfFile:(NSString *)path;
#if TARGET_OS_IPHONE // doesn't exist on OS X's Image class
+ (SVGImage *)imageWithData:(NSData *)data;
#endif

- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithData:(NSData *)data;

#pragma mark - UIImage methods cloned and re-implemented as SVG intelligent methods
@property(nonatomic,readonly) CGSize             size;             // reflects orientation setting. size is in pixels
@property(nonatomic,readonly) CGFloat            scale __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

/**
 
 TODO: From UIImage. Not needed, I think?
 
 @property(nonatomic,readonly) CIImage           *CIImage __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0); // returns underlying CIImage or nil if CGImageRef based
*/

// the these draw the image 'right side up' in the usual coordinate system with 'point' being the top-left.

- (void)drawAtPoint:(CGPoint)point;                                                        // mode = kCGBlendModeNormal, alpha = 1.0

#pragma mark - unsupported / unimplemented UIImage methods (should add as a feature)
- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)drawInRect:(CGRect)rect;                                                           // mode = kCGBlendModeNormal, alpha = 1.0
- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

- (void)drawAsPatternInRect:(CGRect)rect; // draws the image as a CGPattern
// animated images. When set as UIImageView.image, animation will play in an infinite loop until removed. Drawing will render the first image
#if TARGET_OS_IPHONE




+ (UIImage *)animatedImageNamed:(NSString *)name duration:(NSTimeInterval)duration ;//__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0); read sequnce of files with suffix starting at 0 or 1
+ (UIImage *)animatedResizableImageNamed:(NSString *)name capInsets:(UIEdgeInsets)capInsets duration:(NSTimeInterval)duration ;//__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0); // squence of files
+ (UIImage *)animatedImageWithImages:(NSArray *)images duration:(NSTimeInterval)duration ;//__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);

#endif
/**
 
 TODO: From UIImage. Not needed, I think?

@property(nonatomic,readonly) NSArray       *images   __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0); // default is nil for non-animated images
@property(nonatomic,readonly) NSTimeInterval duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0); // total duration for all frames. default is 0 for non-animated images
 */
#pragma mark ---------end of unsupported items

+ (id)documentFromURL:(NSURL *)url;

- (id)initWithContentsOfFile:(NSString *)aPath;
- (id)initWithFrame:(CGRect)frame;

#pragma mark - core methods for interacting with an SVG image usefully (not from UIImage)

@end
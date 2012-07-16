/**
 SVGElement
 
 http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-1950641247

 NB: "id" is illegal in Objective-C language, so we use "identifier" instead
 
 
 + NON STANDARD: "transformRelative": identity OR the transform to apply BEFORE rendering this element (and its children)
 
 */
#import <QuartzCore/QuartzCore.h>

#import "Element.h"
#import "Node+Mutable.h"

@class SVGSVGElement;
//obj-c's compiler sucks, and doesn't allow this line: #import "SVGSVGElement.h"

@interface SVGElement : Element

@property (nonatomic, readwrite, retain) NSString *identifier; // 'id' is reserved in Obj-C, so we have to break SVG Spec here, slightly
@property (nonatomic, retain) NSString* xmlbase;
@property (nonatomic, retain) SVGSVGElement* ownerSVGElement;

/*! The viewport is set / re-set whenever an SVG node specifies a "width" (and optionally: a "height") attribute,
 assuming that SVG node is one of: svg, symbol, image, foreignobject */
@property (nonatomic, retain) SVGElement* viewportElement;


#pragma mark - NON-STANDARD features of class (these are things that are NOT in the SVG spec, and should NOT be in SVGKit)

/*! This is used when generating CALayer objects, to store the id of the SVGElement that created the CALayer */
#define kSVGElementIdentifier @"SVGElementIdentifier"

@property (nonatomic, readonly, copy) NSString *stringValue;

/*! Transform to be applied to this node and all sub-nodes; does NOT take account of any transforms applied by parent / ancestor nodes */
@property (nonatomic) CGAffineTransform transformRelative;

- (void)parseContent:(NSString *)content;


@end
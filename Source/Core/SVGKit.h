/*!
 
 SVGKit - https://github.com/SVGKit/SVGKit
 
 THE MOST IMPORTANT ELEMENTS YOU'LL INTERACT WITH:
 
 1. SVGKImage = contains most of the convenience methods for loading / reading / displaying SVG files
 
 SVGKImage makes heavy use of the following classes - you'll often use these classes (most of them given to you by an SVGKImage):
 
 2. SVGKSource = the "file" or "URL" for loading the SVG data
 3. SVGKParseResult = contains the parsed SVG file AND/OR the list of errors during parsing
 4. SVGSVGElement = the parsed SVG file, stored as a tree of SVGElement's. The root element is an SVGSVGElement
 5. SVGDocument = OPTIONAL: only exists for *SOME* SVG FILES (it's very confusing - c.f. the official SVG spec!)
 
 NB: previous versions of SVGKit assumed that "every SVG file has an SVGDocument". This is not true, the spec
 specifically states otherwise. In practice, most SVG files you encounter have an SVGDocument - but some have more than
 one! And others have zero! So ... VERY LITTLE of SVGKit relies upon having an SVGDocument, we try to avoid using
 it where possible.
 
 */

#include "TargetConditionals.h"

#if TARGET_OS_IPHONE
	#import "SVGCircleElement.h"
	#import "SVGDefsElement.h"
	#import "SVGDescriptionElement.h"
	#import "SVGKImage.h"
	#import "SVGElement.h"
	#import "SVGEllipseElement.h"
	#import "SVGGroupElement.h"
    #import "SVGImageElement.h"
	#import "SVGLineElement.h"
	#import "SVGPathElement.h"
	#import "SVGPolygonElement.h"
	#import "SVGPolylineElement.h"
	#import "SVGRectElement.h"
	#import "SVGShapeElement.h"
	#import "SVGKSource.h"
	#import "SVGTitleElement.h"
	#import "SVGUtils.h"
	#import "SVGKView.h"
    #import "SVGPathView.h"
    #import "SVGKPattern.h"
	#import "SVGKImageView.h"
#else
	#import <SVGKit/SVGCircleElement.h>
	#import <SVGKit/SVGDefsElement.h>
	#import <SVGKit/SVGDescriptionElement.h>
	#import <SVGKit/SVGKSource.h>
	#import <SVGKit/SVGKSource+CA.h>
	#import <SVGKit/SVGElement.h>
	#import <SVGKit/SVGEllipseElement.h>
	#import <SVGKit/SVGGroupElement.h>
    #import <SVGKit/SVGKImageElement.h>
	#import <SVGKit/SVGLineElement.h>
	#import <SVGKit/SVGPathElement.h>
	#import <SVGKit/SVGPolygonElement.h>
	#import <SVGKit/SVGPolylineElement.h>
	#import <SVGKit/SVGRectElement.h>
	#import <SVGKit/SVGShapeElement.h>
	#import <SVGKit/SVGTitleElement.h>
	#import <SVGKit/SVGUtils.h>
	#import <SVGKit/SVGView.h>
#endif

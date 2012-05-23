/**
 SVGPathView
 
 NB: currently disabled, needs minor updating, but we don't have unit tests to check the changes still work
 
 Purpose: load an SVG full of paths, then be able to select a path and peel that off into a new view. 
 
 
 SVGPathView works nicely for that one purpose, it re-orients the path from a document such that it can be displayed properly on it's lonesome rather than whatever other world coords it used to be.
 */

#import <Foundation/Foundation.h>
#import <QuartzCore/CAShapeLayer.h>

#import "SKSvgView.h"

#define ENABLE_SVGPATHVIEW_CLASS 0

#if ENABLE_SVGPATHVIEW_CLASS

#if NS_BLOCKS_AVAILABLE

typedef void (^layerTreeEnumerator)(CALayer* child);

#endif

@class SVGPathElement;

@protocol SVGPathViewDelegate;

@interface SVGPathView : SKSvgView
{
    
}

/** Initializes the view with a copy of the path element selected.
 @param pathElement a path element either manually created or extracted from another document
 @param shouldTranslate if YES, will translate the path existing in the other document to match toward the origin so that the drawing will have an origin at 0,0 rather than where it was in the original document
 */
- (id)initWithPathElement:(SVGPathElement*)pathElement translateTowardOrigin:(BOOL)shouldTranslate;

- (CAShapeLayer*) pathElementLayer;

@property (readwrite,nonatomic,assign) id<SVGPathViewDelegate> delegate;
@property (readonly) SVGPathElement* pathElement;

#if NS_BLOCKS_AVAILABLE

- (void) enumerateChildLayersUsingBlock:(layerTreeEnumerator)callback;

#endif


@end


@protocol SVGPathViewDelegate <NSObject>

@optional

- (void) pathView:(SVGPathView*)v path:(SVGPathElement*)path touch:(UITouch*)touch;

@end

#endif
#import <Foundation/Foundation.h>

#import "SVGKit.h"

/**
 * ADAM: SVGKit's version of UIImageView - with some improvements over Apple's design
 
 Basic usage:
  - as per UIImageView, simpy:
  - SVGKImageView *skv = [[SVGKImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"image.svg"]];
  - [self.view addSubview: skv];
 
 Advanced usage:
  - to make the contents shrink to half their actual size, and tile to fill, set self.tileRatio = CGSizeMake( 2.0f, 2.0f );
     NOTE: I'd prefer to do this view UIViewContentMode, but Apple didn't make it extensible
  - to disable tiling completely (might help with draw performance), set self.tileRatio = CGSizeZero
 
 Performance:
  - NOTE: the way this works - calling Apple's renderInContext: method - MAY BE artificially slow, because of Apple's implementation
  - NOTE: you MUST NOT call SVGKImage.CALayerTree.transform - that will have unexpected side-effects, because of Apple's implementation
     (hence: we currently use renderInContext:, even though we'd prefer not to :( )
 */
@interface SVGKImageView : UIView

@property(nonatomic,retain) SVGKImage* image;
@property(nonatomic) CGSize tileRatio;
@property(nonatomic) BOOL disableAutoRedrawAtHighestResolution;
@property(nonatomic) BOOL showBorder; /*< mostly for debugging - adds a coloured 1-pixel border around the image */

- (id)initWithSVGKImage:(SVGKImage*) im;

@end

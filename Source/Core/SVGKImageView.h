#import <Foundation/Foundation.h>

#import "SVGKit.h"

/**
 * ADAM: SVGKit's version of UIImageView - with some improvements over Apple's design
 
 Basic usage:
  - as per UIImageView, simpy:
  - SVGKImageView *skv = [[SVGKImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"image.svg"]];
  - [self.view addSubview: skv];
 
 Advanced usage:
  - to make the contents shrink to half their actual size, set self.scaleMultiplier = CGSizeMake( 0.5f, 0.5f );
     NOTE: I'd prefer to do this view UIViewContentMode, but Apple didn't make it extensible
  - to make the contents "tile" to fill the frame of the ImageView, set self.tileContents = TRUE;
 
 Performance:
  - NOTE: the way this works - calling Apple's renderInContext: method - MAY BE artificially slow, because of Apple's implementation
  - NOTE: you MUST NOT call SVGKImage.CALayerTree.transform - that will have unexpected side-effects, because of Apple's implementation
     (hence: we currently use renderInContext:, even though we'd prefer not to :( )
 */
@interface SVGKImageView : UIView

@property(nonatomic,retain) SVGKImage* image;
@property(nonatomic) CGSize scaleMultiplier;
@property(nonatomic) BOOL tileContents;
@property(nonatomic) BOOL disableAutoRedrawAtHighestResolution;

- (id)initWithSVGKImage:(SVGKImage*) im;

@end

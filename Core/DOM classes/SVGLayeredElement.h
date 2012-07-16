#import <Foundation/Foundation.h>
#import <QuartzCore/Quartzcore.h>

@protocol SVGLayeredElement < NSObject >

/*!
 SVG's can be specified in any arbitrary resolution; many on the internet have impossibly huge co-ordinates, e.g. "1 million x 1 million",
 but when you render them, you're expected to scale that co-ord down to your local co-ords - e.g. "1024x768" for an iPad 1 screen. So, when
 generating layers, we provide the transform that will perform that scale (NB: this is the compound transform from all "viewbox / width,height"
 found in higher layers of the tree)
 
 NB: the returned layer has - as its "name" property - the "identifier" property of the SVGElement that created it;
 but that can be overwritten by applications (for valid reasons), so we ADDITIONALLY store the identifier into a
 custom key - kSVGElementIdentifier - on the CALayer. Because it's a custom key, it's (almost) guaranteed not to be
 overwritten / altered by other application code
 */
- (CALayer *) newLayerPreTransformed:(CGAffineTransform) preTransform;
- (void)layoutLayer:(CALayer *)layer;

@end

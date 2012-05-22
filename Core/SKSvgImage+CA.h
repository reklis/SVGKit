
#import "SVGImage.h"
#import <QuartzCore/QuartzCore.h>

@interface SVGImage (CA)

- (CALayer *)layerWithIdentifier:(NSString *)identifier;

/*! One and only one instance ever returned */
- (CALayer *)layerTreeCached;
/*! Creates a new instance each time you call it */
- (CALayer *)newLayerTree;

- (CALayer *)layerWithIdentifier:(NSString *)identifier layer:(CALayer *)layer;

- (CALayer *)newLayerWithElement:(SVGElement < SVGLayeredElement > *)element;

/*! returns all the individual CALayer's in the full layer tree, indexed by the SVG identifier of the SVG node that created that layer */
- (NSDictionary*) dictionaryOfLayers;

@end

#import "SVGKImage+CA.h"

#import <objc/runtime.h>

@implementation SVGKImage (CA)

static const char *kLayerTreeKey = "svgkit.layertree";

- (CALayer *)layerWithIdentifier:(NSString *)identifier {
	return [self layerWithIdentifier:identifier layer:self.layerTreeCached];
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

- (CALayer *)layerTreeCached {
	CALayer *cachedLayerTree = objc_getAssociatedObject(self, (void *) kLayerTreeKey);
	
	if (!cachedLayerTree) {
		cachedLayerTree = [[self newLayerTree] autorelease]; // we're going to associate it using OBJC_ASSOCIATION_RETAIN_NONATOMIC
		objc_setAssociatedObject(self, (void *) kLayerTreeKey, cachedLayerTree, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return cachedLayerTree;
}

-(CALayer *)newLayerTree
{
	return [self newLayerWithElement:self.DOMTree];
}

- (CALayer *)newLayerWithElement:(SVGElement <SVGLayeredElement> *)element {
	CALayer *layer = [element newLayer];
	
	NSLog(@"[%@] DEBUG: converted SVG element (class:%@) to CALayer (class:%@) for id = %@", [self class], NSStringFromClass([element class]), NSStringFromClass([layer class]), element.identifier);
	
	if (![element.children count]) {
		return layer;
	}
	
	for (SVGElement *child in element.children) {
		if ([child conformsToProtocol:@protocol(SVGLayeredElement)]) {
			CALayer *sublayer = [self newLayerWithElement:(id<SVGLayeredElement>)child];

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

- (void) addSVGLayerTree:(CALayer*) layer withIdentifier:(NSString*) layerID toDictionary:(NSMutableDictionary*) layersByID
{
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
	NSMutableDictionary* layersByElementId = [NSMutableDictionary dictionary];
	
	CALayer* rootLayer = [self layerTreeCached];
	
	[self addSVGLayerTree:rootLayer withIdentifier:self.DOMTree.identifier toDictionary:layersByElementId];
	
	NSLog(@"[%@] ROOT element id: %@ => layer: %@", [self class], self.DOMTree.identifier, rootLayer);
	
    return layersByElementId;
}

@end

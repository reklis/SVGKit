#import "SVGKImage+SVGPathView.h"

#import "NodeList+Mutable.h" // needed for access to underlying array, because SVG doesnt support fast enumeration natively

@implementation SVGKImage (SVGPathView)

#if NS_BLOCKS_AVAILABLE

- (void) applyAggregator:(SVGElementAggregationBlock)aggregator toElement:(SVGElement < SVGLayeredElement > *)element
{
	if ( element.childNodes.length < 1 )
	{
		return;
	}
	
	for (SVGElement *child in element.childNodes.internalArray)
	{
		if ([child conformsToProtocol:@protocol(SVGLayeredElement)]) {
			SVGElement<SVGLayeredElement>* layeredElement = (SVGElement<SVGLayeredElement>*)child;
            if (layeredElement) {
                aggregator(layeredElement);
                
                [self applyAggregator:aggregator
                            toElement:layeredElement];
            }
		}
	}
}

- (void) applyAggregator:(SVGElementAggregationBlock)aggregator
{
    [self applyAggregator:aggregator toElement:self.DOMTree];
}

#endif

@end

/**
 SVGDocument
 
 SVG spec defines this as part of the DOM version of SVG:
 
 http://www.w3.org/TR/SVG11/struct.html#InterfaceSVGDocument
 */

#import "SVGDocument.h"

#import "SKBasicDataTypes.h"

@implementation SVGDocument


@property (nonatomic, retain, readonly) NSString* title;
@property (nonatomic, retain, readonly) NSString* referrer;
@property (nonatomic, retain, readonly) NSString* domain;
@property (nonatomic, retain, readonly) NSString* URL;
@property (nonatomic, retain, readonly) SVGSVGElement* rootElement;

@end

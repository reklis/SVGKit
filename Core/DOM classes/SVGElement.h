/**
 SVGElement
 
 This class is WRONG: most of the properties and methods should NOT be implemented here, but instead in the
 superclass "Node".
 
 c.f. official definition of "Node" in SVG:
 http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-1950641247

 
 Documenting the actual data in this class (even though it's incorrect):
  - "children": nb: the correct name would be "childNodes", according to SVG spec ... child elements (SVG is a tree: every element can have chidren)
  - "localName": the final part of the SVG tag (e.g. in "<svg:element", this would be "element")
  - "identifier": the SVG id attribute (e.g. "<svg:svg id="this is the identifier"")
  - "transformRelative": identity OR the transform to apply BEFORE rendering this element (and its children)
  - "parent": the parent node in the SVG tree
 
 */
#import <QuartzCore/QuartzCore.h>


@interface SVGElement : NSObject {
  @private
	NSMutableArray *_children;
}

/*! This is used when generating CALayer objects, to store the id of the SVGElement that created the CALayer */
#define kSVGElementIdentifier @"SVGElementIdentifier"

@property (nonatomic, readonly) NSArray *children;
@property (nonatomic, readonly, copy) NSString *stringValue;
@property (nonatomic, readonly) NSString *localName;

@property (nonatomic, readwrite, retain) NSString *identifier; // 'id' is reserved

@property (nonatomic, retain) NSMutableArray* metadataChildren;

/*! Transform to be applied to this node and all sub-nodes; does NOT take account of any transforms applied by parent / ancestor nodes */
@property (nonatomic) CGAffineTransform transformRelative;
/*! Required by SVG transform and SVG viewbox: you have to be able to query your parent nodes at all times to find out your actual values */
@property (nonatomic, retain) SVGElement *parent;

#pragma mark - ORIGINALLY PACKAGE-PROTECTED
- (void)addChild:(SVGElement *)element;
- (void)parseContent:(NSString *)content;


@end
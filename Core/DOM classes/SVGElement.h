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
- (void)parseAttributes:(NSDictionary *)attributes;
- (void)addChild:(SVGElement *)element;
- (void)parseContent:(NSString *)content;

#pragma mark - Public

+ (BOOL)shouldStoreContent; // to optimize parser, default is NO

- (id)initWithName:(NSString *)name;

- (void)loadDefaults; // should be overriden to set element defaults

/*! Overridden by sub-classes.  Be sure to call [super parseAttributes:attributes]; */
- (void)parseAttributes:(NSDictionary *)attributes;

/*! Re-calculates the absolute transform on-demand by querying parent's absolute transform and appending self's relative transform */
-(CGAffineTransform) transformAbsolute;


@end

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

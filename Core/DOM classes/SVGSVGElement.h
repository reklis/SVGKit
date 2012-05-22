/**
 SVGSVGElement.m
 
 Represents the "<svg/>" tag in an SVG document
 
 Data:
  - documentWidth: the <svg width=""> attribute
  - documentHeight: the <svg height=""> attribute
  - viewBoxFrame: ???
 ...data that might be deprecated / removed in future versions of SVGKit:
  - graphicsGroups: the collection of all <g> tags in the doc that have "id" attributes
  - anonymousGraphicsGroups: the collection of all <g> tags in the doc that DO NOT have "id" attributes
 */

#import "SVGElement.h"

#import "SVGBasicDataTypes.h"

@interface SVGSVGElement : SVGElement < SVGLayeredElement >

@property (nonatomic, readonly) SVGLength documentWidth; // FIXME: maybe can be merged with SVGElement as "boundingBoxWidth" / height ?
@property (nonatomic, readonly) SVGLength documentHeight; // FIXME: maybe can be merged with SVGElement as "boundingBoxWidth" / height ?
@property (nonatomic, readonly) CGRect viewBoxFrame; // FIXME: maybe can be merged with SVGElement ?

/*! from the SVG spec, each "g" tag in the XML is a separate "group of graphics things",
 * this dictionary contains a mapping from "value of id attribute" to "SVGGroupElement"
 *
 * see also: anonymousGraphicsGroups (for groups that have no "id=" attribute)
 */
@property (nonatomic, retain) NSDictionary *graphicsGroups;
/*! from the SVG spec, each "g" tag in the XML is a separate "group of graphics things",
 * this array contains all the groups that had no "id=" attribute
 *
 * see also: graphicsGroups (for groups that have an "id=" attribute)
 */
@property (nonatomic, retain) NSArray *anonymousGraphicsGroups;

- (SVGElement *)findFirstElementOfClass:(Class)class;

@end

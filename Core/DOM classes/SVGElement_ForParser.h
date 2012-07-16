#import "SVGElement.h"

#import "SVGKParseResult.h"

@interface SVGElement ()


+ (BOOL)shouldStoreContent; // to optimize parser, default is NO

- (id)initWithName:(NSString *)name;

- (void)loadDefaults; // should be overriden to set element defaults

/*! Overridden by sub-classes.  Be sure to call [super parseAttributes:attributes];
 Returns nil, or an error if something failed trying to parse attributes (usually:
 unsupported SVG feature that's not implemented yet) 
 */
- (void)parseAttributes:(NSDictionary *)attributes parseResult:(SVGKParseResult *)parseResult;

/*! Re-calculates the absolute transform on-demand by querying parent's absolute transform and appending self's relative transform */
-(CGAffineTransform) transformAbsolute;

@end

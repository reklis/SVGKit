#import <Foundation/Foundation.h>

#import "SVGKParser.h"

@interface SVGKParserSVG : NSObject <SVGKParserExtension> {
    NSMutableDictionary *_graphicsGroups;
	NSMutableArray *_anonymousGraphicsGroups;
}

@end

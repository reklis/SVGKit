//
//  SVGDocument.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGElement.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^SVGElementAggregationBlock)(SVGElement < SVGLayeredElement > * layeredElement);
#endif

@class SVGDefsElement;

@interface SVGDocument : SVGElement < SVGLayeredElement > { }

// only absolute widths and heights are supported (no percentages)
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly, copy) NSString *version;

// convenience accessors to parsed children
@property (weak, nonatomic, readonly) NSString *title;
@property (weak, nonatomic, readonly) NSString *desc; // 'description' is reserved by NSObject
@property (weak, nonatomic, readonly) SVGDefsElement *defs;

+ (id)documentNamed:(NSString *)name; // 'name' in mainBundle
+ (id)documentWithContentsOfFile:(NSString *)aPath;
+ (id)documentWithData:(NSData *)data;

- (id)initWithContentsOfFile:(NSString *)aPath;
- (id)initWithData:(NSData *)data;
- (id)initWithFrame:(CGRect)frame;

#if NS_BLOCKS_AVAILABLE
- (void) applyAggregator:(SVGElementAggregationBlock)aggregator;
#endif

@end

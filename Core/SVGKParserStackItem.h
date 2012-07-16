#import <Foundation/Foundation.h>

@protocol SVGKParserExtension;
#import "SVGKParserExtension.h"

@interface SVGKParserStackItem : NSObject
@property(nonatomic,retain) NSObject<SVGKParserExtension>* parserForThisItem;
@property(nonatomic,retain) NSObject* item;
@end

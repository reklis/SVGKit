#import <Foundation/Foundation.h>

@protocol SVGKParserExtension;
#import "SVGKParserExtension.h"

#import "Node.h"

@interface SVGKParserStackItem : NSObject
@property(nonatomic,retain) NSObject<SVGKParserExtension>* parserForThisItem;
@property(nonatomic,retain) Node* item;
@end

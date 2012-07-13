#import <Foundation/Foundation.h>

@interface SVGKParserStackItem : NSObject
@property(nonatomic,retain) NSObject<SVGKParserExtension>* parserForThisItem;
@property(nonatomic,retain) NSObject* item;
@end

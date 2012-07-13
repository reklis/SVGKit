#import "SVGKParserStackItem.h"

@implementation SVGKParserStackItem
@synthesize item;
@synthesize parserForThisItem;

- (void) dealloc 
{
    self.item = nil;
    self.parserForThisItem = nil;
    [super dealloc];
}

@end

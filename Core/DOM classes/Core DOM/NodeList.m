#import "NodeList.h"
#import "NodeList+Mutable.h"

@implementation NodeList

@synthesize internalArray;

- (id)init {
    self = [super init];
	
    if (self) {
        self.internalArray = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    self.internalArray = nil;
    [super dealloc];
}

-(Node*) item:(int) index
{
	return [self.internalArray objectAtIndex:index];
}

-(long)length
{
	return [self.internalArray count];
}

@end

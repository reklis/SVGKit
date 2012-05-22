#import "NodeList.h"

@interface NodeList()
@property(nonatomic,retain) NSMutableArray* internalArray;
@end

@implementation NodeList

- (id)init {
    self = [super init];
	
    if (self) {
        self.internalArray = [NSMutableArray array];
    }
    return self;
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

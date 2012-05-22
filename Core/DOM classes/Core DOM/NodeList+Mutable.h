#import "NodeList.h"

@interface NodeList (Mutable)

@property(nonatomic,retain) NSMutableArray* internalArray;

@end

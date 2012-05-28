#import "SVGKParseResult.h"

@implementation SVGKParseResult

@synthesize libXMLFailed;
@synthesize rootOfSVGTree;
@synthesize warnings, errorsRecoverable, errorsFatal;

- (id)init
{
    self = [super init];
    if (self) {
        self.warnings = [NSMutableArray array];
		self.errorsRecoverable = [NSMutableArray array];
		self.errorsFatal = [NSMutableArray array];
    }
    return self;
}
-(void) addSourceError:(NSError*) fatalError
{
	NSLog(@"[%@] SVG ERROR: %@", [self class], fatalError);
	[self.errorsRecoverable addObject:fatalError];
}

-(void) addParseWarning:(NSError*) warning
{
	NSLog(@"[%@] SVG WARNING: %@", [self class], warning);
	[self.warnings addObject:warning];
}

-(void) addParseErrorRecoverable:(NSError*) recoverableError
{
	NSLog(@"[%@] SVG WARNING (recoverable): %@", [self class], recoverableError);
	[self.errorsRecoverable addObject:recoverableError];
}

-(void) addParseErrorFatal:(NSError*) fatalError
{
	NSLog(@"[%@] SVG ERROR: %@", [self class], fatalError);
	[self.errorsFatal addObject:fatalError];
}

-(void) addSAXError:(NSError*) saxError
{
	NSLog(@"[%@] SVG ERROR: %@", [self class], [saxError localizedDescription]);
	[self.errorsFatal addObject:saxError];
}

@end

/**
 Reports detailed information from an attempted run of the SVG Parser
 */
#import <Foundation/Foundation.h>

#import "SVGElement.h"

@interface SVGKParseResult : NSObject

@property(nonatomic, retain) NSMutableArray* warnings, * errorsRecoverable, * errorsFatal;
@property(nonatomic) BOOL libXMLFailed;

@property(nonatomic,retain) SVGElement* rootOfSVGTree;

-(void) addSourceError:(NSError*) fatalError;
-(void) addParseWarning:(NSError*) warning;
-(void) addParseErrorRecoverable:(NSError*) recoverableError;
-(void) addParseErrorFatal:(NSError*) fatalError;
-(void) addSAXError:(NSError*) saxError;
@end

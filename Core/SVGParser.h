//
//  SVGParser.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

@class SVGDocument;

@interface SVGParser : NSObject {
@private
	BOOL _failed;
	BOOL _storingChars;
	NSMutableString *_storedChars;
	NSMutableArray *_elementStack;
	__weak SVGDocument *_document;
    NSData *inputData;
}

- (id)initWithPath:(NSString *)aPath document:(SVGDocument *)document;
- (id)initWithData:(NSData *)data document:(SVGDocument *)document;

- (BOOL)parse:(NSError **)outError;

@end

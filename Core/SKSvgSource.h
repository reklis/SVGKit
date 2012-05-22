/**
 SKSvgSource.h
  
 SKSvgSource represents the info about a file that was read from disk or over the web during parsing.
 
 Once it has been parsed / loaded, that info is NOT PART OF the in-memory SVG any more - if you were to save the file, you could
 save it in a different location, with a different SVG Spec, etc.
 
 However, it's useful for debugging (and for optional "save this document in same place it was loaded from / same format"
 to store this info at runtime just in case it's needed later.
 
 Also, it helps during parsing to keep track of some document-level information
 
 */

#import <Foundation/Foundation.h>

@interface SKSvgSource : NSObject

@property(nonatomic,retain) NSString* svgLanguageVersion; /*< <svg version=""> */
@property(nonatomic) BOOL hasSourceFile, hasSourceURL;
@property(nonatomic,retain) NSString* filePath;
@property(nonatomic,retain) NSURL* URL;

+(SKSvgSource*) sourceFromFilename:(NSString*) p;
+(SKSvgSource*) sourceFromURL:(NSURL*) u;

-(id) newHandle:(NSError**) error;
-(void) closeHandle:(id) handle;
-(int) handle:(id) handle readNextChunk:(char *) chunk maxBytes:(int) READ_CHUNK_SZ;

@end

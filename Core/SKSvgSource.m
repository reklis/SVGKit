
#import "SKSvgSource.h"

@implementation SKSvgSource

@synthesize svgLanguageVersion;
@synthesize hasSourceFile, hasSourceURL;
@synthesize filePath, URL;

+(SKSvgSource*) sourceFromFilename:(NSString*) p
{
	SVGSource* d = [[[SKSvgSource alloc] init] autorelease];
	
	d.hasSourceFile = TRUE;
	d.filePath = p;
	
	return d;
}

+(SKSvgSource*) sourceFromURL:(NSURL*) u
{
	SKSvgSource* d = [[[SKSvgSource alloc] init] autorelease];
	
	d.hasSourceURL = TRUE;
	d.URL = u;
	
	return d;
}

-(id) newHandle:(NSError**) error
{
	/**
	 Is this file being loaded from disk?
	 Or from network?
	 */
	if( self.hasSourceURL )
	{
		/**
		 NB:
		 
		 Currently reads the ENTIRE web file synchronously, holding the entire
		 thing in memory.
		 
		 Not efficient, might crash for 'huge' files (would need to be large numbers of megabytes, though)
		 
		 But ... since we want a synchronous parse ... 
		 */
		NSURLResponse* response;
		NSData* httpData = nil;
		
		NSURLRequest* request = [NSURLRequest requestWithURL:self.URL];
		
		httpData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
		
		if( error != nil )
		{
			NSLog( @"[%@] ERROR: failed to parse SVG from URL, because failed to download file at URL = %@, error = %@", [self class], self.URL, error );
			return nil;
		}
		
		return httpData;
	}
	else
	{
		FILE *file;
		const char *cPath = [self.filePath fileSystemRepresentation];
		file = fopen(cPath, "r");
		
		if (!file)
			*error = [NSError errorWithDomain:@"SVGKit" code:1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																		 [NSString stringWithFormat:@"Couldn't open the file %@ for reading", self.filePath], NSLocalizedDescriptionKey,
																		 nil]];
		
		return [NSValue valueWithPointer:file]; // objc cannot cope with using C-pointers as pointers, without some help
	}

}

-(void) closeHandle:(id) handle
{
	/**
	 Is this file being loaded from disk?
	 Or from network?
	 */
	if( self.hasSourceURL )
	{
		// nothing needed - the asynch call was already complete
	}
	else
	{
		FILE *file = [handle pointerValue]; // objc cannot cope with using C-pointers as pointers, without some help
		
		fclose(file);
	}
}

-(int) handle:(id) handle readNextChunk:(char *) chunk maxBytes:(int) READ_CHUNK_SZ
{
	/**
	 Is this file being loaded from disk?
	 Or from network?
	 */
	if( self.hasSourceURL )
	{
		NSData* httpData = handle;
		const char* dataAsBytes = [httpData bytes];
		int dataLength = [httpData length];
		
		int actualBytesCopied = MIN( dataLength, READ_CHUNK_SZ );
		memcpy( chunk, dataAsBytes, actualBytesCopied);
		
		/** trim the copied bytes out of the 'handle' NSData object */
		NSRange newRange = { actualBytesCopied, dataLength - actualBytesCopied };
		handle = [httpData subdataWithRange:newRange];
		
		return actualBytesCopied;
	}
	else
	{
		size_t bytesRead = 0;
		FILE *file = [handle pointerValue]; // objc cannot cope with using C-pointers as pointers, without some help
		
		bytesRead = fread(chunk, 1, READ_CHUNK_SZ, file);
		
		return bytesRead;
	}
}


@end

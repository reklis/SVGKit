#import "SVGKImageView.h"

@implementation SVGKImageView

@synthesize image;
@synthesize scaleMultiplier;
@synthesize tileContents;

- (id)init
{
	NSAssert(false, @"init not supported, use initWithSVGKImage:");
    
    return nil;
}

- (id)initWithSVGKImage:(SVGKImage*) im
{
    self = [super init];
    if (self)
	{
		self.image = im;
		self.frame = CGRectMake( 0,0, im.CALayerTree.frame.size.width, im.CALayerTree.frame.size.height ); // default: 0,0 to width x height of original image
		self.scaleMultiplier = CGSizeMake(1.0, 1.0);
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
	CGRect imageFrameAtZero = CGRectMake( 0,0, self.image.CALayerTree.frame.size.width, self.image.CALayerTree.frame.size.height );
	CGRect scaledImageFrame = CGRectApplyAffineTransform( imageFrameAtZero, CGAffineTransformMakeScale( self.scaleMultiplier.width, self.scaleMultiplier.height));
	
	int cols = 1 + self.bounds.size.width / scaledImageFrame.size.width;
	int rows = 1 + self.bounds.size.height / scaledImageFrame.size.height;
	
	if( ! self.tileContents )
		cols = rows = 1;
	
	/** To support tiling, and to allow internal shrinking, we use renderInContext */
	CGContextRef context = UIGraphicsGetCurrentContext();
	for( int k=0; k<rows; k++ )
		for( int i=0; i<cols; i++ )
		{
			CGContextSaveGState(context);
			
			CGContextTranslateCTM(context, i * scaledImageFrame.size.width, k * scaledImageFrame.size.height );
			CGContextScaleCTM( context, self.scaleMultiplier.width, self.scaleMultiplier.height );
			
			[self.image.CALayerTree renderInContext:context];
			
			CGContextRestoreGState(context);
		}
}

@end

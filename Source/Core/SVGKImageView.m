#import "SVGKImageView.h"

@implementation SVGKImageView
{
	NSString* internalContextPointerBecauseApplesDemandsIt;
}

@synthesize image = _image;
@synthesize scaleMultiplier = _scaleMultiplier;
@synthesize tileContents = _tileContents;

- (id)init
{
	NSAssert(false, @"init not supported, use initWithSVGKImage:");
    
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	return [self initWithSVGKImage:nil];
}

- (id)initWithSVGKImage:(SVGKImage*) im
{
	if( im == nil )
	{
		NSLog(@"[%@] WARNING: you have initialized an SVGKImageView with a blank image (nil). Possibly because you're using Storyboars or NIBs which Apple won't allow anyone to use with 3rd party code", [self class]);
	}
	
    self = [super init];
    if (self)
	{
		internalContextPointerBecauseApplesDemandsIt = @"Apple wrote the addObserver / KVO notification API wrong in the first place and now requires developers to pass around pointers to fake objects to make up for the API deficicineces. You have to have one of these pointers per object, and they have to be internal and private. They serve no real value.";
		
		self.image = im;
		self.frame = CGRectMake( 0,0, im.CALayerTree.frame.size.width, im.CALayerTree.frame.size.height ); // default: 0,0 to width x height of original image
		self.scaleMultiplier = CGSizeMake(1.0, 1.0);
		self.backgroundColor = [UIColor clearColor];
		
		if( self.disableAutoRedrawAtHighestResolution )
			;
		else
			[self addAllInternalObservers];
    }
    return self;
}

-(void) addAllInternalObservers
{
	[self addObserver:self forKeyPath:@"layer" options:NSKeyValueObservingOptionNew context:internalContextPointerBecauseApplesDemandsIt];
	[self.layer addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:internalContextPointerBecauseApplesDemandsIt];
	[self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:internalContextPointerBecauseApplesDemandsIt];
	[self addObserver:self forKeyPath:@"scaleMultiplier" options:NSKeyValueObservingOptionNew context:internalContextPointerBecauseApplesDemandsIt];
	[self addObserver:self forKeyPath:@"tileContents" options:NSKeyValueObservingOptionNew context:internalContextPointerBecauseApplesDemandsIt];
	[self addObserver:self forKeyPath:@"showBorder" options:NSKeyValueObservingOptionNew context:internalContextPointerBecauseApplesDemandsIt];
}

-(void) removeAllInternalObservers
{
	[self removeObserver:self  forKeyPath:@"layer" context:internalContextPointerBecauseApplesDemandsIt];
	[self.layer removeObserver:self forKeyPath:@"transform" context:internalContextPointerBecauseApplesDemandsIt];
	
	[self removeObserver:self forKeyPath:@"image" context:internalContextPointerBecauseApplesDemandsIt];
	[self removeObserver:self forKeyPath:@"scaleMultiplier" context:internalContextPointerBecauseApplesDemandsIt];
	[self removeObserver:self forKeyPath:@"tileContents" context:internalContextPointerBecauseApplesDemandsIt];
	[self removeObserver:self forKeyPath:@"showBorder" context:internalContextPointerBecauseApplesDemandsIt];
}

-(void)setDisableAutoRedrawAtHighestResolution:(BOOL)newValue
{
	if( newValue == _disableAutoRedrawAtHighestResolution )
		return;
	
	_disableAutoRedrawAtHighestResolution = newValue;
	
	if( self.disableAutoRedrawAtHighestResolution ) // disabled, so we have to remove the observers
	{
		[self removeAllInternalObservers];
	}
	else // newly-enabled ... must add the observers
	{
		[self addAllInternalObservers];
	}
}

- (void)dealloc
{
	if( self.disableAutoRedrawAtHighestResolution )
		;
	else
		[self removeAllInternalObservers];
    
	self.image = nil;
	
    [super dealloc];
}

/** Trigger a call to re-display (at higher or lower draw-resolution) (get Apple to call drawRect: again) */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if( self.disableAutoRedrawAtHighestResolution )
		;
	else
		[self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
	CGRect imageFrameAtZero = CGRectMake( 0,0, self.image.CALayerTree.frame.size.width, self.image.CALayerTree.frame.size.height );
	
	CGSize multiplierFromImageToView = CGSizeMake( self.frame.size.width / imageFrameAtZero.size.width, self.frame.size.height / imageFrameAtZero.size.height );
	CGSize finalScaleMultiplier = CGSizeMake( multiplierFromImageToView.width * self.scaleMultiplier.width, multiplierFromImageToView.height * self.scaleMultiplier.height );
	
	
	CGRect scaledImageFrame = CGRectApplyAffineTransform( imageFrameAtZero, CGAffineTransformMakeScale( finalScaleMultiplier.width, finalScaleMultiplier.height));
	
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
			CGContextScaleCTM( context, finalScaleMultiplier.width, finalScaleMultiplier.height );
			
			[self.image.CALayerTree renderInContext:context];
			
			CGContextRestoreGState(context);
		}
	
	if( self.showBorder )
	{
		[[UIColor blackColor] set];
		CGContextStrokeRect(context, rect);
	}
}

@end

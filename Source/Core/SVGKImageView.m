#import "SVGKImageView.h"

@implementation SVGKImageView
{
	NSString* internalContextPointerBecauseApplesDemandsIt;
}

@synthesize image = _image;
@synthesize tileRatio = _tileRatio;

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
		self.tileRatio = CGSizeZero;
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
	/**
	 view.bounds == width and height of the view
	 imageBounds == natural width and height of the SVGKImage
	 */
	CGRect imageBounds = CGRectMake( 0,0, self.image.CALayerTree.frame.size.width, self.image.CALayerTree.frame.size.height );
	
	
	/** Check if tiling is enabled in either direction
	 
	 We have to do this FIRST, because we cannot extend Apple's enum they use for UIViewContentMode
	 (objective-C is a weak language).
	 
	 If we find ANY tiling, we will be forced to skip the UIViewContentMode handling
	 
	 TODO: it would be nice to combine the two - e.g. if contentMode=BottomRight, then do the tiling with
	 the bottom right corners aligned. If = TopLeft, then tile with the top left corners aligned,
	 etc.
	 */
	int cols = ceil(self.tileRatio.width);
	int rows = ceil(self.tileRatio.height);
	
	if( cols < 1 ) // It's meaningless to have "fewer than 1" tiles; this lets us ALSO handle special case of "CGSizeZero == disable tiling"
		cols = 1;
	if( rows < 1 ) // It's meaningless to have "fewer than 1" tiles; this lets us ALSO handle special case of "CGSizeZero == disable tiling"
		rows = 1;
	
	
	CGSize scaleConvertImageToView;
	CGSize tileSize;
	if( cols == 1 && rows == 1 ) // if we are NOT tiling, then obey the UIViewContentMode as best we can!
	{
		tileSize = CGSizeMake( 1.0f, 1.0f );
		switch( self.contentMode )
		{
			case UIViewContentModeScaleToFill:
			default:
			{
				scaleConvertImageToView = CGSizeMake( self.bounds.size.width / imageBounds.size.width, self.bounds.size.height / imageBounds.size.height );
			}break;
		}
	}
	else
	{
		scaleConvertImageToView = CGSizeMake( self.bounds.size.width / (self.tileRatio.width * imageBounds.size.width), self.bounds.size.height / ( self.tileRatio.height * imageBounds.size.height) );
		tileSize = CGSizeMake( self.bounds.size.width / self.tileRatio.width, self.bounds.size.height / self.tileRatio.height );
	}
	
	NSLog(@"cols, rows: %i, %i ... scaleConvert: %@ ... tilesize: %@", cols, rows, NSStringFromCGSize(scaleConvertImageToView), NSStringFromCGSize(tileSize) );
	/** To support tiling, and to allow internal shrinking, we use renderInContext */
	CGContextRef context = UIGraphicsGetCurrentContext();
	for( int k=0; k<rows; k++ )
		for( int i=0; i<cols; i++ )
		{
			CGContextSaveGState(context);
			
			CGContextTranslateCTM(context, i * tileSize.width, k * tileSize.height );
			CGContextScaleCTM( context, scaleConvertImageToView.width, scaleConvertImageToView.height );
			
			[self.image.CALayerTree renderInContext:context];
			
			CGContextRestoreGState(context);
		}
	
	/** The border is VERY helpful when debugging rendering and touch / hit detection problems! */
	if( self.showBorder )
	{
		[[UIColor blackColor] set];
		CGContextStrokeRect(context, rect);
	}
}

@end

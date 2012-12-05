#import "SVGKLayer.h"

@implementation SVGKLayer
{
	NSString* internalContextPointerBecauseApplesDemandsIt;
}

@synthesize SVGImage = _SVGImage;

//self.backgroundColor = [UIColor clearColor];

/** Apple requires this to be implemented by CALayer subclasses */
+(id)layer
{
	SVGKLayer* layer = [[SVGKLayer alloc] init];
	return layer;
}

- (id)init
{
    self = [super init];
    if (self)
	{
        internalContextPointerBecauseApplesDemandsIt = [NSString stringWithFormat: @"%@: Apple wrote the addObserver / KVO notification API wrong in the first place and now requires developers to pass around pointers to fake objects to make up for the API deficicineces. You have to have one of these pointers per object, and they have to be internal and private. They serve no real value.", [self class]];
		
		self.borderColor = [UIColor blackColor].CGColor;
		
		[self addObserver:self forKeyPath:@"showBorder" options:NSKeyValueObservingOptionNew context:internalContextPointerBecauseApplesDemandsIt];
    }
    return self;
}
-(void)setSVGImage:(SVGKImage *) newImage
{
	if( newImage == _SVGImage )
		return;
	
	/** 1: remove old */
	if( _SVGImage != nil )
	{
		[_SVGImage.CALayerTree removeFromSuperlayer];
		[_SVGImage release];
	}
	
	/** 2: update pointer */
	_SVGImage = newImage;
	
	/** 3: add new */
	if( _SVGImage != nil )
	{
		[_SVGImage retain];
		[self addSublayer:_SVGImage.CALayerTree];
	}
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"showBorder" context:internalContextPointerBecauseApplesDemandsIt];
	
	self.SVGImage = nil;
	
    [super dealloc];
}

/** Trigger a call to re-display (at higher or lower draw-resolution) (get Apple to call drawRect: again) */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if( [keyPath isEqualToString:@"showBorder"] )
	{
		if( self.showBorder )
		{
			self.borderWidth = 1.0f;
		}
		else
		{
			self.borderWidth = 0.0f;
		}
		
		[self setNeedsDisplay];
	}
}

@end

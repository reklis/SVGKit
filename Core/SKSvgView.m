//
//  SVGView.m
//  SVGKit
//
//

#import "SVGView.h"

#import "SVGImage.h"
#import "SVGImage+CA.h"

@implementation SVGView

@synthesize image = _image;

- (id)initWithImage:(SVGImage *) im {
	NSAssert( im != nil, @"Cannot init with a nil SVGImage; this class requires a pre-loaded SVGImage instance" );
	
	self = [self initWithFrame:CGRectMake(0.0f, 0.0f, im.size.width, im.size.height)];
	if (self) {
		self.image = im;
	}
	return self;
}

- (void)dealloc {
	[_image release];
	
	[super dealloc];
}

#if TARGET_OS_IPHONE
#else
/*! Mac only: Mac uses a flipped render system */
- (BOOL)isFlipped {
	return YES;
}
#endif


- (void)setImage:(SVGImage *) newImage {
	if (_image != newImage) {
		[_image release];
		_image = [newImage retain];

		/**
		 ADAM: this old code seems pointless. It looks like someone's trying to do a minor compiler
		 optimization by doing a reverse loop, but ... that would be massive overkill?
		 
		 REMOVED for now, replaced with the obvious normal loop (below)
		 
        for (NSInteger i = [self.layer.sublayers count] - 1; i >= 0; i--) {
            CALayer *sublayer = [self.layer.sublayers objectAtIndex:i];
            [sublayer removeFromSuperlayer];
        }*/
		for (CALayer *sublayer in [self.layer sublayers]) {
            [sublayer removeFromSuperlayer];
        }

		[self.layer addSublayer:[_image layerTreeCached]];
	}
}

@end
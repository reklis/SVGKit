#import "SVGSVGElement.h"

#import "CALayerWithChildHitTest.h"

@interface SVGSVGElement()
@property (nonatomic, readwrite) CGRect viewBoxFrame;
@end

@implementation SVGSVGElement

@synthesize viewBoxFrame = _viewBoxFrame;

@synthesize graphicsGroups, anonymousGraphicsGroups;

-(void)dealloc
{
	self.graphicsGroups = nil;
	self.anonymousGraphicsGroups = nil;
	self.viewBoxFrame = CGRectNull;
	[super dealloc];	
}

#pragma mark - SVG Spec methods

-(long) suspendRedraw:(long) maxWaitMilliseconds { NSAssert( FALSE, "Not implemented yet" ); }
-(void) unsuspendRedraw:(long) suspendHandleID { NSAssert( FALSE, "Not implemented yet" ); }
-(void) unsuspendRedrawAll { NSAssert( FALSE, "Not implemented yet" ); }
-(void) forceRedraw { NSAssert( FALSE, "Not implemented yet" ); }
-(void) pauseAnimations { NSAssert( FALSE, "Not implemented yet" ); }
-(void) unpauseAnimations { NSAssert( FALSE, "Not implemented yet" ); }
-(BOOL) animationsPaused { NSAssert( FALSE, "Not implemented yet" ); }
-(float) getCurrentTime { NSAssert( FALSE, "Not implemented yet" ); }
-(void) setCurrentTime:(float) seconds { NSAssert( FALSE, "Not implemented yet" ); }
-(NodeList*) getIntersectionList:(SVGRect) rect referenceElement:(SVGElement*) referenceElement { NSAssert( FALSE, "Not implemented yet" ); }
-(NodeList*) getEnclosureList:(SVGRect) rect referenceElement:(SVGElement*) referenceElement { NSAssert( FALSE, "Not implemented yet" ); }
-(BOOL) checkIntersection:(SVGElement*) element rect:(SVGRect) rect { NSAssert( FALSE, "Not implemented yet" ); }
-(BOOL) checkEnclosure:(SVGElement*) element rect:(SVGRect) rect { NSAssert( FALSE, "Not implemented yet" ); }
-(void) deselectAll { NSAssert( FALSE, "Not implemented yet" ); }
-(SVGNumber) createSVGNumber { NSAssert( FALSE, "Not implemented yet" ); }
-(SVGLength) createSVGLength { NSAssert( FALSE, "Not implemented yet" ); }
-(SVGAngle) createSVGAngle { NSAssert( FALSE, "Not implemented yet" ); }
-(SVGPoint) createSVGPoint { NSAssert( FALSE, "Not implemented yet" ); }
-(SVGMatrix) createSVGMatrix { NSAssert( FALSE, "Not implemented yet" ); }
-(SVGRect) createSVGRect { NSAssert( FALSE, "Not implemented yet" ); }
-(SVGTransform) createSVGTransform { NSAssert( FALSE, "Not implemented yet" ); }
-(SVGTransform) createSVGTransformFromMatrix:(SVGMatrix) matrix { NSAssert( FALSE, "Not implemented yet" ); }
-(Element*) getElementById:(NSString*) elementId { NSAssert( FALSE, "Not implemented yet" ); }


#pragma mark - Objective C methods needed given our current non-compliant SVG Parser

- (void)parseAttributes:(NSDictionary *)attributes {
	[super parseAttributes:attributes];
	
	id value = nil;
	
	if ((value = [attributes objectForKey:@"width"])) {
		self.documentWidth = SVGLengthFromNSString( value );
	}
	
	if ((value = [attributes objectForKey:@"height"])) {
		self.documentHeight = SVGLengthFromNSString( value );
	}
	
	if( (value = [attributes objectForKey:@"viewBox"])) {
		NSArray* boxElements = [(NSString*) value componentsSeparatedByString:@" "];
		
		_viewBoxFrame = CGRectMake([[boxElements objectAtIndex:0] floatValue], [[boxElements objectAtIndex:1] floatValue], [[boxElements objectAtIndex:2] floatValue], [[boxElements objectAtIndex:3] floatValue]);
        
        //osx logging
#if TARGET_OS_IPHONE        
        NSLog(@"[%@] DEBUG INFO: set document viewBox = %@", [self class], NSStringFromCGRect(self.viewBoxFrame));
#else
        //mac logging
     NSLog(@"[%@] DEBUG INFO: set document viewBox = %@", [self class], NSStringFromRect(self.viewBoxFrame));    
#endif   
        
	}
}

- (SVGElement *)findFirstElementOfClass:(Class)class {
	for (SVGElement *element in self.children) {
		if ([element isKindOfClass:class])
			return element;
	}
	
	return nil;
}

- (CALayer *) newLayerPreTransformed:(CGAffineTransform) preTransform
{
	
	CALayer* _layer = [[CALayerWithChildHitTest layer] retain];
	
	_layer.name = self.identifier;
	[_layer setValue:self.identifier forKey:kSVGElementIdentifier];
	
	if ([_layer respondsToSelector:@selector(setShouldRasterize:)]) {
		[_layer performSelector:@selector(setShouldRasterize:)
					 withObject:[NSNumber numberWithBool:YES]];
	}
	
	return _layer;
}

- (void)layoutLayer:(CALayer *)layer {
	NSArray *sublayers = [layer sublayers];
	CGRect mainRect = CGRectZero;
	
	for (NSUInteger n = 0; n < [sublayers count]; n++) {
		CALayer *currentLayer = [sublayers objectAtIndex:n];
		
		if (n == 0) {
			mainRect = currentLayer.frame;
		}
		else {
			mainRect = CGRectUnion(mainRect, currentLayer.frame);
		}
	}
	
	layer.frame = mainRect;
	
	// TODO: this code looks insanely wrong to me. WTF is it doing? Why? WHY?
	for (CALayer *currentLayer in sublayers) {
		CGRect frame = currentLayer.frame;
		frame.origin.x -= mainRect.origin.x;
		frame.origin.y -= mainRect.origin.y;
		
		currentLayer.frame = frame;
	}
}


@end

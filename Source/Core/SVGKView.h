@class SVGKImage;

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@interface SVGKView :UIView { }
#else
@interface SVGKView : NSView { }
#endif

@property (nonatomic, retain) SVGKImage *image;

- (id)initWithImage:(SVGKImage *)image; // set frame to position

@end

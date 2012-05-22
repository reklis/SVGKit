@class SKSvgImage;

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@interface SKSvgView :UIView { }
#else
@interface SKSvgView : NSView { }
#endif

@property (nonatomic, retain) SKSvgImage *image;

- (id)initWithImage:(SKSvgImage *)image; // set frame to position

@end

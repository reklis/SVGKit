//
//  SVGView.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//


@class SVGImage;

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@interface SVGView :UIView { }
#else
@interface SVGView : NSView { }
#endif

@property (nonatomic, retain) SVGImage *image;

- (id)initWithImage:(SVGImage *)image; // set frame to position

@end

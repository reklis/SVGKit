//
//  SVGPadAppDelegate.h
//  SVGPad
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

@class RootViewController, DetailViewController;

@interface SVGPadAppDelegate : NSObject < UIApplicationDelegate > { }

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, strong) IBOutlet RootViewController *rootViewController;
@property (nonatomic, strong) IBOutlet DetailViewController *detailViewController;

@end

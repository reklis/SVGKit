//
//  DetailViewController.h
//  SVGPad
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGKit.h"

@interface DetailViewController : UIViewController < UIPopoverControllerDelegate, UISplitViewControllerDelegate > {
  @private
	NSString *_name;
}

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet SVGView *contentView;

@property (nonatomic, strong) id detailItem;

- (IBAction)animate:(id)sender;

@end

//
//  DetailViewController.m
//  SVGPad
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) UIPopoverController *popoverController;

- (void)loadResource:(NSString *)name;
- (void)shakeHead;
- (void)pinch:(UIGestureRecognizer*)gesture;

@end


@implementation DetailViewController

@synthesize toolbar, popoverController, contentView, detailItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPinchGestureRecognizer* zoom = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.view addGestureRecognizer:zoom];
}

- (void)dealloc {
	self.detailItem = nil;
	
}

- (void)setDetailItem:(id)newDetailItem {
	if (detailItem != newDetailItem) {
		detailItem = newDetailItem;
		
		[self loadResource:newDetailItem];
	}
	
	if (self.popoverController) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
}

- (void)loadResource:(NSString *)name {
	SVGDocument *document = [SVGDocument documentNamed:[name stringByAppendingPathExtension:@"svg"]];
	
	self.contentView.bounds = CGRectMake(0.0f, 0.0f, document.width, document.height);
	self.contentView.document = document;
	
	if (_name) {
		_name = nil;
	}
	
	_name = [name copy];
}

- (IBAction)animate:(id)sender {
	if ([_name isEqualToString:@"Monkey"]) {
		[self shakeHead];
	}
}

- (void)shakeHead {
	CALayer *layer = [self.contentView.document layerWithIdentifier:@"head"];
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.duration = 0.25f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = [NSNumber numberWithFloat:0.1f];
	animation.toValue = [NSNumber numberWithFloat:-0.1f];
	
	[layer addAnimation:animation forKey:@"shakingHead"];
}

- (void)splitViewController:(UISplitViewController *)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem *)barButtonItem
	   forPopoverController:(UIPopoverController *)pc {
	
	barButtonItem.title = @"Samples";
	
	NSMutableArray *items = [[toolbar items] mutableCopy];
	[items insertObject:barButtonItem atIndex:0];
	
	[toolbar setItems:items animated:YES];
	
	self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
	NSMutableArray *items = [[toolbar items] mutableCopy];
	[items removeObjectAtIndex:0];
	
	[toolbar setItems:items animated:YES];
	
	self.popoverController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)pinch:(UIGestureRecognizer *)gesture
{
    UIPinchGestureRecognizer* zoom = (UIPinchGestureRecognizer*)gesture;
    CGAffineTransform t = CGAffineTransformScale(self.contentView.transform, zoom.scale, zoom.scale);
    self.contentView.transform = t;
}

@end

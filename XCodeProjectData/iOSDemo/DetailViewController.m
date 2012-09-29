//
//  DetailViewController.m
//  iOSDemo
//
//  Created by adam on 29/09/2012.
//  Copyright (c) 2012 na. All rights reserved.
//
#import "DetailViewController.h"

#import "MasterViewController.h"

#import "NodeList+Mutable.h"

@interface DetailViewController ()

@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)loadResource:(NSString *)name;
- (void)shakeHead;

@end


@implementation DetailViewController
@synthesize scrollViewForSVG;

@synthesize toolbar, popoverController, contentView, detailItem;
@synthesize viewActivityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
	self.popoverController = nil;
	self.toolbar = nil;
	self.detailItem = nil;
	
	[super dealloc];
}

#pragma mark - CRITICAL: this method makes Apple render SVGs in sharp focus

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	/**
	 
	 Apple's implementation of zooming is EXTREMELY poorly designed; it's a hack onto a class
	 that was only designed to do panning (hence the name: uiSCROLLview)
	 
	 So ... "zooming" via a UIScrollView is NOT integrated with UIView
	 rendering - in a UIView subclass, you CANNOT KNOW whether you have been "zoomed"
	 (i.e.: had your view contents ruined horribly by Apple's class)
	 
	 The three lines that follow are - allegedly - Apple's preferred way of handling
	 the situation. Note that we DO NOT SET view.frame! According to official docs,
	 view.frame is UNDEFINED (this is very worrying, breaks a huge amount of UIKit-related code,
	 but that's how Apple has documented / implemented it!)
	 */
	view.transform = CGAffineTransformIdentity; // this alters view.frame! But *not* view.bounds
	view.bounds = CGRectApplyAffineTransform( view.bounds, CGAffineTransformMakeScale(scale, scale));
	[view setNeedsDisplay];
	
	/**
	 Workaround for another bug in Apple's hacks for UIScrollView:
	 
	  - when you reset the transform, as advised by Apple, you "break" Apple's memory of the scroll factor.
	     ... because they "forgot" to store it anywhere (they read your view.transform as if it were a private
			 variable inside UIScrollView! This causes MANY bugs in applications :( )
	 */
	self.scrollViewForSVG.minimumZoomScale /= scale;
	self.scrollViewForSVG.maximumZoomScale /= scale;
}

#pragma mark - rest of class

- (void)setDetailItem:(id)newDetailItem {
	if (detailItem != newDetailItem) {
		[detailItem release];
		detailItem = [newDetailItem retain];
		
		self.view; // REQUIRED: this class is badly designed, it relies upon the view being visible before .detailedItem is set :(
		[self loadResource:newDetailItem];
	}
	
	if (self.popoverController) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
}

- (void)loadResource:(NSString *)name
{
	[self.viewActivityIndicator startAnimating];
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]]; // makes the animation appear
	
    [self.contentView removeFromSuperview];
    
	SVGKImage *document = [SVGKImage imageNamed:[name stringByAppendingPathExtension:@"svg"]];
	
	if( document == nil )
	{
				[[[UIAlertView alloc] initWithTitle:@"SVG parse failed" message:@"Total failure. See console log" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}
	else
	{
	if( document.parseErrorsAndWarnings.rootOfSVGTree != nil )
	{
		NSLog(@"[%@] Freshly loaded document (name = %@) has size = %@", [self class], name, NSStringFromCGSize(document.size) );
		
		self.contentView = [[[SVGKImageView alloc] initWithSVGKImage:document] autorelease];
		
		if (_name) {
			[_name release];
			_name = nil;
		}
		
		_name = [name copy];
		
		[self.scrollViewForSVG addSubview:self.contentView];
		[self.scrollViewForSVG setContentSize: self.contentView.frame.size];
		
		float screenToDocumentSizeRatio = self.scrollViewForSVG.frame.size.width / self.contentView.frame.size.width;
		
		self.scrollViewForSVG.minimumZoomScale = MIN( 1, screenToDocumentSizeRatio );
		self.scrollViewForSVG.maximumZoomScale = MAX( 1, screenToDocumentSizeRatio );
				
		NodeList* elementsUsingTagG = [document.DOMDocument getElementsByTagName:@"g"];
		NSLog( @"[%@] checking for SVG standard set of elements with XML tag/node of <g>: %@", [self class], elementsUsingTagG.internalArray );
	}
	else
	{
		[[[UIAlertView alloc] initWithTitle:@"SVG parse failed" message:[NSString stringWithFormat:@"%i fatal errors, %i warnings. First fatal = %@",[document.parseErrorsAndWarnings.errorsFatal count],[document.parseErrorsAndWarnings.errorsRecoverable count]+[document.parseErrorsAndWarnings.warnings count], ((NSError*)[document.parseErrorsAndWarnings.errorsFatal objectAtIndex:0]).localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}
	}
	
	[self.viewActivityIndicator stopAnimating];
}

- (IBAction)animate:(id)sender {
	if ([_name isEqualToString:@"Monkey"]) {
		[self shakeHead];
	}
}


- (void)shakeHead {
	CALayer *layer = [self.contentView.image layerWithIdentifier:@"head"];
	
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
	[items release];
	
	self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
	NSMutableArray *items = [[toolbar items] mutableCopy];
	[items removeObjectAtIndex:0];
	
	[toolbar setItems:items animated:YES];
	[items release];
	
	self.popoverController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

#pragma mark Export


- (IBAction)exportLayers:(id)sender {
    if (_layerExporter) {
        return;
    }
    _layerExporter = [[CALayerExporter alloc] initWithView:contentView];
    _layerExporter.delegate = self;
    
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    UIViewController* textViewController = [[[UIViewController alloc] init] autorelease];
    [textViewController setView:textView];
    UIPopoverController* exportPopover = [[UIPopoverController alloc] initWithContentViewController:textViewController];
    [exportPopover setDelegate:self];
    [exportPopover presentPopoverFromBarButtonItem:sender
						  permittedArrowDirections:UIPopoverArrowDirectionAny
										  animated:YES];
    
    _exportText = textView;
    _exportText.text = @"exporting...";
    
    _exportLog = [[NSMutableString alloc] init];
    [_layerExporter startExport];
}

- (void) layerExporter:(CALayerExporter*)exporter didParseLayer:(CALayer*)layer withStatement:(NSString*)statement
{
    //NSLog(@"%@", statement);
    [_exportLog appendString:statement];
    [_exportLog appendString:@"\n"];
}

- (void)layerExporterDidFinish:(CALayerExporter *)exporter
{
    _exportText.text = _exportLog;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)pc
{
    [_exportText release];
    _exportText = nil;
    
    [_layerExporter release];
    _layerExporter = nil;
    
    [pc release];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}



@end

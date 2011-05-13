//
//  FeedItemViewController.m
//  provaScrollView
//
//  Created by Xavi Aracil on 13/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedItemViewController.h"


@implementation FeedItemViewController
@synthesize webView;
@synthesize link;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture]; 
    [tapGesture release];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void) setTextContent:(NSString *) content {
    // load HTML source
    [webView loadHTMLString:content baseURL:nil];    
}

#pragma mark -
#pragma mark Tap gesture
- (void) tapAction:(UIGestureRecognizer *)gestureRecognizer {
    [[UIApplication sharedApplication] openURL:link];
}

@end

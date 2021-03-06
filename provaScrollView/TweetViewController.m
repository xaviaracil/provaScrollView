//
//  TweetViewController.m
//  provaScrollView
//
//  Created by Xavi Aracil on 12/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TweetViewController.h"


@implementation TweetViewController
@synthesize photo;
@synthesize titleLabel;
@synthesize textLabel;
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
    [photo release];
    [titleLabel release];
    [textLabel release];
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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture]; 
    [tapGesture release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) setPhotoUrl:(NSURL *)url {
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    self.photo.image = image;
    
    [image release];
}

#pragma mark -
#pragma mark Tap gesture
- (void) tapAction:(UIGestureRecognizer *)gestureRecognizer {
    [[UIApplication sharedApplication] openURL:link];
}
@end

//
//  provaScrollViewViewController.m
//  provaScrollView
//
//  Created by Xavi Aracil on 11/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "provaScrollViewViewController.h"
#import "JSON.h"

#define TWITTER_SEARCH_URL @"http://search.twitter.com/search.json?result_type=mixed"

@implementation provaScrollViewViewController

@synthesize publicTimelineScrollView;
@synthesize timelineArray;

- (void)dealloc
{
    [publicTimelineScrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // load tweets from public timeline
    NSURL *url = [NSURL URLWithString:TWITTER_SEARCH_URL];
    
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    // Parsing will result in Foundation objects
    // Top level may be an NSDictionary or NSArray
    id object = [jsonString JSONValue];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objectAsDictionary = (NSDictionary *) object;
        id results = [objectAsDictionary valueForKey:@"results"];
        if ([results isKindOfClass:[NSArray class]]) {
            self.timelineArray = results;
        }        
    }
    if ([object isKindOfClass:[NSArray class]]) {
        self.timelineArray = object;
    }
    
}

- (void)viewDidUnload
{
    [self setPublicTimelineScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end

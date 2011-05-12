//
//  provaScrollViewViewController.m
//  provaScrollView
//
//  Created by Xavi Aracil on 11/05/11.
//  Copyright 2011 xadSolutions. All rights reserved.
//

#import "provaScrollViewViewController.h"
#import "JSON.h"

#define TWITTER_SEARCH_URL @"http://search.twitter.com/search.json?q=%@"

/* private methods defined here */
@interface provaScrollViewViewController()
-(void) displayFirstTweet;
@end

@implementation provaScrollViewViewController

@synthesize publicTimelineScrollView;
@synthesize timelineArray;
@synthesize lightTweetViewDemo;

- (void)dealloc
{
    [publicTimelineScrollView release];
    [lightTweetViewDemo release];
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
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
 
}*/

- (void)viewDidUnload
{
    [self setPublicTimelineScrollView:nil];
    [self setLightTweetViewDemo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)search:(id)sender {
    UITextField *textField = (UITextField *) sender;

    // load tweets from twitter search API (http://dev.twitter.com/doc/get/search)    
    NSString *queryURL = [NSString stringWithFormat:TWITTER_SEARCH_URL, textField.text];
    NSURL *url = [NSURL URLWithString:queryURL];
    
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
    
    
    [self displayFirstTweet];
}

#pragma mark -
#pragma mark Private Methods
-(void) displayFirstTweet {
    // a borrar: inicializamos la lighttweetview de demo
    NSDictionary *firstTweet = [self.timelineArray objectAtIndex:0];

    // imagen
    NSURL *profileImageUrl = [NSURL URLWithString:[firstTweet valueForKey:@"profile_image_url"]];
    NSData *profileImageData = [NSData dataWithContentsOfURL:profileImageUrl];
    UIImage *profileImage = [[UIImage alloc] initWithData:profileImageData];
    
    self.lightTweetViewDemo.imageView.image = profileImage;
    
    [profileImage release];
    
    // titulo
    self.lightTweetViewDemo.titleLabel.text = [firstTweet valueForKey:@"from_user"];
    
    // texto
    self.lightTweetViewDemo.textLabel.text = [firstTweet valueForKey:@"text"];
    
}
@end

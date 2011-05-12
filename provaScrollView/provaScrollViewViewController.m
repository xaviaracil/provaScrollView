//
//  provaScrollViewViewController.m
//  provaScrollView
//
//  Created by Xavi Aracil on 11/05/11.
//  Copyright 2011 xadSolutions. All rights reserved.
//

#import "provaScrollViewViewController.h"
#import "JSON.h"
#import "TweetViewController.h"

#define TWITTER_SEARCH_URL @"http://search.twitter.com/search.json?q=%@"
#define TWITTER_STATUS_URL @"http://www.twitter.com/%@/status/%@"

/* private methods defined here */
@interface provaScrollViewViewController()
- (void) displayFirstTweet;
- (void)loadScrollViewWithPage:(int)page;
@end

@implementation provaScrollViewViewController

@synthesize searchResultsScrollView;
@synthesize timelineArray;
@synthesize lightTweetViewDemo;
@synthesize viewControllers;

- (void)dealloc
{
    [searchResultsScrollView release];
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
    [self setSearchResultsScrollView:nil];
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
    

    // init tweet view controllers
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.timelineArray count]; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // set scrollview content size as appropiate    
    CGSize contentSize = CGSizeMake(200.0*[self.timelineArray count], self.searchResultsScrollView.frame.size.height);
    [self.searchResultsScrollView setContentSize:contentSize];

    // load first and secong page in scroll view
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    // display first tweet in a separate view
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

#pragma mark -
#pragma mark ScrollView related methods
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= [self.timelineArray count])
        return;
    
    // replace the placeholder if necessary
    TweetViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[TweetViewController alloc] initWithNibName:@"TweetView" bundle:nil];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = searchResultsScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [searchResultsScrollView addSubview:controller.view];
        
        NSDictionary *tweet = [self.timelineArray objectAtIndex:page];
        // imagen
        NSURL *profileImageUrl = [NSURL URLWithString:[tweet valueForKey:@"profile_image_url"]];
        [controller setPhotoUrl:profileImageUrl];

        // titulo
        controller.titleLabel.text = [tweet valueForKey:@"from_user"];
        
        // texto
        controller.textLabel.text = [tweet valueForKey:@"text"];
        
        // link
        NSString *status = [NSString stringWithFormat:TWITTER_STATUS_URL, [tweet valueForKey:@"from_user"], [tweet valueForKey:@"id"]];
        NSURL *statusUrl = [NSURL URLWithString:status];
        controller.link = statusUrl;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = searchResultsScrollView.frame.size.width;
    int page = floor((searchResultsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

@end

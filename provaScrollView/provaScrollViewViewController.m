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
#import "FeedItemViewController.h"

#define TWITTER_SEARCH_URL @"http://search.twitter.com/search.json?q=%@"
#define TWITTER_STATUS_URL @"http://www.twitter.com/%@/status/%@"

/* private methods defined here */
@interface provaScrollViewViewController()
- (void) displayFirstTweet;
- (void) loadScrollView:(UIScrollView *) scrollView page:(int)page;
- (void) configureViewController:(UIViewController *) controller page:(int) page;
@end

@implementation provaScrollViewViewController

@synthesize searchResultsScrollView;
@synthesize timelineArray;
@synthesize lightTweetViewDemo;
@synthesize tweetViewControllers;
@synthesize feedItems;
@synthesize webContainerView;
@synthesize firstItemWebView;
@synthesize feedScrollView;
@synthesize feedViewControllers;

- (void)dealloc
{
    [searchResultsScrollView release];
    [lightTweetViewDemo release];
    [firstItemWebView release];
    [webContainerView release];
    [feedScrollView release];
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
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.webContainerView addGestureRecognizer:tapGesture]; 
    [tapGesture release];
    
}

- (void)viewDidUnload
{
    [self setSearchResultsScrollView:nil];
    [self setLightTweetViewDemo:nil];
    [self setFirstItemWebView:nil];
    [self setWebContainerView:nil];
    [self setFeedScrollView:nil];
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
    self.tweetViewControllers = controllers;
    [controllers release];
    
    // set scrollview content size as appropiate    
    CGSize contentSize = CGSizeMake(200.0*[self.timelineArray count], self.searchResultsScrollView.frame.size.height);
    [searchResultsScrollView setContentSize:contentSize];

    // load first and secong page in scroll view
    [self loadScrollView:searchResultsScrollView page:0];
    [self loadScrollView:searchResultsScrollView page:1];
    
    // display first tweet in a separate view
    [self displayFirstTweet];
}

- (IBAction)parseFeed:(id)sender {
    UITextField *textField = (UITextField *) sender;
    
    // empty array
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.feedItems = array;
    [array release];
    
    // code adapted from https://github.com/mwaterfall/MWFeedParser
    
    // Create feed parser and pass the URL of the feed
    NSURL *feedURL = [NSURL URLWithString:textField.text];
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    
    // Delegate must conform to `MWFeedParserDelegate`
    feedParser.delegate = self;
    
    // Parse the feeds info (title, link) and all feed items
    feedParser.feedParseType = ParseTypeFull;
    
    // Connection type
    feedParser.connectionType = ConnectionTypeSynchronously;
        
    // Begin parsing
    [feedParser parse];
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
- (void)loadScrollView:(UIScrollView *) scrollView page:(int)page;{
    BOOL isTweetScrollView = scrollView == searchResultsScrollView;
    NSArray *contentArray = isTweetScrollView ? self.timelineArray : self.feedItems;
    NSMutableArray *viewControllers = isTweetScrollView ? self.tweetViewControllers : self.feedViewControllers;
    
    if (page < 0)
        return;
    if (page >= [contentArray count])
        return;
    
    // replace the placeholder if necessary
    UIViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        if (isTweetScrollView) {
            controller = [[TweetViewController alloc] initWithNibName:@"TweetView" bundle:nil];
        } else {
            controller = [[FeedItemViewController alloc] initWithNibName:@"FeedItemView" bundle:nil];
        }
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
        
        
        // configure ViewController
        [self configureViewController:controller page:page];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollView:sender page:page - 1];
    [self loadScrollView:sender page:page];
    [self loadScrollView:sender page:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void) configureViewController:(UIViewController *) controller page:(int) page{
    if ([controller isKindOfClass:[TweetViewController class]]) {
        TweetViewController *tweetViewController = (TweetViewController *) controller;
        
        NSDictionary *tweet = [self.timelineArray objectAtIndex:page];
        // imagen
        NSURL *profileImageUrl = [NSURL URLWithString:[tweet valueForKey:@"profile_image_url"]];
        [tweetViewController setPhotoUrl:profileImageUrl];
        
        // titulo
        tweetViewController.titleLabel.text = [tweet valueForKey:@"from_user"];
        
        // texto
        tweetViewController.textLabel.text = [tweet valueForKey:@"text"];
        
        // link
        NSString *status = [NSString stringWithFormat:TWITTER_STATUS_URL, [tweet valueForKey:@"from_user"], [tweet valueForKey:@"id"]];
        NSURL *statusUrl = [NSURL URLWithString:status];
        tweetViewController.link = statusUrl;
        
        return;
    } 
    
    if ([controller isKindOfClass:[FeedItemViewController class]]) {
        FeedItemViewController *feedViewController = (FeedItemViewController *) controller;
        
        MWFeedItem *item = [feedItems objectAtIndex:page];

        // text
        [feedViewController setTextContent:item.content];
        
        // link
        NSURL *link = [NSURL URLWithString:item.link];
        feedViewController.link = link;
    }
}
#pragma mark -
#pragma mark MWFeedParser Delegate Method
// Provides info about a feed item
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    // add item into an array
    [self.feedItems addObject:item];    
}

// Parsing complete or stopped at any time by `stopParsing`
- (void)feedParserDidFinish:(MWFeedParser *)parser {
    
    // init tweet view controllers
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.feedItems count]; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.feedViewControllers = controllers;
    [controllers release];
    
    // set scrollview content size as appropiate    
    CGSize contentSize = CGSizeMake(200.0*[self.feedItems count], self.feedScrollView.frame.size.height);
    [feedScrollView setContentSize:contentSize];
    
    // load first and secong page in scroll view
    [self loadScrollView:feedScrollView page:0];
    [self loadScrollView:feedScrollView page:1];

    
    // first item in webview
    MWFeedItem *first = [feedItems objectAtIndex:0];
    [firstItemWebView loadHTMLString:first.content baseURL:nil];        
    // set tag with index in array for future use
    firstItemWebView.tag = 0;
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webView:didFailLoagWithError");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    MWFeedItem *item =[feedItems objectAtIndex:webView.tag];
    NSString *destination = [[request URL] absoluteString];
    NSLog(@"destination string: %@", destination);
    return [item.link isEqualToString:destination] || [@"about:blank" isEqualToString:destination];
}

- (void) tapAction:(UIGestureRecognizer *)gestureRecognizer {
    MWFeedItem *item =[feedItems objectAtIndex:firstItemWebView.tag];
    NSURL *link = [NSURL URLWithString:item.link];
    [[UIApplication sharedApplication] openURL:link];
}

@end

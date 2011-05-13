//
//  provaScrollViewViewController.h
//  provaScrollView
//
//  Created by Xavi Aracil on 11/05/11.
//  Copyright 2011 xadSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSLightTweetView.h"
#import "MWFeedParser.h"

@interface provaScrollViewViewController : UIViewController<MWFeedParserDelegate, UIWebViewDelegate> {
    
    UIScrollView *searchResultsScrollView;
    NSArray *timelineArray;
    XSLightTweetView *lightTweetViewDemo;

    // array of TweetViewControllers related to searchResultsScrollView
    NSMutableArray *tweetViewControllers;
    
    // array of feed items
    NSMutableArray *feedItems;
    UIView *webContainerView;
    UIWebView *firstItemWebView;

    // array of FeedItemViewController related to feedScrollView
    NSMutableArray *feedViewControllers;
    UIScrollView *feedScrollView;

}
@property (nonatomic, retain) IBOutlet UIScrollView *searchResultsScrollView;
@property (nonatomic, retain) IBOutlet NSArray *timelineArray;
@property (nonatomic, retain) IBOutlet XSLightTweetView *lightTweetViewDemo;
@property (nonatomic, retain) NSMutableArray *tweetViewControllers;
@property (nonatomic, retain) NSMutableArray *feedViewControllers;
@property (nonatomic, retain) NSMutableArray *feedItems;
@property (nonatomic, retain) IBOutlet UIView *webContainerView;
@property (nonatomic, retain) IBOutlet UIWebView *firstItemWebView;
@property (nonatomic, retain) IBOutlet UIScrollView *feedScrollView;

- (IBAction)search:(id)sender;
- (IBAction)parseFeed:(id)sender;
@end

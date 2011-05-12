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
    NSMutableArray *viewControllers;
    
    // array of feed items
    NSMutableArray *feedItems;
    UIView *webContainerView;
    UIWebView *firstItemWebView;

}
@property (nonatomic, retain) IBOutlet UIScrollView *searchResultsScrollView;
@property (nonatomic, retain) IBOutlet NSArray *timelineArray;
@property (nonatomic, retain) IBOutlet XSLightTweetView *lightTweetViewDemo;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSMutableArray *feedItems;
@property (nonatomic, retain) IBOutlet UIView *webContainerView;
@property (nonatomic, retain) IBOutlet UIWebView *firstItemWebView;

- (IBAction)search:(id)sender;
- (IBAction)parseFeed:(id)sender;
@end

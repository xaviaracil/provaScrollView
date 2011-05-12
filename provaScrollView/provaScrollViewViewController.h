//
//  provaScrollViewViewController.h
//  provaScrollView
//
//  Created by Xavi Aracil on 11/05/11.
//  Copyright 2011 xadSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSLightTweetView.h"

@interface provaScrollViewViewController : UIViewController {
    
    UIScrollView *searchResultsScrollView;
    NSArray *timelineArray;
    XSLightTweetView *lightTweetViewDemo;

    // array of TweetViewControllers related to searchResultsScrollView
    NSMutableArray *viewControllers;

}
@property (nonatomic, retain) IBOutlet UIScrollView *searchResultsScrollView;
@property (nonatomic, retain) IBOutlet NSArray *timelineArray;
@property (nonatomic, retain) IBOutlet XSLightTweetView *lightTweetViewDemo;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (IBAction)search:(id)sender;
@end

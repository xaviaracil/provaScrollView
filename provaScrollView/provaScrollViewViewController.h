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
    
    UIScrollView *publicTimelineScrollView;
    NSArray *timelineArray;
    XSLightTweetView *lightTweetViewDemo;
}
@property (nonatomic, retain) IBOutlet UIScrollView *publicTimelineScrollView;
@property (nonatomic, retain) IBOutlet NSArray *timelineArray;

@property (nonatomic, retain) IBOutlet XSLightTweetView *lightTweetViewDemo;

- (IBAction)search:(id)sender;
@end

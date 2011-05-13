//
//  FeedItemViewController.h
//  provaScrollView
//
//  Created by Xavi Aracil on 13/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedItemViewController : UIViewController {
    
    UIWebView *webView;
    NSURL *link;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSURL *link;

-(void) setTextContent:(NSString *) content;
@end

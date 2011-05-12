//
//  TweetViewController.h
//  provaScrollView
//
//  Created by Xavi Aracil on 12/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TweetViewController : UIViewController {
    
    UIImageView *photo;
    UILabel *titleLabel;
    UILabel *textLabel;
    NSURL *link;
}
@property (nonatomic, readonly) IBOutlet UIImageView *photo;
@property (nonatomic, readonly) IBOutlet UILabel *titleLabel;
@property (nonatomic, readonly) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) NSURL *link;

-(void) setPhotoUrl:(NSURL *) url;
@end

//
//  XSTweetView.h
//  provaScrollView
//
//  Created by Xavi Aracil on 11/05/11.
//  Copyright 2011 xadSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XSTweetView : UIView {
    // tweet text
    NSString *text;
    
    // Profile Image URL
    NSString *profileImageUrl;
    
    // Created At date
    NSString *createdAt;
}


@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *profileImageUrl;
@property (nonatomic, retain) NSString *createdAt;

@end

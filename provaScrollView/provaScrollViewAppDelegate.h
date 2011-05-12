//
//  provaScrollViewAppDelegate.h
//  provaScrollView
//
//  Created by Xavi Aracil on 11/05/11.
//  Copyright 2011 xadSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class provaScrollViewViewController;

@interface provaScrollViewAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet provaScrollViewViewController *viewController;

@end

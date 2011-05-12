//
//  XSLightTweetView.h
//  provaScrollView
//
//  Created by Xavi Aracil on 12/05/11.
//  Copyright 2011 xadSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XSLightTweetView : UIView {
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *textLabel;
}

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *textLabel;

@end

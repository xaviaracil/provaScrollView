//
//  XSLightTweetView.m
//  provaScrollView
//
//  Created by Xavi Aracil on 12/05/11.
//  Copyright 2011 xadSolutions. All rights reserved.
//

#import "XSLightTweetView.h"


@implementation XSLightTweetView

- (UIImageView *) imageView {
    if(!imageView) {
        CGRect imageFrame = CGRectMake(10.0, 10.0, 48.0, 48.0);
        imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        [self addSubview:imageView];
    }
    return imageView;
}

- (UILabel *) titleLabel {
    if (!titleLabel) {
        CGRect titleFrame = CGRectMake(68.0, 10.0, self.frame.size.width - 78.0, 12.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        // make label transparent
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
    }
    return titleLabel;
}

- (UILabel *) textLabel {
    if (!textLabel) {
        CGRect textFrame = CGRectMake(68.0, 27.0, self.frame.size.width - 78.0, self.frame.size.height - 42.0);
        textLabel = [[UILabel alloc] initWithFrame:textFrame];
        // make label transparent
        textLabel.backgroundColor = [UIColor clearColor];
        // make label multiline
        textLabel.numberOfLines = 4;
        textLabel.minimumFontSize = 8.0;
        textLabel.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:textLabel];
    }
    return textLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [imageView release];
    [titleLabel release];
    [textLabel release];
    [super dealloc];
}

@end

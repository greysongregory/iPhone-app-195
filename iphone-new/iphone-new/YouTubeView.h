//
//  YouTubeView.h
//  iphone-new
//
//  Created by Gregory Greyson on 12/5/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeView : UIWebView
{
}

- (YouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;

@end


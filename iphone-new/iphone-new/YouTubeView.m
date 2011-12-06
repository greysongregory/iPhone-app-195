//
//  YouTubeView.m
//  iphone-new
//
//  Created by Gregory Greyson on 12/5/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//
#import "YouTubeView.h"

@implementation YouTubeView

#pragma mark -
#pragma mark Initialization

- (YouTubeView *)initWithStringAsURL:(NSString *)urlString
{
    if (self = [super init]) 
    {

		// HTML to embed YouTube video
        NSString *youTubeVideoHTML = @"<html><head>\
        <body style=\"margin:0\">\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\"></embed>\
        </body></html>";
        
        // Populate HTML with the URL and requested frame size
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString];
        
        // Load the html into the webview
        [self loadHTMLString:html baseURL:nil];
        
        
	}
    
    return self;  
    
}

@end

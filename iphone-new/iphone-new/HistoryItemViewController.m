//
//  HistoryItemViewController.m
//  iphone-new
//
//  Created by Gregory Greyson on 12/4/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "HistoryItemViewController.h"
#import "LoadingView.h"
#import "YouTubeView.h"

@implementation HistoryItemViewController

@synthesize selectedIndex, selectedItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Change this to do logic for populating the search options: use exsisting pic, take pic, accel, location
    [outputLabel setText:selectedItem];
    [outputImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", selectedIndex]]];
    
    NSString *youTubeQueryURL = @"https://www.youtube.com/watch?v=P0OgzZpWNWY&feature=youtube_gdata name";
    
    LoadingView *loadingView = [LoadingView alloc];
    [loadingView setParentView:self];
    
    [self.navigationController pushViewController:loadingView animated:NO];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.center = loadingView.view.center;
    [loadingView.view addSubview: activityIndicator];
    [activityIndicator startAnimating];

    
    NSLog(@"creating youtube view");
    //display link to play video
    YouTubeView *youTubeView = [[YouTubeView alloc] 
                                initWithStringAsURL:youTubeQueryURL 
                                frame:CGRectMake(0, 0, 240, 240)];
    youTubeView.center = loadingView.view.center;
    
    [loadingView.view addSubview:youTubeView];
    [activityIndicator stopAnimating];
    
    [loadingView.view addSubview:youTubeView];
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

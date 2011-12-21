//
//  AccelerometerView.m
//  imageintent
//
//  Created by Vin on 12/20/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "AccelerometerView.h"

@implementation AccelerometerView
@synthesize xProgress;
@synthesize yProgress;
@synthesize zProgress;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setXProgress:nil];
    [self setYProgress:nil];
    [self setZProgress:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)touchDown {
    [controller startRecordingAccel];
}

- (IBAction)touchUp {
    [controller stopRecordingAccel];
}

- (void) setParent: (SearchViewController*) searchViewcontroller{
    controller = searchViewcontroller;
}
@end

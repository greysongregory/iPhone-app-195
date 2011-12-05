//
//  SearchViewController.m
//  iphone-new
//
//  Created by Gregory Greyson on 12/4/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "SearchViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
//#import "UIImagePickerController.h"

@implementation SearchViewController

- (IBAction)takePhoto:(id)sender
{
    takeOrChoose = 1;   
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
        NSLog(@"Camera is available and ready");
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
        // Delegate is self
        imagePicker.delegate = self;
    
        // Allow editing of image ?
        imagePicker.allowsImageEditing = NO;
    
        // Show image picker
        [self presentModalViewController:imagePicker animated:YES];
    }
    else
        NSLog(@"Camera is not available");

}

- (IBAction)choosePhoto:(id)sender
{
    takeOrChoose = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES)
    {
        NSLog(@"Photo Library is available and ready");
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        mediaUI.allowsEditing = NO;
        
        mediaUI.delegate = self;
        [self presentModalViewController: mediaUI animated: YES];
    }
}

- (IBAction)useAccelerometer:(id)sender
{
    
}

- (IBAction)useLocation:(id)sender
{
    
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	if(takeOrChoose)
    {
        NSError *error;
    
        // Access the uncropped image from info dictionary
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
        // Create paths to output images
        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
        // Write a UIImage to JPEG with minimum compression (best quality)
        // The value 'image' must be a UIImage object
        // The value '1.0' represents image compression quality as value from 0.0 to 1.0
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
        
        // Write image to PNG
        [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
        // Let's check to see if files were successfully written...
        // You can try this when debugging on-device
        
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
    
        // Point to Document directory
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
        // Write out the contents of home directory to console
        NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
        // Dismiss the camera
        [self dismissModalViewControllerAnimated:YES];
    
        //	[picker release];
    }
    else
    {
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        UIImage *originalImage, *editedImage, *imageToUse;
        
        // Handle a still image picked from a photo album,
        //__bridge handles casting
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) 
        {
            editedImage = (UIImage *) [info objectForKey:
                                       UIImagePickerControllerEditedImage];
            originalImage = (UIImage *) [info objectForKey:
                                         UIImagePickerControllerOriginalImage];
            
            if (editedImage) {
                imageToUse = editedImage;
            } else {
                imageToUse = originalImage;
            }
            // Do something with imageToUse
        }
        
        [[picker parentViewController] dismissModalViewControllerAnimated: YES];
        //   [picker release];
    }
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

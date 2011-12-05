//
//  HistoryItemViewController.h
//  iphone-new
//
//  Created by Gregory Greyson on 12/4/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryItemViewController : UIViewController
{
    NSString *selectedItem;
    NSInteger selectedIndex;
    IBOutlet UILabel *outputLabel;
    IBOutlet UIImageView *outputImage;
}

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) NSString *selectedItem;

@end

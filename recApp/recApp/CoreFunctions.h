//
//  CoreFunctions.h
//  recApp
//
//  Created by Vin on 12/3/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


AVAudioPlayer *audioPlayer; //Plays the audio


@interface CoreFunctions : NSObject

- (void) setup;
- (void)playAudio; //play the audio

void NSPrint (NSString *str);

void NSPrintUTF8 (NSString *str);

void NSPrintMac (NSString *str);

@end

//
//  CoreFunctions.m
//  recApp
//
//  Created by Vin on 12/3/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "CoreFunctions.h"
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation CoreFunctions


- (void) setup{
    //Declare the audio file location and settup the player
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:@"sound" withExtension:@"mp3"];
    
    NSError *error = [NSError alloc];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    [audioPlayer setNumberOfLoops:-1];
    
    if (error){
        NSPrint([error description]);
    }
        //Make sure the system follows our playback status
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        
        //Load the audio into memory
        [audioPlayer prepareToPlay];
     
}


- (void)playAudio {
    NSPrint(@"ddf\n");
    //Play the audio and set the button to represent the audio is playing
    [audioPlayer play];
    NSString *string = [audioPlayer isPlaying] ? @"yes" : @"no";
    NSPrint (string);
}

void NSPrint (NSString *str)
{
    [str writeToFile:@"/dev/stdout" atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

void NSPrintUTF8 (NSString *str)
{
    printf("%s", [str cStringUsingEncoding:NSUTF8StringEncoding]);
}

void NSPrintMac (NSString *str)
{
    printf("%s", [str cStringUsingEncoding:NSMacOSRomanStringEncoding]);
}





#if defined(TARGET_IPHONE_SIMULATOR)
#define LogMethod() printf("%s\n", [[NSString stringWithFormat:@"Simulator-[%@ %s]", self, _cmd] cStringUsingEncoding:NSUTF8StringEncoding]);
#else
#define LogMethod() NSLog(@"-[%@ %s]", self, _cmd])
#endif

@end

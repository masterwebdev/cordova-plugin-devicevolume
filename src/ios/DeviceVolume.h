#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import <Cordova/CDVPlugin.h>

@interface DeviceVolume : CDVPlugin {}

- (void) getDeviceVolume:(CDVInvokedUrlCommand*) command;
- (void) setDeviceVolume:(CDVInvokedUrlCommand*) command;
- (void) setDeviceVolumeChangeCallback:(CDVInvokedUrlCommand*) command;

@end
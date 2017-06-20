#import "DeviceVolume.h"

@implementation DeviceVolume {
    NSString* changeCallbackId;
    MPVolumeView* volumeView;
    UISlider* volumeViewSlider;
}


- (void) pluginInitialize {
    [super pluginInitialize];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
    
    volumeView = [[MPVolumeView alloc] init];
    volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
}

- (void) getDeviceVolume:(CDVInvokedUrlCommand*) command {
    [self sendCurrentVolumeTo:command.callbackId];
}

- (void) setDeviceVolume:(CDVInvokedUrlCommand*) command {
    
    if (volumeViewSlider != nil) {
        
        NSArray* arguments = command.arguments;
        int requiredVolumeDirection = [[arguments objectAtIndex:0] intValue];
        float volume = [self currentVolume];
        
        if (requiredVolumeDirection == 0) {
            volume -= 0.05;
        } else {
            volume += 0.05;
        }
        
        volume = volume < 0 ? 0 : (volume > 1 ? 1 : volume);
        
        [volumeViewSlider setValue:volume animated:NO];
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self sendCurrentVolumeTo:command.callbackId];
        
    } else {
        
        void MPVolumeSettingsAlertShow ( void );
        
    }
    
}

- (void) setDeviceVolumeChangeCallback:(CDVInvokedUrlCommand*) command {
    if (changeCallbackId) {
        NSLog(@"Overwriting volumeChangeCallback: %@", changeCallbackId);
    }
    
    changeCallbackId = command.callbackId;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (changeCallbackId && [keyPath isEqual:@"outputVolume"]) {
        [self sendCurrentVolumeTo:changeCallbackId];
    }
}

- (void) sendCurrentVolumeTo:(NSString*) callbackId {
    CDVPluginResult* result = [self CDVCurrentVolume];
    [result setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult: result callbackId:callbackId];
}

- (CDVPluginResult*) CDVCurrentVolume {
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:[self currentVolume]];
}

- (float) currentVolume {
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    float volume = audioSession.outputVolume;
    
    return volume;
}

@end
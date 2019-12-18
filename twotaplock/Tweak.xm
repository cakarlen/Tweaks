@interface SpringBoard : NSObject
- (void)_simulateLockButtonPress;
@end

@interface SBHomeScreenView : UIView
- (void)setFrame:(CGRect)arg1;
@end

UITapGestureRecognizer *tapGesture;
static NSString *const kPreferencesDomain = @"com.yexc.twotaplock";
static NSString *const kPreferencesPath   = @"/var/mobile/Library/Preferences/com.yexc.twotaplock.plist";
static NSString *nsNotificationString     = @"com.yexc.twotaplock/ReloadPrefs";

static BOOL isEnabled;
static CGFloat amountOfTaps;

static void loadPrefs() {
    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:kPreferencesPath];
    
    if(!preferences) {
        isEnabled = YES;
        amountOfTaps = [[preferences objectForKey:@"taps"] intValue];
    } else {
        isEnabled = [[preferences objectForKey:@"isEnabled"] boolValue];
        amountOfTaps = [[preferences objectForKey:@"taps"] intValue];
    }
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPrefs();
}

%hook SBHomeScreenView

-(void)setFrame:(CGRect)arg1 {
    //first let the method set the frame
    %orig;
    
    if (isEnabled) {
        //check if the gesture exists first
        if(tapGesture == nil) {
            //if it doesnt, create one
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lockDevice)];
            //set the number of taps
            tapGesture.numberOfTapsRequired = amountOfTaps;
            //add to the view
            [self addGestureRecognizer:tapGesture];
        }
    }
}

%new
-(void)lockDevice {
    [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];
}

%end

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
}

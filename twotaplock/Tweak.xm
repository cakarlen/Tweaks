#import <Cephei/HBPreferences.h>

HBPreferences *preferences;

static BOOL isEnabled;
static NSInteger amountOfTaps;

@interface SpringBoard : NSObject
- (void)_simulateLockButtonPress;
@end

@interface SBHomeScreenView : UIView
- (void)setFrame:(CGRect)arg1;
@end

UITapGestureRecognizer *tapGesture;

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
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yexc.twotaplockprefs"];
    [preferences registerDefaults:@{
        @"amountOfTaps": @2
    }];

    [preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
    [preferences registerInteger:(NSInteger *)&amountOfTaps default:2 forKey:@"taps"];
}

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
    
    //check if the gesture exists first
    if(tapGesture == nil) {
        //if it doesnt, create one
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lockDevice)];
        //set the number of taps
        tapGesture.numberOfTapsRequired = 2;
        //add to the view
        [self addGestureRecognizer:tapGesture];
    }
}

%new
-(void)lockDevice {
    [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];
}

%end

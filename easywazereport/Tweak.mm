#import <Foundation/Foundation.h>

@interface BottomViewVC
-(void)onReport;
+(id)sharedInstance;
@end

@interface WazeMainViewController
@property UIView *view;
-(void)onMapTapped;
-(_Bool)isRightPaneEnabled;
@end

@interface ReportViewController
@property UIView *view;
@end

// Misc settings
%hook WazeMainViewController

-(_Bool)isRightPaneEnabled {
    return NO;
}

- (void)onMapTapped {
    /*
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    */
    [[%c(BottomViewVC) sharedInstance] onReport];
    NSLog(@"WazeEnhancements: Map tapped!");
}

/*
%new
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [[%c(BottomViewVC) sharedInstance] onReport];
    }
}
*/

%end

// Faster animations throughout app
%hook WazeRootViewController

- (void)transitionToPresented:(id)arg1 deactivatingChildVC:(id)arg2 duration:(double)arg3 timingFunction:(id)arg4 {
    %orig(arg1, arg2, 0.0f, arg4);
}
    
- (void)transitionToDismissed:(id)arg1 reactivatingChildVC:(id)arg2 duration:(double)arg3 timingFunction:(id)arg4 {
    %orig(arg1, arg2, 0.0f, arg4);
}

- (void)dismissNavVC:(id)arg1 withDuration:(double)arg2 timingFunction:(id)arg3 {
    %orig(arg1, 0.0f, arg3);
}

- (void)presentNavVCWithRootVC:(id)arg1 duration:(double)arg2 timingFunction:(id)arg3 {
    %orig(arg1, 0.0f, arg3);
}

- (void)showChildVC:(id)arg1 duration:(double)arg2 timingFunction:(id)arg3 animations:(id)arg4 completion:(id)arg5 {
    %orig(arg1, 0.0f, arg3, arg4, arg5);
}

- (void)removeChildVC:(id)arg1 duration:(double)arg2 timingFunction:(id)arg3 animations:(id)arg4 completion:(id)arg5 {
    %orig(arg1, 0.0f, arg3, arg4, arg5);
}

- (void)setTypingWhileDrivingWarningViewShown:(bool)arg1 {
    %orig(NO);
}

- (void)setTypingWhileDrivingWarningView:(id)arg1 {
}

%end

// No report button
%hook BaseReportButton

- (void)layoutSubviews {
}

- (void)setup {
}

%end

// No music button
%hook StickyMusicVC

- (void)layoutSubviews {
}

%end

// No music button
%hook StickyMusicButton

- (void)layoutSubviews {
}

- (void)setup {
}

%end

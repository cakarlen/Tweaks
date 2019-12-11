@interface SBAppSwitcherOrbGestureSettings : NSObject
- (double)valueAlongDefaultForcePressCurveWithMinY:(double)arg1 progress:(double)arg2 fromHomeScreen:(BOOL)arg3;
@end

@interface SBAppSwitcherSettings : NSObject
- (void)setGridSwitcherSwipeUpNormalizedRubberbandingRange:(double)arg1;
- (void)setGridSwitcherSwipeUpNormalizedRubberbandedTranslationAtMinimumScale:(double)arg1;
- (void)setGridSwitcherSwipeUpMinimumScale:(double)arg1;
@end

@interface SBFluidSwitcherAnimationSettings : NSObject
- (void)setReduceMotionCrossfadeDuration:(double)arg1;
- (void)setIconZoomFloatingDockFadeDelay:(double)arg1;
@end

@interface SBHomeGestureSettings : NSObject
- (void)setMinimumYDistanceForHomeOrAppSwitcher:(double)arg1;
- (void)setPauseVelocityThresholdForDefiniteAppSwitcher:(double)arg1;
- (void)setCardFlyInDelayAfterEnteringAppSwitcher:(double)arg1;
- (void)setMaximumYDistanceToTriggerArcByDistance:(double)arg1;
- (void)setMaximumAdaptivePauseVelocityThresholdForAppSwitcher:(double)arg1;
@end

%hook SBAppSwitcherOrbGestureSettings

- (double)valueAlongDefaultForcePressCurveWithMinY:(double)arg1 progress:(double)arg2 fromHomeScreen:(BOOL)arg3 {
    return %orig(5, arg2, arg3);
}

%end

%hook SBAppSwitcherSettings

- (void)setGridSwitcherSwipeUpNormalizedRubberbandedTranslationAtMinimumScale:(double)arg1 {
    %orig(5);
}

- (void)setGridSwitcherSwipeUpMinimumScale:(double)arg1 {
    %orig(5);
}

%end

%hook SBFluidSwitcherAnimationSettings

- (void)setReduceMotionCrossfadeDuration:(double)arg1 {
    %orig(0);
}

- (void)setIconZoomFloatingDockFadeDelay:(double)arg1 {
    %orig(0);
}

%end

%hook SBHomeGestureSettings

- (void)setMinimumYDistanceForHomeOrAppSwitcher:(double)arg1 {
    NSLog(@"[AppSwitcher] Min Y distance for home/appswitcher: %f", arg1);
    %orig(0);
}

- (void)setPauseVelocityThresholdForDefiniteAppSwitcher:(double)arg1 {
    NSLog(@"[AppSwitcher] Pause buffer for appswitcher: %f", arg1);
    %orig(0);
}

- (void)setCardFlyInDelayAfterEnteringAppSwitcher:(double)arg1 {
    NSLog(@"[AppSwitcher] Card fly in delay: %f", arg1);
    %orig(0);
}

- (void)setMaximumYDistanceToTriggerArcByDistance:(double)arg1 {
    NSLog(@"[AppSwitcher] Max Y distance by distance: %f", arg1);
    %orig(0);
}

- (void)setMaximumAdaptivePauseVelocityThresholdForAppSwitcher:(double)arg1 {
    %orig(0);
}

%end

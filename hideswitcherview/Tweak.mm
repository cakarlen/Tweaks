#import "Tweak.h"

// Setup variables

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// Hooks
%hook SBAppSwitcherPageView
- (void)setOverlayAlpha:(double)arg1 {
    %orig(1);
}

- (void)setShadowStyle:(long long)arg1 {
    %orig(1);
}

- (void)setShadowAlpha:(double)arg1 {
    %orig(1);
}

- (void)setContentAlpha:(double)arg1 {
    %orig(0);
}
%end

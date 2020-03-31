#import "Tweak.h"

// Preferences variables
HBPreferences *preferences;
static BOOL isEnabled;
static BOOL spotlightHide;

// valid for iOS 13
%hook SBHIconModel

- (BOOL)isIconVisible:(SBIcon *)icon {
    if (isEnabled) {
        if (!spotlightHide) {
            if([SparkAppList doesIdentifier:@"com.yexc.hidejailbreakprefs" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
                return NO;
            }
        }
        
        return %orig;
    } else {
        return %orig;
    }
}

%end

%hook SBIconListModel

- (id)placeIcon:(SBIcon *)icon atIndex:(unsigned long long)arg2 {
    if (isEnabled && spotlightHide) {
        if([SparkAppList doesIdentifier:@"com.yexc.hidejailbreakprefs" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
            return nil;
        }
    }
    
    return %orig;
}

- (id)insertIcon:(SBIcon *)icon atIndex:(unsigned long long)arg2 options:(unsigned long long)arg3 {
    if (isEnabled && spotlightHide) {
        if([SparkAppList doesIdentifier:@"com.yexc.hidejailbreak" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
            return nil;
        }
    }
    
    return %orig;
}

- (BOOL)addIcon:(SBIcon *)icon asDirty:(BOOL)arg2 {
    if (isEnabled && spotlightHide) {
        if([SparkAppList doesIdentifier:@"com.yexc.hidejailbreak" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
            return false;
        }
    }
    
    return %orig;
}

%end

// Setup preferences
%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yexc.hidejailbreak"];
    [preferences registerDefaults:@{
        @"spotlightHide": @NO
    }];
    
    [preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
    [preferences registerBool:&spotlightHide default:NO forKey:@"spotlightHide"];
//    [preferences registerBool:&notAnimated default:YES forKey:@"notAnimated"];
//    [preferences registerBool:&manualRead default:YES forKey:@"manualRead"];
}

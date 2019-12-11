#import "SparkAppList.h"

// valid for iOS 13
@interface SBIcon
- (id)applicationBundleID;
@end

// valid for iOS 13
%hook SBHIconModel

- (BOOL)isIconVisible:(SBIcon *)icon {
    if([SparkAppList doesIdentifier:@"com.yexc.hidejailbreak" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
        return NO;
    }
    
    return %orig;
}

%end

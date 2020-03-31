#import "Tweak.h"

//#ifdef DEBUG
//    #define DLog(string, ...) os_log(OS_LOG_DEFAULT, ("%s [Line %d] " string), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
//#else
//#define DLog(...) os_log(OS_LOG_DEFAULT, ##__VA_ARGS__)
//#endif
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


// Preferences variables
HBPreferences *preferences;
static BOOL isEnabled;
static BOOL spotlightHide;

static NSString *prefsPlist = @"/var/mobile/Library/Preferences/com.yexc.hidemyassprefs.plist";
static NSString *origIconStatePath = @"/var/mobile/Library/SpringBoard/IconState.plist";
static NSString *iconStatePath = @"/var/mobile/Library/SpringBoard/IconState_HMA.plist";
static NSString *iconStateURL = @"file:///var/mobile/Library/SpringBoard/IconState_HMA.plist";

static SBIconModelPropertyListFileStore *iconModelStore;
static BOOL iconChanged;

//static BOOL doesPlist:(NSString *)path containApp:(NSString *)identifier atKey:(NSString *)key {
//    NSURL *plistURL = [NSURL fileURLWithPath:path];
//    NSError *error;
//    NSData *plistData = [NSData dataWithContentsOfURL:plistURL options:0 error:&error];
//
//    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plistData options:0 format:nil error:&error];
//    if (dictionary) {
//        if ([[dictionary objectForKey:key] isEqualToString:identifier]) {
//            return YES;
//        } else {
//            return NO;
//        }
//    }
//}

// valid for iOS 13
%hook SBHIconModel

- (BOOL)isIconVisible:(SBIcon *)icon {
    if (isEnabled && spotlightHide) {
        if([SparkAppList doesIdentifier:@"com.yexc.hidemyassprefs" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
            NSLog(@"Hiding '%@' from spotlight", icon.applicationBundleID);
            return NO;
        }
    }
    
    return %orig;
}

%end

%hook SBIconListModel

- (id)placeIcon:(SBIcon *)icon atIndex:(unsigned long long)arg2 {
    if (isEnabled && !spotlightHide) {
        if([SparkAppList doesIdentifier:@"com.yexc.hidemyassprefs" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
            NSLog(@"Hiding '%@' but still searchable", icon.applicationBundleID);
            
            iconChanged = YES;
            return nil;
        }
    }
    
    return %orig;
}

- (id)insertIcon:(SBIcon *)icon atIndex:(unsigned long long)arg2 options:(unsigned long long)arg3 {
    if (isEnabled && !spotlightHide) {
        if([SparkAppList doesIdentifier:@"com.yexc.hidemyassprefs" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
            NSLog(@"Hiding '%@' but still searchable", icon.applicationBundleID);
            
            return nil;
        }
    }
    
    return %orig;
}

- (BOOL)addIcon:(SBIcon *)icon asDirty:(BOOL)arg2 {
    if (isEnabled && !spotlightHide) {
        if([SparkAppList doesIdentifier:@"com.yexc.hidemyassprefs" andKey:@"hide" containBundleIdentifier:icon.applicationBundleID]) {
            NSLog(@"Hiding '%@' but still searchable", icon.applicationBundleID);
            
            iconChanged = YES;
            return false;
        }
    }
    
    return %orig;
}

%end

%hook SBIconModelPropertyListFileStore

- (id)init {
    iconModelStore = %orig;
    return iconModelStore;
}

- (BOOL)_save:(id)arg1 url:(id)arg2 error:(id*)arg3 {
    NSLog(@"Saved icon state: %@", arg1);
    
    if (isEnabled) {
        iconChanged = NO;
        
        NSLog(@"Saved tweaked icon state");
        return %orig(arg1, [NSURL URLWithString:iconStateURL], arg3);
    } else {
        return %orig;
    }
}

- (id)_load:(id)arg1 error:(id*)arg2 {
    if (isEnabled && iconChanged && [[NSFileManager defaultManager] fileExistsAtPath:iconStatePath]) {
        iconChanged = NO;
        
        NSLog(@"Loaded tweaked iconstate");
        return %orig([NSURL URLWithString:iconStateURL], arg2);
    } else {
        return %orig;
    }
}

%end

// Setup preferences
%ctor {
    NSLog(@"Loaded HMA");
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yexc.hidemyassprefs"];
    [preferences registerDefaults:@{
        @"spotlightHide": @NO
    }];
    
    [preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
    [preferences registerBool:&spotlightHide default:NO forKey:@"spotlightHide"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:iconStatePath]) {
        NSLog(@"Copying default iconstate for safety");
        [[NSFileManager defaultManager] copyItemAtPath:origIconStatePath toPath:iconStatePath error:nil];
    }
}

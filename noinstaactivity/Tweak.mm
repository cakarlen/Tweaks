#import "Tweak.h"

// Setup variables

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// Hooks
%hook IGLivePresenceService

- (id)initWithUserSession:(id)arg1 {
    return nil;
}

- (void)fetchPresence:(id)arg1 {
    return;
}

- (void)_fetchPresenceFromNetwork {
    return;
}

%end

%hook IGActivityStatusSettingService

- (id)initWithUserActions:(id)arg1 presenceManager:(id)arg2 {
    return nil;
}

%end

%hook IGUserSession

- (void)_checkIfStillAliveAfterDelay {
    return;
}

%end

%hook IGLiveRealtimeTopicHandlingService

- (void)startService {
    return;
}

%end

%hook IGDirectThreadViewController

- (void)_updateTypingStatusToActive:(BOOL)arg1 typingStatusType:(NSInteger)arg2 {
    %orig(NO, arg2);
}

%end

%hook IGActivityStatusSetting

- (id)initWithActivityStatusEnabled:(BOOL)arg1 threadActivityStatusEnabled:(BOOL)arg2 {
    return %orig(NO, NO);
}

%end

%hook IGMainFeedViewController

- (void)setupControllerHooks {
    return;
}

%end

%hook RABottomBannerView

- (void)layoutSubviews {
}

%end

%hook IGFollowController

- (void)_didPressFollowButton {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Hold up"
                                   message:@"Follow this user?"
                                   preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        %orig;
    }];
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {}];

    [alert addAction:yes];
    [alert addAction:no];
    
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;

    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }

    [rootViewController presentViewController:alert animated:YES completion:nil];
}

%end

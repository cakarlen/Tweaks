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

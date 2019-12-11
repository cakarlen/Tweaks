@interface CKMessagesController : UISplitViewController
- (void)_appStateChange:(id)arg1;
- (BOOL)isShowingConversationListController;
@end

@interface SMSApplication : UIApplication
- (id)init;
- (void)showTranscriptList;
- (void)showTranscriptListNotAnimated;
@end

@interface CKConversation : NSObject
- (id)init;

- (void)setLocalUserIsTyping:(BOOL)arg1;
- (BOOL)localUserIsTyping;
- (BOOL)hasUnreadMessages;
@end

@interface IMChatRegistry : NSObject
+ (id)sharedInstance;

- (void)_chat_sendReadReceiptForAllMessages:(id)arg1;
@end

static id conversation;
static id messagesController;
static id actualApp;

static NSString *const kPreferencesDomain = @"com.yexc.messagesxi";
static NSString *const kPreferencesPath   = @"/var/mobile/Library/Preferences/com.yexc.messagesxiprefs.plist";
static NSString *nsNotificationString     = @"com.yexc.messagesxi/ReloadPrefs";

static BOOL isEnabled;
static BOOL isAnimated;

static void loadPrefs() {
    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:kPreferencesPath];
    
    if(!preferences) {
        isEnabled = YES;
        isAnimated = NO;
    } else {
        isEnabled = [[preferences objectForKey:@"isEnabled"] boolValue];
        isAnimated = [[preferences objectForKey:@"isAnimated"] boolValue];
    }
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPrefs();
}

%hook SMSApplication

- (id)init {
    actualApp = self;
    return %orig;
}

%end

%hook CKMessagesController

- (id)init {
    messagesController = self;
    return %orig;
}

- (void)_appStateChange:(id)arg1 {
    if (isEnabled) {
        if (![self isShowingConversationListController]) {
            if (isAnimated) {
                [actualApp showTranscriptListNotAnimated];
            } else {
                [actualApp showTranscriptList];
            }
        }
    }

    %orig;
}

%end
    
%hook CKConversation

- (id)init {
    conversation = self;
    return %orig;
}

//- (void)setLocalUserIsTyping:(BOOL)arg1 {
//    [[%c(IMChatRegistry) sharedInstance] _chat_sendReadReceiptForAllMessages:0];
//    %orig;
//}

%end

%hook IMChatRegistry

- (void)_chat_sendReadReceiptForAllMessages:(id)arg1 {
    if (![messagesController isShowingConversationListController]) {
        return;
    } else {
        %orig;
    }
}

%end

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
}

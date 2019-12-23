#import <Cephei/HBPreferences.h>

HBPreferences *preferences;

static BOOL isEnabled;
static BOOL notAnimated;

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
-(void)_updateUnreadCountForChat:(id)arg1;
-(void)_chat:(id)arg1 sendReadReceiptForMessages:(id)arg2;
@end

@interface IMChat : NSObject
-(id)init;

-(void)markAllMessagesAsRead;
@end

@interface CKChatInputController : NSObject
@end

@interface CKNotificationChatController : NSObject
@end

static id conversation;
static id messagesController;
static id actualApp;

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

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
            if (notAnimated) {
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

%hook CKChatInputController

-(BOOL)_shouldSendTypingIndicatorDataForPluginIdentifier:(id)arg1 {
    return NO;
}

%end

%hook CKNotificationChatController

-(void)setLocalUserIsComposing:(BOOL)arg1 withPluginBundleID:(id)arg2 typingIndicatorData:(id)arg3 {
    return;
}

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
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yexc.messagesxiprefs"];
    [preferences registerDefaults:@{
        @"notAnimated": @YES
    }];

    [preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
    [preferences registerBool:&notAnimated default:YES forKey:@"notAnimated"];
}

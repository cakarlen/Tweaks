#import <Cephei/HBPreferences.h>

// Preferences variables
HBPreferences *preferences;
static BOOL isEnabled;
static BOOL notAnimated;
static BOOL manualRead;

@interface SMSApplication : UIApplication
- (id)init;
- (void)showTranscriptList;
- (void)showTranscriptListNotAnimated;
- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
@end

@interface IMChat : NSObject
- (id)init;

@property (getter=isGroupChat,nonatomic,readonly) BOOL groupChat;

-(unsigned long long)unreadMessageCount;
@end

@interface CKConversation : NSObject
@property (nonatomic,retain) IMChat *chat;
- (id)init;

- (void)setLocalUserIsTyping:(BOOL)arg1;
- (BOOL)localUserIsTyping;
- (BOOL)hasUnreadMessages;
@end

@interface CKMessagesController : UISplitViewController
@property (nonatomic,retain) CKConversation *currentConversation;

- (void)_appStateChange:(id)arg1;
- (BOOL)isShowingConversationListController;
@end

@interface IMChatRegistry : NSObject
+ (id)sharedInstance;

- (void)_chat_sendReadReceiptForAllMessages:(id)arg1;
@end

@interface CKMessageEntryView : UIView
- (BOOL)isSendingMessage;
@end

@interface CKChatInputController : NSObject
@property (nonatomic,retain) CKMessageEntryView *entryView;
@end

@interface CKNotificationChatController : NSObject
@end

@interface CKNavbarCanvasViewController : NSObject
@property UIView *view;
@end

@interface CKMessageEntryViewController : UIInputViewController
@property (nonatomic,readonly) CKMessageEntryView *entryView;
@end

// Get instances
static id conversation;
static id messagesController;
static id actualApp;
static id inputController;

// Variables
static BOOL didHitButton = NO;

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// Hook app to get object
%hook SMSApplication

- (id)init {
    actualApp = self;
    return %orig;
}

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    if (isEnabled) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackToTranscript) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return %orig;
}

%new
- (void)goBackToTranscript {
    if (notAnimated) {
        [actualApp showTranscriptListNotAnimated];
    } else {
        [actualApp showTranscriptList];
    }
}

%end

%hook CKMessagesController

- (id)init {
    messagesController = self;
    return %orig;
}

%end

%hook CKChatInputController

-(id)init {
    inputController = self;
    return %orig;
}

- (BOOL)_shouldSendTypingIndicatorDataForPluginIdentifier:(id)arg1 {
    return NO;
}

%end

%hook CKNotificationChatController

- (void)setLocalUserIsComposing:(BOOL)arg1 withPluginBundleID:(id)arg2 typingIndicatorData:(id)arg3 {
    return;
}

%end

%hook IMChatRegistry

- (void)_chat_sendReadReceiptForAllMessages:(id)arg1 {
    if (isEnabled) {
        if (manualRead) {
            if (didHitButton) {
                %orig;
            }
        } else {
            %orig;
        }
        
        if ([[inputController entryView] isSendingMessage]) {
            %orig;
        }
        
        if ([[[messagesController currentConversation] chat] isGroupChat]) {
            %orig;
        }
    } else {
        %orig;
    }
}

%end

%hook CKNavbarCanvasViewController

- (void)loadView {
    %orig;
    
    if (isEnabled) {
        if (manualRead) {
            if (![[[messagesController currentConversation] chat] isGroupChat] && ([[[messagesController currentConversation] chat] unreadMessageCount] != 0)) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button setTitle:@"Read" forState:UIControlStateNormal];
                button.frame = CGRectMake(325, -25, 50, 100); // Made specifically for iPhone X, 13.2.3 (may not be correct for all devices)
                [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:button];
            }
        }
    }
}

%new
- (void)buttonPressed {
    didHitButton = YES;
    [[%c(IMChatRegistry) sharedInstance] _chat_sendReadReceiptForAllMessages:[[messagesController currentConversation] chat]];
    didHitButton = NO;
}

%end

// Setup preferences
%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yexc.messagesxiprefs"];
    [preferences registerDefaults:@{
        @"notAnimated": @YES,
        @"manualRead": @YES
    }];
    
    [preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
    [preferences registerBool:&notAnimated default:YES forKey:@"notAnimated"];
    [preferences registerBool:&manualRead default:YES forKey:@"manualRead"];
}

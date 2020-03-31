#import <Cephei/HBPreferences.h>
#import "Tweak.h"

#define kBundlePath @"/Library/PreferenceBundles/MessagesXIPrefs.bundle"
static NSBundle *bundle;

// Preferences variables
HBPreferences *preferences;
static BOOL isEnabled;
static BOOL pushTranscriptList;
static BOOL hideTypingDots;

static BOOL readGroupChat;
static BOOL manualRead;

// Get instances
static id conversation;
static id messagesController;
static id actualApp;
static id inputController;
static id conversationListController;

// Variables
static BOOL didHitButton = NO;
static NSMutableDictionary *unreadChats;
static NSString *unreadPlist = @"/var/mobile/Library/Preferences/com.yexc.messagesxiunread.plist";

static NSUInteger selectedConvo;
static NSUInteger selectedConvoSwipe;

static NSNumber *badgeNumber;
static NSNumber *origBadgeNumber;

static CKConversation *getSelectedConvo(NSUInteger index) {
    return [[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:index];
}

// Hook app to get object
%hook SMSApplication

- (id)init {
    actualApp = self;
    return %orig;
}

%new
- (void)writeToPlistWithDict:(NSMutableDictionary *)data {
    if (data) {
        [data writeToFile:unreadPlist atomically:YES];
    }
}

%new
- (void)readChatWithReason:(NSString *)reason {
    if ([reason isEqualToString:@"swipe"]) {
        CKConversation *conversation = getSelectedConvo(selectedConvoSwipe);
        didHitButton = YES;
        [[%c(IMChatRegistry) sharedInstance] _chat_sendReadReceiptForAllMessages:[conversation chat]];
        didHitButton = NO;
        
        [[conversationListController tableView] reloadData];
    } else if ([reason isEqualToString:@"3d"]) {
        CKConversation *conversation = getSelectedConvo(selectedConvo);
        didHitButton = YES;
        [[%c(IMChatRegistry) sharedInstance] _chat_sendReadReceiptForAllMessages:[conversation chat]];
        didHitButton = NO;
        
        [[conversationListController tableView] reloadData];
    }
}

%new
- (void)unreadChatWithReason:(NSString *)reason {
    if ([reason isEqualToString:@"swipe"]) {
        if (![[unreadChats objectForKey:@"chats"] containsObject:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID]]) {
            NSMutableArray *writeChat = [[NSMutableArray alloc] initWithObjects:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID], nil];
            
            if ([[unreadChats objectForKey:@"chats"] count] != 0) {
                NSMutableArray *copyOfChats = [[unreadChats objectForKey:@"chats"] mutableCopy];
                [copyOfChats addObject:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID]];
                [unreadChats setValue:copyOfChats forKey:@"chats"];
                
                [self writeToPlistWithDict:unreadChats];
            } else {
                [unreadChats setObject:writeChat forKey:@"chats"];
                [self writeToPlistWithDict:unreadChats];
            }
            
            [[conversationListController tableView] reloadData];
        }
    }
}

%end

%hook CKMessagesController

- (id)init {
    messagesController = self;
    return %orig;
}

- (void)prepareForSuspend {
    if (isEnabled) {
        if (pushTranscriptList) {
            [self showConversationList:YES];
            %orig;
        }
    }
    
    origBadgeNumber = [[%c(FBSSystemService) sharedService] badgeValueForBundleID:@"com.apple.MobileSMS"];
    badgeNumber = [NSNumber numberWithInt:[[unreadChats objectForKey:@"chats"] count] + [origBadgeNumber intValue]];
    [[%c(FBSSystemService) sharedService] setBadgeValue:badgeNumber forBundleID:@"com.apple.MobileSMS"];
    
    %orig;
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

%hook CKConversation
%property (nonatomic,assign) BOOL hasOpened;

- (BOOL)hasUnreadMessages {
    if (isEnabled) {
        if (manualRead) {
            if ([[unreadChats objectForKey:@"chats"] containsObject:[[self chat] groupID]]) {
                return YES;
            }
        } else {
            return %orig;
        }
    }
    
    return %orig;
}

- (BOOL)_chatSupportsTypingIndicators {
    if (isEnabled) {
        if (hideTypingDots) {
            return NO;
        }
    }
    
    return %orig;
}

%end

// To change unread bubble based on unread status
%hook CKConversationListStandardCell

- (void)layoutSubviews {
    %orig;
    
    if (([[unreadChats objectForKey:@"chats"] containsObject:[[[messagesController currentConversation] chat] groupID]]) || ([[unreadChats objectForKey:@"chats"] containsObject:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID]])) {
        UIImageView *unreadImage = MSHookIvar<UIImageView *>(self, "_unreadIndicatorImageView");
        NSString *unreadBubble = [bundle pathForResource:@"unread_noReply" ofType:@"png"];

        [unreadImage setImage:[UIImage imageNamed:unreadBubble]];
    } else if ([[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvo] hasOpened]) {
        UIImageView *unreadImage = MSHookIvar<UIImageView *>(self, "_unreadIndicatorImageView");
        NSString *unreadBubble = [bundle pathForResource:@"unread_noReply" ofType:@"png"];

        [unreadImage setImage:[UIImage imageNamed:unreadBubble]];
    }
}

%end

%hook CKConversationListController

- (id)init {
    conversationListController = self;
    return %orig;
}

// Long press options
//- (id)contextMenuInteraction:(id)arg1 actionsForMenuAtLocation:(CGPoint)arg2 withSuggestedActions:(id)arg3 {
//    id orig = %orig;
//    HBLogInfo(@"Interaction: %@", arg1);
//    HBLogInfo(@"Actions: %@", arg3);
//    return orig;
//}

// Used to get UITableView selected row
- (id)tableView:(id)arg1 willSelectRowAtIndexPath:(id)arg2 {
    id orig = %orig;
    selectedConvo = [orig row];
    return orig;
}

- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2 {
    CKConversation *convo = [[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:[arg2 row]];
    if ([convo hasUnreadMessages]) {
        convo.hasOpened = YES;
    } else {
        convo.hasOpened = NO;
    }
    
    %orig;
}

// To fix default 3D touch and isEditing "Read" option
- (void)markAsReadButtonTappedForIndexPath:(id)arg1 {
    [actualApp readChatWithReason:@"3d"];
}

- (void)setEditing:(BOOL)arg1 animated:(BOOL)arg2 {
    %orig;
    
    if (arg1) {
        if ([[[%c(CKConversationList) sharedConversationList] conversations] count] != 0) {
            UIBarButtonItem *deleteAll = [[UIBarButtonItem alloc] initWithTitle:@"Delete all" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAll)];
            self.navigationItem.leftBarButtonItem = deleteAll;
        } else {
            UIBarButtonItem *deleteAll = [[UIBarButtonItem alloc] initWithTitle:@"Delete all" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAll)];
            self.navigationItem.leftBarButtonItem = deleteAll;
            self.navigationItem.leftBarButtonItem.enabled = NO;
        }
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

%new
- (void)deleteAll {
    CKConversationList *list = [%c(CKConversationList) sharedConversationList];
    NSUInteger msgCount = [[list conversations] count];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"MessagesXI"
                                   message:@"Delete all conversations?"
                                   preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        if (msgCount > 0) {
            [list deleteConversations:[list conversations]];
        }

        [self setEditing:NO animated:NO];
        [self.tableView reloadData];
    }];
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {}];

    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
}

// Swipe actions
- (id)tableView:(id)arg1 trailingSwipeActionsConfigurationForRowAtIndexPath:(id)arg2 {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/covert.dylib"]) {
        selectedConvoSwipe = [arg2 row];
        
        id orig = %orig;
        NSMutableArray *covertActions = [[orig actions] mutableCopy];
        
        UIContextualAction *readSwipe = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Read\nChat" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [actualApp readChatWithReason:@"swipe"];
        }];
        readSwipe.backgroundColor = [UIColor systemBlueColor];
        
        UIContextualAction *unreadSwipe = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Unread\nChat" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [actualApp unreadChatWithReason:@"swipe"];
        }];
        unreadSwipe.backgroundColor = [UIColor systemRedColor];
        
        
        [covertActions addObject:readSwipe];
        [covertActions addObject:unreadSwipe];
        UISwipeActionsConfiguration *newActions = [UISwipeActionsConfiguration configurationWithActions:covertActions];
        
        return newActions;
    } else {
        return %orig;
    }
}

%new
- (id)tableView:(id)arg1 leadingSwipeActionsConfigurationForRowAtIndexPath:(id)arg2 {
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/covert.dylib"]) {
        selectedConvoSwipe = [arg2 row];
        
        UIContextualAction *readSwipe = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Read\nChat" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [actualApp readChatWithReason:@"swipe"];
        }];
        readSwipe.backgroundColor = [UIColor systemBlueColor];
        
        UIContextualAction *unreadSwipe = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Unread\nChat" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [actualApp unreadChatWithReason:@"swipe"];
        }];
        unreadSwipe.backgroundColor = [UIColor systemRedColor];
        
        
        NSArray *swipeActions = @[readSwipe, unreadSwipe];
        UISwipeActionsConfiguration *newActions = [UISwipeActionsConfiguration configurationWithActions:swipeActions];
        
        return newActions;
    } else {
        return nil;
    }
}

//%new
//- (void)readChatWithReason:(NSString *)reason {
//    if ([reason isEqualToString:@"swipe"]) {
//        CKConversation *conversation = getSelectedConvo(selectedConvoSwipe);
//        didHitButton = YES;
//        [[%c(IMChatRegistry) sharedInstance] _chat_sendReadReceiptForAllMessages:[conversation chat]];
//        didHitButton = NO;
//
//        [self.tableView reloadData];
//    } else if ([reason isEqualToString:@"3d"]) {
//        CKConversation *conversation = getSelectedConvo(selectedConvo);
//        didHitButton = YES;
//        [[%c(IMChatRegistry) sharedInstance] _chat_sendReadReceiptForAllMessages:[conversation chat]];
//        didHitButton = NO;
//
//        [self.tableView reloadData];
//    }
//}
//
//%new
//- (void)unreadChatWithReason:(NSString *)reason {
//    if ([reason isEqualToString:@"swipe"]) {
//        if (![[unreadChats objectForKey:@"chats"] containsObject:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID]]) {
//                NSMutableArray *writeChat = [[NSMutableArray alloc] initWithObjects:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID], nil];
//
//                if ([[unreadChats objectForKey:@"chats"] count] != 0) {
//                    NSMutableArray *copyOfChats = [[unreadChats objectForKey:@"chats"] mutableCopy];
//                    [copyOfChats addObject:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID]];
//                    [unreadChats setValue:copyOfChats forKey:@"chats"];
//
//                    [actualApp writeToPlistWithDict:unreadChats];
//                } else {
//                    [unreadChats setObject:writeChat forKey:@"chats"];
//                    [actualApp writeToPlistWithDict:unreadChats];
//                }
//
////                [[%c(FBSSystemService) sharedService] setBadgeValue:badgeNumber forBundleID:@"com.apple.MobileSMS"];
//            }
//
//        [self.tableView reloadData];
//    }
//}

%end

%hook IMChatRegistry

- (void)_chat_sendReadReceiptForAllMessages:(id)arg1 {
    if (isEnabled) {
        if (manualRead) {
            if (didHitButton) {
                // Call to remove chat ID from unread chat plist
                if (([[unreadChats objectForKey:@"chats"] containsObject:[[[messagesController currentConversation] chat] groupID]]) || ([[unreadChats objectForKey:@"chats"] containsObject:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID]])) {
                    NSInteger index = [[unreadChats objectForKey:@"chats"] indexOfObject:[[[messagesController currentConversation] chat] groupID]];
                    NSInteger anotherIndex = [[unreadChats objectForKey:@"chats"] indexOfObject:[[[[[%c(CKConversationList) sharedConversationList] conversations] objectAtIndex:selectedConvoSwipe] chat] groupID]];
                    
                    @try {
                        [[unreadChats objectForKey:@"chats"] removeObjectAtIndex:index];
                    }
                    
                    @catch ( NSException *e ) {
                        [[unreadChats objectForKey:@"chats"] removeObjectAtIndex:anotherIndex];
                    }
                    
                    @finally {
                        [actualApp writeToPlistWithDict:unreadChats];
                    }
                }
                
                %orig;
            }
        } else {
            %orig;
        }
        
        if ([[inputController entryView] isSendingMessage]) {
            if ([[unreadChats objectForKey:@"chats"] containsObject:[[[messagesController currentConversation] chat] groupID]]) {
                NSInteger index = [[unreadChats objectForKey:@"chats"] indexOfObject:[[[messagesController currentConversation] chat] groupID]];
                [[unreadChats objectForKey:@"chats"] removeObjectAtIndex:index];
                
                [actualApp writeToPlistWithDict:unreadChats];
            }
            
            %orig;
        }
        
        if (readGroupChat) {
            if ([[[messagesController currentConversation] chat] isGroupChat]) {
                if ([[unreadChats objectForKey:@"chats"] containsObject:[[[messagesController currentConversation] chat] groupID]]) {
                    NSInteger index = [[unreadChats objectForKey:@"chats"] indexOfObject:[[[messagesController currentConversation] chat] groupID]];
                    [[unreadChats objectForKey:@"chats"] removeObjectAtIndex:index];
                    
                    [actualApp writeToPlistWithDict:unreadChats];
                }
                
                %orig;
            }
        }
    } else {
        %orig;
    }
}

%end

%hook CKNavbarCanvasViewController
//%hook CKMessageEntryView
//
//-(id)initWithFrame:(CGRect)arg1 marginInsets:(UIEdgeInsets)arg2 shouldAllowImpact:(BOOL)arg3 shouldShowSendButton:(BOOL)arg4 shouldShowSubject:(BOOL)arg5 shouldShowPluginButtons:(BOOL)arg6 shouldShowCharacterCount:(BOOL)arg7 traitCollection:(id)arg8 {
//    id orig = %orig(arg1, arg2, arg3, arg4, YES, arg6, arg7, arg8);
//
//    if (([[messagesController currentConversation] hasUnreadMessages] && ![[[messagesController currentConversation] chat] isGroupChat]) || ([[unreadChats objectForKey:@"chats"] containsObject:[[[messagesController currentConversation] chat] groupID]])) {
//        UIButton *readButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [readButton setTitle:@"Read" forState:UIControlStateNormal];
//        readButton.frame = CGRectMake(5, 0, 5, 5);
//        [readButton sizeToFit];
//        [readButton addTarget:self action:@selector(readChat) forControlEvents:UIControlEventTouchUpInside];
//
//        [self addSubview:readButton];
//    } else {
//        UIButton *unreadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [unreadButton setTitle:@"Unread" forState:UIControlStateNormal];
//        unreadButton.frame = CGRectMake(5, 0, 5, 5);
//        [unreadButton sizeToFit];
//        [unreadButton addTarget:self action:@selector(unreadChat) forControlEvents:UIControlEventTouchUpInside];
//
//        [self addSubview:unreadButton];
//    }
//
//    return orig;
//}

- (void)loadView {
    %orig;
    
    if (isEnabled) {
        if (manualRead) {
            if (!readGroupChat) {
                if ([[messagesController currentConversation] hasUnreadMessages] || [[unreadChats objectForKey:@"chats"] containsObject:[[[messagesController currentConversation] chat] groupID]]) {
                    UIButton *readButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    [readButton setTitle:@"Read" forState:UIControlStateNormal];
                    [readButton addTarget:self action:@selector(readChat) forControlEvents:UIControlEventTouchUpInside];

                    [self.canvasView setRightItemView:readButton];
                } else {
                   UIButton *unreadButton = [UIButton buttonWithType:UIButtonTypeSystem];
                   [unreadButton setTitle:@"Unread" forState:UIControlStateNormal];
                   [unreadButton addTarget:self action:@selector(unreadChat) forControlEvents:UIControlEventTouchUpInside];

                   [self.canvasView setRightItemView:unreadButton];
               }
            } else {
                if (([[messagesController currentConversation] hasUnreadMessages] && ![[[messagesController currentConversation] chat] isGroupChat]) || ([[unreadChats objectForKey:@"chats"] containsObject:[[[messagesController currentConversation] chat] groupID]])) {
                    UIButton *readButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    [readButton setTitle:@"Read" forState:UIControlStateNormal];
                    [readButton addTarget:self action:@selector(readChat) forControlEvents:UIControlEventTouchUpInside];

                    [self.canvasView setRightItemView:readButton];
                } else {
                    UIButton *unreadButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    [unreadButton setTitle:@"Unread" forState:UIControlStateNormal];
                    [unreadButton addTarget:self action:@selector(unreadChat) forControlEvents:UIControlEventTouchUpInside];

                    [self.canvasView setRightItemView:unreadButton];
                }
            }
        }
    }
}

%new
- (void)readChat {
    didHitButton = YES;
    [[%c(IMChatRegistry) sharedInstance] _chat_sendReadReceiptForAllMessages:[[messagesController currentConversation] chat]];
    didHitButton = NO;
}

%new
- (void)unreadChat {
    if (![[unreadChats objectForKey:@"chats"] containsObject:[[[messagesController currentConversation] chat] groupID]]) {
        NSMutableArray *writeChat = [[NSMutableArray alloc] initWithObjects:[[[messagesController currentConversation] chat] groupID], nil];
        
        if ([[unreadChats objectForKey:@"chats"] count] != 0) {
            NSMutableArray *copyOfChats = [[unreadChats objectForKey:@"chats"] mutableCopy];
            [copyOfChats addObject:[[[messagesController currentConversation] chat] groupID]];
            [unreadChats setValue:copyOfChats forKey:@"chats"];
            
            [actualApp writeToPlistWithDict:unreadChats];
        } else {
            
            [unreadChats setObject:writeChat forKey:@"chats"];
            [actualApp writeToPlistWithDict:unreadChats];
        }
    }
}

%end

// Setup preferences
%ctor {
    NSLog(@"[MessagesXI] Tweak init");
    
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yexc.messagesxiprefs"];
    [preferences registerDefaults:@{
        @"pushTranscriptList": @YES,
        @"hideTypingDots": @YES,
        @"manualRead": @YES,
        @"readGroupChat": @YES
    }];
    
    [preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
    [preferences registerBool:&pushTranscriptList default:YES forKey:@"pushTranscriptList"];
    [preferences registerBool:&hideTypingDots default:YES forKey:@"hideTypingDots"];
    
    [preferences registerBool:&manualRead default:YES forKey:@"manualRead"];
    [preferences registerBool:&readGroupChat default:YES forKey:@"readGroupChat"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:unreadPlist]) {
        unreadChats = [[NSMutableDictionary alloc] init];
        NSMutableArray *emptyArr = [[NSMutableArray alloc] init];

        [unreadChats setObject:emptyArr forKey:@"chats"];
        
        [unreadChats writeToFile:unreadPlist atomically:YES];
    }
    
    unreadChats = [[NSMutableDictionary alloc] initWithContentsOfFile:unreadPlist];
    bundle = [[NSBundle alloc] initWithPath:kBundlePath];
}

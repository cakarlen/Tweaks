#include "MESRootListController.h"
#include <spawn.h>

@implementation MESRootListController

static NSString *unreadPlist = @"/var/mobile/Library/Preferences/com.yexc.messagesxiunread.plist";

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)killMessages {
    pid_t pid;
    const char* args[] = { "killall", "-9", "MobileSMS", NULL };
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)clearUnreadPlist {
    NSMutableDictionary *unreadChats = [[NSMutableDictionary alloc] initWithContentsOfFile:unreadPlist];
    [[unreadChats objectForKey:@"chats"] removeAllObjects];
    [unreadChats writeToFile:unreadPlist atomically:YES];
}

@end

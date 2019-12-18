#include "YEXRootListController.h"
#include <spawn.h>

@implementation YEXRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring {
    pid_t pid;
    const char* args[] = { "sbreload", NULL };
    posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

@end

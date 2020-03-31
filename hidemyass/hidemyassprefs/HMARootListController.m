#include "HMARootListController.h"
#import "SparkAppListTableViewController.h"

#include <spawn.h>

@implementation HMARootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)selectHide {
    SparkAppListTableViewController *s = [[SparkAppListTableViewController alloc] initWithIdentifier:@"com.yexc.hidemyassprefs" andKey:@"hide"];
    
    [self.navigationController pushViewController:s animated:YES];
    self.navigationItem.hidesBackButton = FALSE;
}

- (void)respingTheShit {
    pid_t pid;
    const char* args[] = { "sbreload", NULL };
    posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

@end

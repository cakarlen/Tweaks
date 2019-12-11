#include "yexcRootListController.h"
#import "SparkAppListTableViewController.h"

#include <spawn.h>

@implementation yexcRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)selectHide
{
    // Replace "com.spark.notchlessprefs" and "excludedApps" with your strings
    SparkAppListTableViewController* s = [[SparkAppListTableViewController alloc] initWithIdentifier:@"com.yexc.hidejailbreak" andKey:@"hide"];
    
    [self.navigationController pushViewController:s animated:YES];
    self.navigationItem.hidesBackButton = FALSE;
}

- (void)respingTheShit {
    pid_t pid;
    const char* args[] = { "sbreload", NULL };
    posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

@end

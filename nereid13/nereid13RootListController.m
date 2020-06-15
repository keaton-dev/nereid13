#include "nereid13RootListController.h"
#include <spawn.h>

@implementation nereid13RootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring {
	pid_t pid;
	const char *argv[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
}

@end

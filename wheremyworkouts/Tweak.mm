#import <Cephei/HBPreferences.h>
#import "Tweak.h"

// Preferences variables
HBPreferences *preferences;
static BOOL isEnabled;

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// Hooks
%hook MailboxPickerController

%new
- (void)showWorkouts {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Workouts" message:@"Test" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)arg1 {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Workouts" style:UIBarButtonItemStylePlain target:self action:@selector(showWorkouts)];
    %orig;
}

%end

%hook MFMailboxFilter

- (id)initWithName:(id)arg1 description:(id)arg2 predicate:(id)arg3 {
    if (isEnabled) {
        return %orig(@"workout", arg2, arg3);
    } else {
        return %orig;
    }
}

%end

// Setup preferences
%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yexc.wheremyworkoutsprefs"];
    [preferences registerDefaults:@{
    }];
    
    [preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
}


/* Notes
MessageListViewController -> MessageListSearchViewController - holds search results

 
 MFMailMessage/EMMessage - stores data about individual email
 MFMailboxProvider - did/willFetch
*/

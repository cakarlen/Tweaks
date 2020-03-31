#import "Tweak.h"

// Setup variables
static UIView *tapView; // The view that acts like the snooze button

// Hooks
%hook CSFullscreenNotificationViewController

- (void)loadView {
    %orig;

    CGSize size = self.view.bounds.size;
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
//    [tapView removeFromSuperview];
    
    tapView = nil;
    tapView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:tapView];

    // Add the gesture recognizer to the view
    UITapGestureRecognizer *snoozeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSnooze)];
    snoozeTap.numberOfTapsRequired = 1;
    [tapView addGestureRecognizer:snoozeTap];
    
    UITapGestureRecognizer *stopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleStop)];
    stopTap.numberOfTapsRequired = 2;
    [tapView addGestureRecognizer:stopTap];
}

- (void)viewDidLayoutSubviews {
    %orig;
    [self.view bringSubviewToFront:tapView];
}

%new
- (void)toggleSnooze {
    [self performSelector:@selector(_handlePrimaryAction) withObject:self.view];
}

%new
- (void)toggleStop {
    [self performSelector:@selector(_handleSecondaryAction) withObject:self.view];
}

%end

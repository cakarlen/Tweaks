@interface SBHIconManager : NSObject
- (void)closeFolderAnimated:(BOOL)arg1 withCompletion:(/*^block*/id)arg2;
- (BOOL)hasOpenFolder;

- (void)triggerAutoFolderClose;
@end

@interface SBIconController : UIViewController
+ (id)sharedInstance;
+ (id)sharedInstanceIfExists;

@property (nonatomic,readonly) SBHIconManager *iconManager;
@end

@interface SBApplication : NSObject
- (BOOL)icon:(id)arg1 launchFromLocation:(id)arg2 context:(id)arg3;
@end

%hook SBHIconManager

%new
- (void)triggerAutoFolderClose {
    [self closeFolderAnimated:NO withCompletion:nil];
    NSLog(@"[FolderCloser] Folder is closed!");
}

%end

%hook SBApplication

- (BOOL)icon:(id)arg1 launchFromLocation:(id)arg2 context:(id)arg3 {
    SBIconController *iconController = [%c(SBIconController) sharedInstanceIfExists];
    
    if ([[iconController iconManager] hasOpenFolder]) {
        NSLog(@"[FolderCloser] Has open folder!");
        [[iconController iconManager] performSelector:@selector(triggerAutoFolderClose) withObject:nil afterDelay:0];
    }
    
    return %orig;
}

%end

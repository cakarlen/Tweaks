@interface CSCoverSheetViewControllerBase : UIViewController
@end

@interface CSModalViewControllerBase : CSCoverSheetViewControllerBase
@end

@interface CSFullscreenNotificationViewController : CSModalViewControllerBase
- (void)loadView;
- (void)_handlePrimaryAction;
- (void)_handleSecondaryAction;
- (void)_handleAction:(id)arg1 withName:(id)arg2;
@end

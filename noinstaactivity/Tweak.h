

@interface IGActivityStatusSettingService : NSObject
- (id)initWithUserActions:(id)arg1 presenceManager:(id)arg2;
@end

@interface IGLivePresenceService : NSObject
- (id)initWithUserSession:(id)arg1;
@end

@interface RABottomBannerView : UIView
@property BOOL hidden;
@property NSArray *subviews;
@end

@interface IGMainFeedViewController : UIViewController
@end

@interface IGFollowController : NSObject
- (void)_didPressFollowButton;
@end

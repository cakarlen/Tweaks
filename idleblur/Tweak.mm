//TODO: Save current backLight brightness - when user interacts -> restore orig brightness

static UIWindow *content = nil;

@interface SBBacklightController : NSObject
@property (nonatomic,readonly) double backlightFactor;
-(void)animateBacklightToFactor:(float)arg1 duration:(double)arg2 source:(long long)arg3 completion:(id)arg4;
@end

@interface SBIdleTimerPolicyAggregator : NSObject
-(void)idleTimerDidWarn:(id)arg1;
-(void)idleTimerDidResetForUserAttention:(id)arg1;
-(void)_removeIdleTimerHandler:(id)arg1;
-(void)idleTimerDidExpire:(id)arg1;
@end

@interface SpringBoard
- (void)resetIdleTimerAndUndim;
@end

static void destroyView(UIWindow *view) {
    [UIView animateWithDuration:0.25 animations:^{
        [view setAlpha:0.0];
    } completion:^(BOOL finished) {
        content = nil;
    }];
}

static double origBacklight;

%hook SBIdleTimerPolicyAggregator

-(void)idleTimerDidWarn:(id)arg1 {
    content = [[UIWindow alloc]initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
    content.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    content.hidden = NO;
    content.windowLevel = UIWindowLevelStatusBar;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = content.bounds;
    effectView.alpha = 0.0;
    [content addSubview:effectView];
    [UIView animateWithDuration:0.75 animations:^{
        [effectView setAlpha:1.0];
    } completion:nil];
}

-(void)idleTimerDidResetForUserAttention:(id)arg1 {
    %orig;
    destroyView(content);
}

-(void)_removeIdleTimerHandler:(id)arg1 {
    %orig;
    destroyView(content);
}

-(void)idleTimerDidExpire:(id)arg1 {
    %orig;
    destroyView(content);
}

-(void)idleTimerDidRefresh:(id)arg1 {
    %orig;
    destroyView(content);
}

%end

%hook SBBacklightController

-(void)animateBacklightToFactor:(float)arg1 duration:(double)arg2 source:(long long)arg3 completion:(id)arg4 {
    if(arg3 == 5 && arg4 == nil) {
        return;
    }
    origBacklight = self.backlightFactor;
    %orig;
}

%end

%hook SpringBoard

- (void)resetIdleTimerAndUndim {
    %orig;
    destroyView(content);
}

%end



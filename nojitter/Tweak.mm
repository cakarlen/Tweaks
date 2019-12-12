@interface SBHIconSettings : NSObject
- (void)setSuppressJitter:(BOOL)arg1;
@end

@interface SBIconImageView
@property (nonatomic, assign, readwrite) CGFloat alpha;
- (void)setJittering:(BOOL)arg1;
@end

%hook SBHIconSettings

- (void)setSuppressJitter:(BOOL)arg1 {
    %orig(YES);
}

%end

%hook SBIconImageView

- (void)setJittering:(BOOL)arg1 {
    if (arg1) {
        self.alpha = 0.5;
    } else {
        self.alpha = 1.0;
    }
}

%end

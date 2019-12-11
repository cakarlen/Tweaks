%hook SBIconColorSettings

@interface SBIconColorSettings
-(BOOL)suppressJitter;
@end

-(BOOL)suppressJitter {
    return YES;
}

%end

%hook SBIconImageView

@interface SBIconImageView
@property (nonatomic, assign, readwrite) CGFloat alpha;
-(void)setJittering:(BOOL)arg1;
@end

-(void)setJittering:(BOOL)arg1 {
    if (arg1) {
        self.alpha = 0.5;
    }
    if (!arg1) {
        self.alpha = 1.0;
    }
}

%end

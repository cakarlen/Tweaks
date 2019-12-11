@interface SPUISearchViewController
-(void)clearSearchResults;
-(void)didBeginEditing;
@end

%hook SPUISearchViewController

-(void)didBeginEditing {
	[self clearSearchResults];
	%orig;
}

%end
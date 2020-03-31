#import "SparkAppList.h"
#import <Cephei/HBPreferences.h>

// valid for iOS 13
@interface SBIcon
- (id)applicationBundleID;
@end

@interface SBIconListModel : NSObject
- (id)placeIcon:(id)arg1 atIndex:(unsigned long long)arg2;
- (id)insertIcon:(id)arg1 atIndex:(unsigned long long)arg2 options:(unsigned long long)arg3;
- (BOOL)addIcon:(id)arg1 asDirty:(BOOL)arg2;
@end

@interface SBIconModelPropertyListFileStore : NSObject
- (BOOL)_save:(id)arg1 url:(id)arg2 error:(id*)arg3;
- (id)_load:(id)arg1 error:(id*)arg2;
@end

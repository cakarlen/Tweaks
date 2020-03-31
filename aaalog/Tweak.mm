#import "Tweak.h"

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

%hookf(BOOL, "os_log_shim_enabled") {
    return NO;
}

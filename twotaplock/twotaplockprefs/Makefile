include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TwoTapLockPrefs
ARCHS = arm64

TwoTapLockPrefs_FILES = YEXRootListController.m
TwoTapLockPrefs_INSTALL_PATH = /Library/PreferenceBundles
TwoTapLockPrefs_FRAMEWORKS = UIKit
TwoTapLockPrefs_PRIVATE_FRAMEWORKS = Preferences
TwoTapLockPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TwoTapLockPrefs.plist$(ECHO_END)

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = WhereMyWorkoutsPrefs
ARCHS = arm64
TARGET = iphone:12.2:latest

WhereMyWorkoutsPrefs_FILES = WMWRootListController.m
WhereMyWorkoutsPrefs_INSTALL_PATH = /Library/PreferenceBundles
WhereMyWorkoutsPrefs_FRAMEWORKS = UIKit
WhereMyWorkoutsPrefs_PRIVATE_FRAMEWORKS = Preferences
WhereMyWorkoutsPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
WhereMyWorkoutsPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/WhereMyWorkoutsPrefs.plist$(ECHO_END)

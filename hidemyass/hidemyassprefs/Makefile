include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HideMyAssPrefs
ARCHS = arm64

HideMyAssPrefs_FILES = HMARootListController.m
HideMyAssPrefs_INSTALL_PATH = /Library/PreferenceBundles
HideMyAssPrefs_FRAMEWORKS = UIKit
HideMyAssPrefs_PRIVATE_FRAMEWORKS = Preferences
HideMyAssPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
HideMyAssPrefs_LIBRARIES = sparkapplist
HideMyAssPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/HideMyAssPrefs.plist$(ECHO_END)

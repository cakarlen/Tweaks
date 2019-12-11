include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MessagesXIPrefs
ARCHS = arm64

MessagesXIPrefs_FILES = YEXRootListController.m
MessagesXIPrefs_INSTALL_PATH = /Library/PreferenceBundles
MessagesXIPrefs_FRAMEWORKS = UIKit
MessagesXIPrefs_PRIVATE_FRAMEWORKS = Preferences
MessagesXIPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MessagesXIPrefs.plist$(ECHO_END)

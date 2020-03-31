INSTALL_TARGET_PROCESSES = SpringBoard

TARGET = iphone:clang:13.0:latest
ARCHS = arm64
PACKAGE_VERSION = 1.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideJailbreak
HideJailbreak_FILES = Tweak.xm
HideJailbreak_CFLAGS = -fobjc-arc
HideJailbreak_FRAMEWORKS = UIKit
HideJailbreak_EXTRA_FRAMEWORKS = Cephei
HideJailbreak_LIBRARIES = sparkapplist

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += hidejailbreakprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

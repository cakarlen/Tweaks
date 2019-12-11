INSTALL_TARGET_PROCESSES = SpringBoard
include $(THEOS)/makefiles/common.mk

ARCHS = arm64
PACKAGE_VERSION = 1.0

TWEAK_NAME = HideJailbreak
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_LIBRARIES = sparkapplist

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += hidejailbreak
include $(THEOS_MAKE_PATH)/aggregate.mk

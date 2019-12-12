INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS=arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BetterAppSwitcher

BetterAppSwitcher_FILES = Tweak.xm
BetterAppSwitcher_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

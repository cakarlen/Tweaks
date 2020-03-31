INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64
TARGET = iphone:clang:13.3:latest
FOR_RELEASE = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Snoozer
Snoozer_FILES = Tweak.xm
Snoozer_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

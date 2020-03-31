INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64
TARGET = iphone:clang:13.2:latest
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideSwitcherView
HideSwitcherView_FILES = Tweak.xm
HideSwitcherView_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

INSTALL_TARGET_PROCESSES = Instagram
ARCHS = arm64
TARGET = iphone:clang:13.2:latest
FOR_RELEASE = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoInstaActivity
NoInstaActivity_FILES = Tweak.xm
NoInstaActivity_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

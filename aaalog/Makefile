INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64
TARGET = iphone:clang:latest:latest
FOR_RELEASE = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AAALog
AAALog_FILES = Tweak.xm
AAALog_CFLAGS = -fobjc-arc #-Wno-missing-braces -Wmissing-field-initializers

include $(THEOS_MAKE_PATH)/tweak.mk

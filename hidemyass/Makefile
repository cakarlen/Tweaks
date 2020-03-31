INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64
TARGET = iphone:clang:13.0:latest
FOR_RELEASE = 0
DEBUG = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideMyAss
HideMyAss_FILES = Tweak.xm
HideMyAss_CFLAGS = -fobjc-arc
HideMyAss_EXTRA_FRAMEWORKS = Cephei
HideMyAss_LIBRARIES = sparkapplist

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += hidemyassprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

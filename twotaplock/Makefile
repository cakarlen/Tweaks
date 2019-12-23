INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64
PACKAGE_VERSION = 1.0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TwoTapLock

TwoTapLock_FILES = Tweak.xm
TwoTapLock_CFLAGS = -fobjc-arc
TwoTapLock_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += twotaplockprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

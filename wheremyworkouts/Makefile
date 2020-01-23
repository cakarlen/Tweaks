INSTALL_TARGET_PROCESSES = MobileMail
ARCHS = arm64
TARGET = iphone:clang:12.2:latest
FOR_RELEASE = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WhereMyWorkouts

WhereMyWorkouts_FILES = Tweak.xm
WhereMyWorkouts_CFLAGS = -fobjc-arc
WhereMyWorkouts_FRAMEWORKS = UIKit
WhereMyWorkouts_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += wheremyworkoutsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

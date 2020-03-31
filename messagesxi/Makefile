INSTALL_TARGET_PROCESSES = MobileSMS
ARCHS = arm64 arm64e
FOR_RELEASE = 1
TARGET = iphone:clang:13.0:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MessagesXI

MessagesXI_FILES = Tweak.xm
MessagesXI_CFLAGS = -fobjc-arc
MessagesXI_FRAMEWORKS = UIKit
MessagesXI_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += messagesxiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

include $(THEOS)/makefiles/common.mk

ARCHS = arm64
PACKAGE_VERSION = 1.0
TARGET = iphone:clang:latest:12.1

TWEAK_NAME = WazeEnhancements
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

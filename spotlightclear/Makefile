include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SpotlightClear
SpotlightClear_FILES = Tweak.xm
SpotlightClear_FRAMEWORKS = UIKit
ARCHS = arm64

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

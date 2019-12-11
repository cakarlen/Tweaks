include $(THEOS)/makefiles/common.mk

ARCHS = arm64
DEBUG=0
FINALVERSION=1.0

TWEAK_NAME = IdleBlur
IdleBlur_FILES = Tweak.xm
IdleBlur_FRAMEWORKS = UIKit
IdleBlur_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS)/makefiles/common.mk

ARCHS = arm64

DEBUG=0
FINALPACKAGE=1
GO_EASY_ON_ME=1

TWEAK_NAME = NoJitter
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

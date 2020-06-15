FINALPACKAGE = 1

ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nereid13

Nereid13_FILES = Tweak.xm UIImage+BlurAndDarken.m
Nereid13_CFLAGS = -fobjc-arc
Nereid13_PRIVATE_FRAMEWORKS += MediaRemote
Nereid13_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += nereid13
include $(THEOS_MAKE_PATH)/aggregate.mk

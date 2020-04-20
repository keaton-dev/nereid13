FINALPACKAGE = 0

export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:13.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nereid13

Nereid13_FILES = Tweak.xm UIImage+BlurAndDarken.m
Nereid13_CFLAGS = -fobjc-arc
Nereid13_PRIVATE_FRAMEWORKS += MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

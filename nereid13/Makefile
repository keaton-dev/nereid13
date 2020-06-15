ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Nereid13

Nereid13_FILES = nereid13RootListController.m
Nereid13_INSTALL_PATH = /Library/PreferenceBundles
Nereid13_FRAMEWORKS = UIKit
Nereid13_PRIVATE_FRAMEWORKS = Preferences
Nereid13_CFLAGS = -fobjc-arc
Nereid13_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/nereid13.plist$(ECHO_END)

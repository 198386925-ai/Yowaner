ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:14.0

# 默认按 rootless 打包（装到 var/jb/，适用于 Dopamine / roothide 这类越狱）。
# 要打 rootful 包，把下面这一行删掉即可。
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WCPlugins

WCPlugins_FILES = Tweak.x WCPluginModel.m WCPluginsMgr.m WCPluginsViewController.m WCPluginsDemoController.m
WCPlugins_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

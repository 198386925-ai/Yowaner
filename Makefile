# 只打 arm64，不打 arm64e：原版就是 arm64 单架构；旧工具链编出的 arm64e
# 切片在新款 arm64e 设备上会报 ABI 不兼容警告，启动时就可能闪退。
ARCHS = arm64
TARGET = iphone:clang:16.5:14.0

# 默认按 rootless 打包（装到 var/jb/，适用于 Dopamine / roothide 这类越狱）。
# 要打 rootful 包，把下面这一行删掉即可。
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WCPlugins

WCPlugins_FILES = Tweak.x WCPluginModel.m WCPluginsMgr.m WCPluginsViewController.m WCPluginsDemoController.m
WCPlugins_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

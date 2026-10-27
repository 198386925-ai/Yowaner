# 微信插件管理（重写版）

这是对 25mao「微信插件管理 / 微信插件收纳」（`com.25mao.wcplugins`）的**干净重写**，
不是原版源码，也没有使用原版的二进制文件。原版仓库里只有编译好的 deb，
没有源码；这里是根据它对外表现出来的功能（一个收纳插件的列表页）重新写的。

## 功能

- 注入微信后，在「我」页面（`MoreViewController`）的导航栏右侧加一个「插件」按钮，
  点进去就是插件列表页。
- 别的插件可以用同一套注册接口把自己登记进来，列表页会按登记内容显示：
  - 带页面的插件：行尾带箭头，点进去 push 它的页面；
  - 带开关的插件：行尾带开关，开关状态按 key 存到 `NSUserDefaults`。
- 自带两个演示项（一个页面、一个开关），确认页面能跑通后可以删掉，
  见 `Tweak.x` 底部的演示注册。

## 改布局只改一个文件

全部布局参数都在 `WCPluginsLayout.h` 里，改数字、颜色、字体大小就生效，
不用翻别的代码：

- `WCPluginsRowHeight`：行高
- `WCPluginsTitleFontSize` / `WCPluginsVersionFontSize`：标题、版本号字号
- `WCPluginsCellHorizontalInset`：左右边距
- `WCPluginsBackgroundColor` / `WCPluginsCellBackgroundColor` / `WCPluginsTitleColor` / `WCPluginsVersionColor`：颜色
- `WCPluginsTableViewStyle`：`UITableViewStyleInsetGrouped` 换成 `UITableViewStylePlain` 就是平铺列表
- `WCPluginsHeaderHeight` / `WCPluginsHeaderTitleFontSize`：页头高度和字号

## 注册接口（给别的插件用）

```objc
Class mgrClass = NSClassFromString(@"WCPluginsMgr");
id mgr = [mgrClass sharedMgr];

// 带页面的插件
[mgr registerControllerWithTitle:@"示例插件" version:@"1.0" controller:yourViewController];

// 带开关的插件
[mgr registerSwitchWithTitle:@"示例开关" key:@"com.example.switch"];
```

## 编译和安装

需要 Theos 环境（macOS 或 Linux 均可）：

```bash
export THEOS=/path/to/theos
make package
```

- 默认按 rootless 打包（`THEOS_PACKAGE_SCHEME = rootless`，装到 `var/jb/`）。
  要打 rootful 包，把 `Makefile` 里这一行删掉或改掉即可。
- 生成的 deb 装到越狱设备后，重启微信即可在「我」页面右上角看到「插件」按钮。
- 如果你的微信版本里 `MoreViewController` 这个类名或导航栏结构变了，
  入口在 `Tweak.x` 里标着「入口」的那一段，只改那一段就行，列表页和布局不用动。

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `Makefile` / `control` / `wcplugins.plist` | Theos 打包配置、deb 信息、注入过滤（只注入微信 `com.tencent.xin`） |
| `WCPluginsLayout.h` | 全部布局参数，改布局只改这里 |
| `WCPluginModel.h/.m` | 一个插件的数据：标题、版本、key、页面、是不是带页面 |
| `WCPluginsMgr.h/.m` | 插件注册表（单例），别的插件通过它登记 |
| `WCPluginsViewController.h/.m` | 插件列表页 |
| `WCPluginsDemoController.h/.m` | 演示插件页面，跑通后可删 |
| `Tweak.x` | 注入微信的入口 + 演示注册 |

## 注意

- 这是重写版，包名用的是 `com.youyou.wcplugins`，不会和原版 `com.25mao.wcplugins` 冲突，
  但两个不要同时装。
- 微信是闭源应用，不同版本的内部类名可能变化；入口失效时先看 `Tweak.x` 里的入口说明，
  不要直接改列表页代码。

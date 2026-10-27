// Tweak.x
// 注入微信的入口 + 演示注册。
// 列表页、注册表、布局都不在这里，改布局去 WCPluginsLayout.h，改入口只改下面标着「入口」的一段。

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "WCPluginsMgr.h"
#import "WCPluginsViewController.h"
#import "WCPluginsDemoController.h"

// ---------- 入口 ----------
// 微信「我」页面的控制器类名。不同微信版本这个类名可能变，
// 如果按钮出不来，先在这里把类名换成你那个版本的「我」页面控制器。
// 做法很保守：只在导航栏现有按钮后面追加一个「插件」按钮，不覆盖微信原有的按钮，
// 而且同一页面不会重复加。
%hook MoreViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    // Logos 只给 MoreViewController 生成了前向声明，不能直接给 self 发消息，
    // 先确认它是 UIViewController 再转，避免新版微信里这个类变了之后硬转崩溃。
    if (![(id)self isKindOfClass:[UIViewController class]]) return;
    UIViewController *vc = (UIViewController *)self;
    UINavigationItem *item = vc.navigationItem;
    if (item == nil) return;

    for (UIBarButtonItem *button in item.rightBarButtonItems) {
        if ([button.title isEqualToString:@"插件"]) return;
    }
    UIBarButtonItem *pluginButton = [[UIBarButtonItem alloc] initWithTitle:@"插件"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(wcplugins_openPluginsPage)];
    NSMutableArray *buttons = [NSMutableArray arrayWithArray:(item.rightBarButtonItems ?: @[])];
    [buttons addObject:pluginButton];
    item.rightBarButtonItems = buttons;
}

%new
- (void)wcplugins_openPluginsPage {
    UIViewController *vc = (UIViewController *)self;
    WCPluginsViewController *page = [[WCPluginsViewController alloc] init];
    UINavigationController *nav = vc.navigationController;
    if (nav != nil) {
        [nav pushViewController:page animated:YES];
    } else {
        UINavigationController *wrapped = [[UINavigationController alloc] initWithRootViewController:page];
        [vc presentViewController:wrapped animated:YES completion:nil];
    }
}

%end

// ---------- 演示注册 ----------
// 跑通后删掉这一段，列表就只剩别的插件自己登记的项。
static void WCPluginsRegisterDemo(void) {
    WCPluginsDemoController *demo = [[WCPluginsDemoController alloc] init];
    [[WCPluginsMgr sharedMgr] registerControllerWithTitle:@"示例插件"
                                                  version:@"1.0"
                                               controller:demo];
    [[WCPluginsMgr sharedMgr] registerSwitchWithTitle:@"示例开关"
                                                  key:@"com.youyou.wcplugins.demoSwitch"];
}

%ctor {
    WCPluginsRegisterDemo();
}

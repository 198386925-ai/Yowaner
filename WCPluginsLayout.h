// WCPluginsLayout.h
// 改布局只改这个文件，不用动别的代码。
// 这里的每一项都直接对应列表页上的一个视觉元素。

#import <UIKit/UIKit.h>

// 列表样式：InsetGrouped 是圆角分组列表；改成 UITableViewStylePlain 就是平铺列表。
static const UITableViewStyle WCPluginsTableViewStyle = UITableViewStyleInsetGrouped;

// 行高
static const CGFloat WCPluginsRowHeight = 56.0;

// 左右边距（标题离左边的距离、开关离右边的距离）
static const CGFloat WCPluginsCellHorizontalInset = 16.0;

// 标题、版本号字号
static const CGFloat WCPluginsTitleFontSize = 16.0;
static const CGFloat WCPluginsVersionFontSize = 13.0;

// 页头：高度、标题字号
static const CGFloat WCPluginsHeaderHeight = 52.0;
static const CGFloat WCPluginsHeaderTitleFontSize = 22.0;

// 颜色
static inline UIColor *WCPluginsBackgroundColor(void) {
    return [UIColor systemGroupedBackgroundColor];
}
static inline UIColor *WCPluginsCellBackgroundColor(void) {
    return [UIColor systemBackgroundColor];
}
static inline UIColor *WCPluginsTitleColor(void) {
    return [UIColor labelColor];
}
static inline UIColor *WCPluginsVersionColor(void) {
    return [UIColor secondaryLabelColor];
}
static inline UIColor *WCPluginsHeaderTitleColor(void) {
    return [UIColor labelColor];
}
static inline UIColor *WCPluginsSwitchTintColor(void) {
    return [UIColor systemGreenColor];
}

// 标题字体粗细：改成 UIFontWeightRegular 就是常规，UIFontWeightBold 就是粗体。
static inline UIFont *WCPluginsTitleFont(void) {
    return [UIFont systemFontOfSize:WCPluginsTitleFontSize weight:UIFontWeightSemibold];
}
static inline UIFont *WCPluginsVersionFont(void) {
    return [UIFont systemFontOfSize:WCPluginsVersionFontSize weight:UIFontWeightRegular];
}
static inline UIFont *WCPluginsHeaderTitleFont(void) {
    return [UIFont systemFontOfSize:WCPluginsHeaderTitleFontSize weight:UIFontWeightBold];
}

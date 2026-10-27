// 插件注册表（单例）。
// 别的插件登记自己就调这两个方法，接口名和原版保持一致，
// 这样原来按原版接口写的登记代码不用改就能用。

#import <UIKit/UIKit.h>

@class WCPluginModel;

@interface WCPluginsMgr : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<WCPluginModel *> *plugins;

+ (instancetype)sharedMgr;
+ (instancetype)sharedInstance;
+ (instancetype)defaultMgr;

// 带页面的插件：登记后列表里点它就 push controller。
- (void)registerControllerWithTitle:(NSString *)title
                            version:(NSString *)version
                         controller:(UIViewController *)controller;

// 带开关的插件：开关状态按 key 存 NSUserDefaults。
- (void)registerSwitchWithTitle:(NSString *)title
                            key:(NSString *)key;

- (BOOL)switchValueForKey:(NSString *)key;
- (void)setSwitchValue:(BOOL)value forKey:(NSString *)key;

@end

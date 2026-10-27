// 一个插件的数据：标题、版本、开关 key、页面。
// isController = YES 表示点进去进页面；NO 表示行尾是个开关。

#import <UIKit/UIKit.h>

@interface WCPluginModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, assign) BOOL isController;

+ (instancetype)modelWithTitle:(NSString *)title
                       version:(NSString *)version
                    controller:(UIViewController *)controller;

+ (instancetype)modelWithTitle:(NSString *)title
                           key:(NSString *)key;

@end

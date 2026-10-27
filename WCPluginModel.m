#import "WCPluginModel.h"

@implementation WCPluginModel

+ (instancetype)modelWithTitle:(NSString *)title
                       version:(NSString *)version
                    controller:(UIViewController *)controller {
    WCPluginModel *model = [[self alloc] init];
    model.title = title;
    model.version = version;
    model.controller = controller;
    model.isController = YES;
    return model;
}

+ (instancetype)modelWithTitle:(NSString *)title
                           key:(NSString *)key {
    WCPluginModel *model = [[self alloc] init];
    model.title = title;
    model.key = key;
    model.isController = NO;
    return model;
}

@end

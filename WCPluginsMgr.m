#import "WCPluginsMgr.h"
#import "WCPluginModel.h"

@implementation WCPluginsMgr

+ (instancetype)sharedMgr {
    static WCPluginsMgr *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (instancetype)sharedInstance {
    return [self sharedMgr];
}

+ (instancetype)defaultMgr {
    return [self sharedMgr];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _plugins = [NSMutableArray array];
    }
    return self;
}

- (void)registerControllerWithTitle:(NSString *)title
                            version:(NSString *)version
                         controller:(UIViewController *)controller {
    if (title.length == 0 || controller == nil) return;
    WCPluginModel *model = [WCPluginModel modelWithTitle:title
                                                 version:version
                                              controller:controller];
    @synchronized(self.plugins) {
        [self.plugins addObject:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WCPluginsDidChangeNotification"
                                                        object:nil];
}

- (void)registerSwitchWithTitle:(NSString *)title
                            key:(NSString *)key {
    if (title.length == 0 || key.length == 0) return;
    WCPluginModel *model = [WCPluginModel modelWithTitle:title key:key];
    @synchronized(self.plugins) {
        [self.plugins addObject:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WCPluginsDidChangeNotification"
                                                        object:nil];
}

- (BOOL)switchValueForKey:(NSString *)key {
    if (key.length == 0) return NO;
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setSwitchValue:(BOOL)value forKey:(NSString *)key {
    if (key.length == 0) return;
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}

@end

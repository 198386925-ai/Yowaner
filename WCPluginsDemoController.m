#import "WCPluginsDemoController.h"

@implementation WCPluginsDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"示例插件";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20, 0)];
    label.text = @"这是演示插件页面。\n把 Tweak.x 里的演示注册删掉后，这里就不会再出现在列表里。";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:label];
}

@end

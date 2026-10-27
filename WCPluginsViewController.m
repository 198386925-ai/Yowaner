#import "WCPluginsViewController.h"
#import "WCPluginsLayout.h"
#import "WCPluginsMgr.h"
#import "WCPluginModel.h"

@interface WCPluginsViewController ()

@property (nonatomic, strong) NSArray<WCPluginModel *> *snapshot;

@end

@implementation WCPluginsViewController

- (instancetype)init {
    self = [super initWithStyle:WCPluginsTableViewStyle];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信插件管理";
    self.tableView.backgroundColor = WCPluginsBackgroundColor();
    self.tableView.rowHeight = WCPluginsRowHeight;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, WCPluginsCellHorizontalInset, 0, 0);
    [self reloadSnapshot];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadSnapshot)
                                                 name:@"WCPluginsDidChangeNotification"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadSnapshot {
    // 注册可能发生在任意线程，UIKit 刷新必须回主线程，否则必崩。
    NSArray<WCPluginModel *> *copy = nil;
    @synchronized([WCPluginsMgr sharedMgr].plugins) {
        copy = [[WCPluginsMgr sharedMgr].plugins copy];
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.snapshot = copy;
            [self.tableView reloadData];
        });
        return;
    }
    self.snapshot = copy;
    [self.tableView reloadData];
}

#pragma mark - 页头

- (UIView *)wcpluginsHeaderView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, WCPluginsHeaderHeight)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(header.bounds, WCPluginsCellHorizontalInset, 0)];
    label.text = @"微信插件管理";
    label.font = WCPluginsHeaderTitleFont();
    label.textColor = WCPluginsHeaderTitleColor();
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [header addSubview:label];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // InsetGrouped 下用一个自定义页头；Plain 样式下系统自带区头就够了。
    if (WCPluginsTableViewStyle == UITableViewStyleInsetGrouped) {
        return [self wcpluginsHeaderView];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (WCPluginsTableViewStyle == UITableViewStyleInsetGrouped) {
        return WCPluginsHeaderHeight;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - 列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.snapshot.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WCPluginCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.backgroundColor = WCPluginsCellBackgroundColor();
    cell.textLabel.font = WCPluginsTitleFont();
    cell.textLabel.textColor = WCPluginsTitleColor();
    cell.detailTextLabel.font = WCPluginsVersionFont();
    cell.detailTextLabel.textColor = WCPluginsVersionColor();

    // 快照可能在刷新间隙变化，越界直接给空行，绝不崩。
    if (indexPath.row < 0 || indexPath.row >= self.snapshot.count) {
        cell.textLabel.text = nil;
        return cell;
    }
    WCPluginModel *model = self.snapshot[indexPath.row];
    cell.textLabel.text = model.title;

    if (model.isController) {
        cell.detailTextLabel.text = model.version;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *sw = [[UISwitch alloc] init];
        sw.onTintColor = WCPluginsSwitchTintColor();
        sw.on = [[WCPluginsMgr sharedMgr] switchValueForKey:model.key];
        sw.tag = indexPath.row;
        [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    }
    return cell;
}

- (void)switchChanged:(UISwitch *)sender {
    if (sender.tag < 0 || sender.tag >= self.snapshot.count) return;
    WCPluginModel *model = self.snapshot[sender.tag];
    if (model.key.length == 0) return;
    [[WCPluginsMgr sharedMgr] setSwitchValue:sender.isOn forKey:model.key];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 0 || indexPath.row >= self.snapshot.count) return;
    WCPluginModel *model = self.snapshot[indexPath.row];
    if (model.isController && model.controller != nil) {
        model.controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:model.controller animated:YES];
    }
}

@end

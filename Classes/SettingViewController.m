#import "SettingViewController.h"
#import "TVListingsAppDelegate.h"
#import "RegionSettingViewController.h"
#import "PrimeTimeSettingViewController.h"
#import "TimeWidthSettingViewController.h"
#import "Debug.h"

@implementation SettingViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings", nil);
}

- (void)fontSizeChanged:(UISegmentedControl *)sender {
	LOG(@"font size changed: %d", [sender selectedSegmentIndex]);
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	settings.fontSize = [sender selectedSegmentIndex];
}

#pragma mark <UITableViewDataSource> Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Region", nil);
	} else if (section == 1) {
		return NSLocalizedString(@"PrimeTime", nil);
	} else if (section == 2) {
		return NSLocalizedString(@"TimeWidth", nil);
	} else {
		return NSLocalizedString(@"FontSize", nil);
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 40.0f;
	} else {
		return 26.0f;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
    
    NSString *identifier = [NSString stringWithFormat:@"%d%d", indexPath.section, indexPath.row];
	
	if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            if (indexPath.section == 0) {
                cell.text = [[TVListingsAppDelegate regionList] objectAtIndex:[settings.area intValue] -1];
            } else if (indexPath.section == 1) {
                cell.text = [NSString stringWithFormat:@"%@ - %@", settings.primeTimeFrom, settings.primeTimeTo];
            } else {
                cell.text = [NSString stringWithFormat:NSLocalizedString(@"TimeWidthFormat", nil), settings.lhour];
            }
        }
		
		return cell;
	} else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISegmentedControl *fontSizeSelector = [[[UISegmentedControl alloc]
                                                     initWithItems:[NSArray arrayWithObjects:@"S", @"M", @"L", @"XL", nil]] autorelease];
            [fontSizeSelector setFrame:CGRectMake(9.0f, 0.0f, 302.0f, 45.0f)];
            [fontSizeSelector setSelectedSegmentIndex:settings.fontSize];
            [fontSizeSelector addTarget:self action:@selector(fontSizeChanged:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:fontSizeSelector];
        }
		
		return cell;
	}
}

#pragma mark <UITableViewDelegate> Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		RegionSettingViewController *controller = [[[RegionSettingViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
		controller.title = NSLocalizedString(@"Region", nil);
		[self.navigationController pushViewController:controller animated:YES];
	} else if (indexPath.section == 1) {
		PrimeTimeSettingViewController *controller = [[[PrimeTimeSettingViewController alloc] init] autorelease];
		controller.title = NSLocalizedString(@"PrimeTime", nil);
		[self.navigationController pushViewController:controller animated:YES];
	} else {
		TimeWidthSettingViewController *controller = [[[TimeWidthSettingViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
		controller.title = NSLocalizedString(@"TimeWidth", nil);
		[self.navigationController pushViewController:controller animated:YES];
	}

}

@end

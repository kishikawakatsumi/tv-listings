#import "RegionSettingViewController.h"
#import "TVListingsAppDelegate.h"
#import "Debug.h"

@implementation RegionSettingViewController

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[self.tableView setDelegate:nil];
    [super dealloc];
}

#pragma mark <UITableViewDataSource> Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[TVListingsAppDelegate regionList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	if ([settings.area intValue] == indexPath.row + 1) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.text = [[TVListingsAppDelegate regionList] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark <UITableViewDelegate> Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	
	[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[settings.area intValue] -1 inSection:indexPath.section]]
	 setAccessoryType:UITableViewCellAccessoryNone];
	
	NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setPositiveFormat:@"000"];
	settings.area = [formatter stringFromNumber:[NSNumber numberWithInt:indexPath.row + 1]];
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

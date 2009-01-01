#import "TimeWidthSettingViewController.h"
#import "TVListingsAppDelegate.h"
#import "Debug.h"

@implementation TimeWidthSettingViewController

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
	return 23;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	if (settings.lhour == indexPath.row + 1) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.text = [NSString stringWithFormat:NSLocalizedString(@"TimeWidthFormat", nil), indexPath.row + 1];
    return cell;
}

#pragma mark <UITableViewDelegate> Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	
	[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:settings.lhour -1 inSection:indexPath.section]]
	 setAccessoryType:UITableViewCellAccessoryNone];
	
	settings.lhour = indexPath.row + 1;
	sharedTVListingsApp.lhour = settings.lhour;
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

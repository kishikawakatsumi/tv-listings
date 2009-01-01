#import "SearchBookmarkViewController.h"
#import "TVSearchViewController.h"
#import "TVListingsAppDelegate.h"
#import "Settings.h"
#import "Debug.h"

@implementation SearchBookmarkViewController

@synthesize keywordHistoryView;
@synthesize tvSearchViewController;

#pragma mark <UITableViewDataSource> Methods

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[tvSearchViewController release];
	[keywordHistoryView setDelegate:nil];
	[keywordHistoryView release];
    [super dealloc];
}

- (IBAction)clearButtonClicked {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	[settings.keywordHistory removeAllObjects];
	[keywordHistoryView reloadData];
}

- (IBAction)cancelButtonClicked {
	[tvSearchViewController hideWaitingView];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)searchByKeyword {
	[tvSearchViewController refleshData:nil];
}

#pragma mark <UITableViewDataSource> Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	return [settings.keywordHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	cell.text = [settings.keywordHistory objectAtIndex:[settings.keywordHistory count] - 1 - indexPath.row];
    return cell;
}

#pragma mark <UITableViewDelegate> Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	tvSearchViewController.keyword = [settings.keywordHistory objectAtIndex:[settings.keywordHistory count] - 1 - indexPath.row];
	tvSearchViewController.tvSearchBar.text = tvSearchViewController.keyword;
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(searchByKeyword) userInfo:nil repeats:NO];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[settings.keywordHistory removeObjectAtIndex:[settings.keywordHistory count] - 1 - indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

#pragma mark <UIViewController> Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

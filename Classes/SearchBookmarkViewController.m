#import "SearchBookmarkViewController.h"
#import "TVSearchViewController.h"
#import "TVListingsAppDelegate.h"
#import "Settings.h"
#import "Debug.h"

@implementation SearchBookmarkViewController

@synthesize tvSearchViewController;

- (void)dealloc {
    [super dealloc];
}

- (IBAction)clearButtonClicked:(id)sender {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	[settings.keywordHistory removeAllObjects];
	[keywordHistoryView reloadData];
}

- (IBAction)cancelButtonClicked:(id)sender {
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

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
    self.view = contentView;
    [contentView release];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    navigationBar.barStyle = UIBarStyleBlackOpaque;
    [contentView addSubview:navigationBar];
    [navigationBar release];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearButtonClicked:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked:)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"History", nil)];
    navigationItem.leftBarButtonItem = clearButton;
    [clearButton release];
    navigationItem.rightBarButtonItem = cancelButton;
    [cancelButton release];
    [navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
    [navigationItem release];
    
    keywordHistoryView  = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 416.0f)];
    keywordHistoryView.dataSource = self;
    keywordHistoryView.delegate = self;
    [contentView addSubview:keywordHistoryView];
    [keywordHistoryView release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

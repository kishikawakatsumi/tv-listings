#import "TVSearchViewController.h"
#import "SearchBookmarkViewController.h"
#import "WaitingView.h"
#import "TVListingsAppDelegate.h"
#import "Settings.h"
#import "Debug.h"

@implementation TVSearchViewController

@synthesize tvSearchBar;
@synthesize keyword;

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[waitingView release];
	[keyword release];
	[tvSearchBar release];
    [super dealloc];
}

- (CGRect)preferredSize {
	return CGRectMake(tvListView.frame.origin.x, tvListView.frame.origin.y, tvListView.frame.size.width, 323.0);
}

- (BOOL)dateIndexed {
	return YES;
}

- (void)setNavigationBarTitle:(NSString *)title {
	self.navigationItem.title = NSLocalizedString(@"Search", nil);
}

- (NSString *)feedURL {
	if ([keyword length] == 0) {
		return nil;
	}
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	return [NSString stringWithFormat:
			@"http://tv.nikkansports.com/tv.php?mode=10&site=007&sort=d&shour=%d&lhour=24&area=%@&ldate=8&key=%@&template=rss&category=all&pageCharSet=UTF8",
			sharedTVListingsApp.shour, settings.area, [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)buildMoveTimeButtons {
	//Nothing to do.
}

- (void)showWaitingView {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	[waitingView setAlpha:0.5];
	[UIView commitAnimations];
}

- (void)hideWaitingView {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	[waitingView setAlpha:0.0];
	[UIView commitAnimations];
}

-(void)didRefleshData {
	[self hideWaitingView];
}

#pragma mark <UITableViewDataSource> Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSArray *keys = [programs allKeys];
	if ([keys count] == 0) {
		return nil;
	}
	NSString *titleForHeader = [[keys sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section];
	NSArray *components = [titleForHeader componentsSeparatedByString:@"|||"];
	return [NSString stringWithFormat:@"%@ %@", [components objectAtIndex:1], [components objectAtIndex:2]];
}

#pragma mark <UISearchBarDelegate> Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[self showWaitingView];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	self.keyword = searchBar.text;
	
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	
	[settings.keywordHistory removeObject:keyword];
	[settings.keywordHistory addObject:keyword];
	
	[searchBar resignFirstResponder];
	
	//[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refleshData:) userInfo:nil repeats:NO];
	[NSThread detachNewThreadSelector:@selector(_refleshData) toTarget:self withObject:nil];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
	[self showWaitingView];
	SearchBookmarkViewController *controller = [[[SearchBookmarkViewController alloc] initWithNibName:@"SearchBookmarkView" bundle:nil] autorelease];
	controller.tvSearchViewController = self;
	[self presentModalViewController:controller animated:YES];
}

#pragma mark <UIViewController> Methods


- (void)viewWillAppear:(BOOL)animated {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	if (settings.fontSize == SettingsFontSizeSmall) {
		[tvListView setRowHeight:42.0f];
	} else if (settings.fontSize == SettingsFontSizeMedium) {
		[tvListView setRowHeight:44.0f];
	} else if (settings.fontSize == SettingsFontSizeLarge) {
		[tvListView setRowHeight:66.0f];
	} else {
		[tvListView setRowHeight:76.0f];
	}
	
	[self.tvListView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	shouldNotReflesh = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	waitingView = [[WaitingView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 480.0)];
	waitingView.backgroundColor = [UIColor blackColor];
	waitingView.opaque = NO;
	waitingView.alpha = 0.0;
	waitingView.userInteractionEnabled = YES;
	((WaitingView *)waitingView).tvSearchviewController = self;
	[self.view addSubview:waitingView];
	
	shouldNotReflesh = YES;
}

@end

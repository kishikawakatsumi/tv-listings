#import "TVListingsAppDelegate.h"
#import "Debug.h"

#define TAB_VIEW_CONTROLLERS 7

@implementation TVListingsAppDelegate

static TVListingsAppDelegate *TVListingsApp = NULL;
static NSArray *regionList = NULL;
static NSArray *timeList = NULL;

@synthesize window;
@synthesize navigationController;
@synthesize tabBarController;
@synthesize settings;
@synthesize sharedDetailsViewController;
@synthesize dataFilePath;

@synthesize lhour;
@synthesize shour;
@synthesize sdate;

@synthesize baseDate;

@synthesize remoteHostStatus;
@synthesize internetConnectionStatus;
@synthesize localWiFiConnectionStatus;

- (NSInteger)getNowTimeOfDay {
	NSDate *now = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
	[formatter setDateFormat:@"HH"];
	return [[formatter stringFromDate:now] intValue];
}

- (NSString *)getNowDate {
	NSDate *now = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[formatter setDateFormat:@"yyyyMMdd"];
	return [formatter stringFromDate:now];
}

- (id)init {
	LOG_CURRENT_METHOD;
	if (!TVListingsApp) {
		TVListingsApp = [super init];
		
		sharedDetailsViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsView" bundle:nil];
		sharedDetailsViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		self.shour = [self getNowTimeOfDay];
		self.sdate = [self getNowDate];
		self.baseDate = [NSDate date];
	}
	return TVListingsApp;
}

+ (TVListingsAppDelegate *)sharedTVListingsApp {
	if (!TVListingsApp) {
		TVListingsApp = [[TVListingsAppDelegate alloc] init];
	}
	return TVListingsApp;
}

+ (NSArray *)regionList {
	if (!regionList) {
		regionList = [[NSArray alloc] initWithObjects:
					  NSLocalizedString(@"Hokkaido", nil),
					  NSLocalizedString(@"Aomori", nil),
					  NSLocalizedString(@"Akita", nil),
					  NSLocalizedString(@"Iwate", nil),
					  NSLocalizedString(@"Yamagata", nil),
					  NSLocalizedString(@"Miyagi", nil),
					  NSLocalizedString(@"Hukushima", nil),
					  NSLocalizedString(@"Tokyo", nil),
					  NSLocalizedString(@"Kanagawa", nil),
					  NSLocalizedString(@"Saitama", nil),
					  NSLocalizedString(@"Chiba", nil),
					  NSLocalizedString(@"Gumma", nil),
					  NSLocalizedString(@"Tochigi", nil),
					  NSLocalizedString(@"Ibaragi", nil),
					  NSLocalizedString(@"Niigata", nil),
					  NSLocalizedString(@"Nagano", nil),
					  NSLocalizedString(@"Yamanashi", nil),
					  NSLocalizedString(@"Shizuoka", nil),
					  NSLocalizedString(@"Aichi", nil),
					  NSLocalizedString(@"Gihu", nil),
					  NSLocalizedString(@"Mie", nil),
					  NSLocalizedString(@"Toyama", nil),
					  NSLocalizedString(@"Ishikawa", nil),
					  NSLocalizedString(@"Fukui", nil),
					  NSLocalizedString(@"Osaka", nil),
					  NSLocalizedString(@"Kyoto", nil),
					  NSLocalizedString(@"Hyogo", nil),
					  NSLocalizedString(@"Nara", nil),
					  NSLocalizedString(@"Wakayama", nil),
					  NSLocalizedString(@"Shiga", nil),
					  NSLocalizedString(@"Okayama", nil),
					  NSLocalizedString(@"Hiroshima", nil),
					  NSLocalizedString(@"Tottori", nil),
					  NSLocalizedString(@"Shimane", nil),
					  NSLocalizedString(@"Yamaguchi", nil),
					  NSLocalizedString(@"Kagawa", nil),
					  NSLocalizedString(@"Tokushima", nil),
					  NSLocalizedString(@"Ehime", nil),
					  NSLocalizedString(@"Kochi", nil),
					  NSLocalizedString(@"Fukuoka", nil),
					  NSLocalizedString(@"Saga", nil),
					  NSLocalizedString(@"Nagasaki", nil),
					  NSLocalizedString(@"Kumamoto", nil),
					  NSLocalizedString(@"Oita", nil),
					  NSLocalizedString(@"Miyazaki", nil),
					  NSLocalizedString(@"Kagoshima", nil),
					  NSLocalizedString(@"Okinawa", nil), nil];
	}
	return regionList;
}

+ (NSArray *)timeList {
	if (!timeList) {
		timeList = [[NSArray alloc] initWithObjects:
					@"0:00", @"1:00", @"2:00", @"3:00", @"4:00", @"5:00", @"6:00", @"7:00",
					@"8:00", @"9:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00",
					@"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", nil];
	}
	return timeList;
}

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [regionList release];
	[baseDate release];
	[sdate release];
	[dataFilePath release];
    [sharedDetailsViewController release];
    [settings release];
    [tabBarController release];
    [navigationController release];
    [window release];
    [super dealloc];
}

- (void)updateStatus {
	self.remoteHostStatus = [[Reachability sharedReachability] remoteHostStatus];
}

- (void)reachabilityChanged:(NSNotification *)note {
	LOG_CURRENT_METHOD;
	[self updateStatus];
	if (self.remoteHostStatus == NotReachable) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AppName", nil) message:NSLocalizedString(@"NotReachable", nil)
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
}

- (void)loadSettings {
	LOG_CURRENT_METHOD;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *path = [documentDirectory stringByAppendingPathComponent:@"settings.dat"];
	self.dataFilePath = path;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:path]) {
		NSMutableData *theData  = [NSMutableData dataWithContentsOfFile:path];
		NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		
		self.settings = [decoder decodeObjectForKey:@"settings"];
		
		[decoder finishDecoding];
		[decoder release];
		
		if (settings.version != CURRENT_VERSION) {
			LOG(@"migrate settings.");
			Settings *newSettings = [[Settings alloc] init];
			newSettings.version = CURRENT_VERSION;
			newSettings.area = settings.area;
			newSettings.lhour = settings.lhour;
			newSettings.primeTimeFrom = settings.primeTimeFrom;
			newSettings.primeTimeTo = settings.primeTimeTo;
			newSettings.fontSize = SettingsFontSizeSmall;
			newSettings.keywordHistory = settings.keywordHistory;
			//newSettings.orderOfViewControllers = settings.orderOfViewControllers;
			self.settings = newSettings;
		}
	} else {
		self.settings = [[Settings alloc] init];
	}	
}

- (void)saveSettings {
	LOG_CURRENT_METHOD;
	NSMutableData *theData = [NSMutableData data];
	NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:settings forKey:@"settings"];
	[encoder finishEncoding];
	
	[theData writeToFile:dataFilePath atomically:YES];
	[encoder release];
}

#pragma mark <UITabBarControllerDelegate> Methods

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
	if (changed) {
		settings.orderOfViewControllers = [[NSMutableArray alloc] initWithCapacity:TAB_VIEW_CONTROLLERS];
		for (UINavigationController *controller in viewControllers) {
			[settings.orderOfViewControllers addObject:[[controller.topViewController class] description]];
		}
	}
}

#pragma mark <UIApplicationDelegate> Methods

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	LOG_CURRENT_METHOD;
	
	[[Reachability sharedReachability] setHostName:@"tv.nikkansports.com"];
	[[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
												 name:@"kNetworkReachabilityChangedNotification" object:nil];
	[self updateStatus];
	
	[self loadSettings];
	
	self.lhour = settings.lhour;
	
	tabBarController.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	if (settings.orderOfViewControllers) {
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:TAB_VIEW_CONTROLLERS];
		for (UINavigationController *controller in tabBarController.viewControllers) {
			[dictionary setObject:controller forKey:[[controller.topViewController class] description]];
		}
		NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:TAB_VIEW_CONTROLLERS];
		for (NSString *controllerName in settings.orderOfViewControllers) {
			[controllers addObject:[dictionary objectForKey:controllerName]];
		}
		tabBarController.viewControllers = controllers;
	}
	
    [window addSubview:tabBarController.view];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	LOG_CURRENT_METHOD;
	[self saveSettings];
}

@end

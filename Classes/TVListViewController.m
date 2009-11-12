#import "TVListViewController.h"
#import "TVManager.h"
#import "TVProgram.h"
#import "TVProgramCell.h"
#import "DetailsViewController.h"
#import "TVListingsAppDelegate.h"
#import "UICCalendarPicker.h"
#import <QuartzCore/QuartzCore.h>
#import "Debug.h"

#if DEBUG
#define SERVICE_URI @"http://2nddsp-dev.appspot.com/epg"
#else
#define SERVICE_URI @"http://2nddsp.appspot.com/epg"
#endif

@implementation TVListViewController

@synthesize tvListView;
@synthesize moveTimeControl;
@synthesize manager;
@synthesize programs;
@synthesize area;
@synthesize category;

- (void)dealloc {
	[dateButton release];
	[gregorian release];
	[category release];
	[area release];
	[programs release];
	[manager release];
	[moveTimeControl release];
    [super dealloc];
}

- (NSString *)category {
	return @"g";
}

- (CGRect)preferredSize {
	CGRect frame = tvListView.frame;
	return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 367.0f);
}

- (BOOL)dateIndexed {
	return NO;
}

- (void)setNavigationBarTitle:(NSString *)title {
	LOG(@"set navigation bar title: %@", title);
	[dateButton release];
	dateButton = nil;
	dateButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[dateButton setEnabled:NO];
	[dateButton setFrame:CGRectMake(0.0f, 0.0f, 140.0f, 26.0f)];
	[dateButton setFont:[UIFont boldSystemFontOfSize:20.0f]];
	[dateButton setTitle:title forState:UIControlStateNormal];
	[dateButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[dateButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
	[dateButton addTarget:self action:@selector(moveDayOfWeek:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationItem setTitleView:dateButton];
}

- (NSString *)feedURL {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	return [NSString stringWithFormat:
            @"%@?category=%@&area=%@&sdate=%@&shour=%d&lhour=%d", 
            SERVICE_URI, self.category, settings.area, sharedTVListingsApp.sdate, sharedTVListingsApp.shour, sharedTVListingsApp.lhour];
}

- (void)enableButtons {
	[moveTimeControl setEnabled:YES forSegmentAtIndex:1];
	[moveTimeControl setEnabled:YES forSegmentAtIndex:3];
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	if (sharedTVListingsApp.shour == 0) {
		[moveTimeControl setEnabled:NO forSegmentAtIndex:0];
		[moveTimeControl setEnabled:YES forSegmentAtIndex:2];
	} else if (sharedTVListingsApp.shour == 48) {
		[moveTimeControl setEnabled:YES forSegmentAtIndex:0];
		[moveTimeControl setEnabled:NO forSegmentAtIndex:2];
	} else {
		[moveTimeControl setEnabled:YES forSegmentAtIndex:0];
		[moveTimeControl setEnabled:YES forSegmentAtIndex:2];
	}
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	if (sharedTVListingsApp.shour > 24) {
		NSDateComponents *offsetComponent = [[NSDateComponents alloc] init];
		[offsetComponent setDay:1];
		[self setNavigationBarTitle:[formatter stringFromDate:[gregorian dateByAddingComponents:offsetComponent toDate:sharedTVListingsApp.baseDate options:0]]];
        [offsetComponent release];
	} else {
		[self setNavigationBarTitle:[formatter stringFromDate:sharedTVListingsApp.baseDate]];
	}
	[dateButton setEnabled:YES];
}

-(void)willRefleshData {
	[dateButton setEnabled:NO];
	[moveTimeControl setEnabled:NO forSegmentAtIndex:0];
	[moveTimeControl setEnabled:NO forSegmentAtIndex:1];
	[moveTimeControl setEnabled:NO forSegmentAtIndex:2];
	[moveTimeControl setEnabled:NO forSegmentAtIndex:3];
}

-(void)didRefleshData {
	[self enableButtons];
}

- (IBAction)refleshData:(id)sender {
	[self performSelectorOnMainThread:@selector(willRefleshData) withObject:nil waitUntilDone:YES];
	self.programs = [manager getTVList:[self feedURL] dateIndexed:[self dateIndexed]];
	[tvListView reloadData];
	[self performSelectorOnMainThread:@selector(didRefleshData) withObject:nil waitUntilDone:YES];
}

- (void)_refleshData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self refleshData:nil];
	[pool release];
}

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

- (IBAction)moveTimeOfDay:(id)sender {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	UISegmentedControl* segmentedControl = sender;
	NSInteger selectedSegmentIndex = [segmentedControl selectedSegmentIndex];
	if (selectedSegmentIndex == 0) {
		sharedTVListingsApp.lhour = settings.lhour;
		NSInteger shour = sharedTVListingsApp.shour;
		sharedTVListingsApp.shour = --shour;
	} else if (selectedSegmentIndex == 1) {
		sharedTVListingsApp.lhour = settings.lhour;
		sharedTVListingsApp.shour = [self getNowTimeOfDay];
		sharedTVListingsApp.sdate = [self getNowDate];
		sharedTVListingsApp.baseDate = [NSDate date];
	} else if (selectedSegmentIndex == 2) {
		sharedTVListingsApp.lhour = settings.lhour;
		NSInteger shour = sharedTVListingsApp.shour;
		sharedTVListingsApp.shour = ++shour;
	} else {
		NSInteger indexFrom = [[TVListingsAppDelegate timeList] indexOfObject:settings.primeTimeFrom];
		NSInteger indexTo = [[TVListingsAppDelegate timeList] indexOfObject:settings.primeTimeTo];
		NSInteger lhour = 4;
		if (indexFrom == indexTo) {
			lhour = 1;
		} else if (indexFrom < indexTo) {
			lhour = indexTo - indexFrom;
		} else {
			lhour = (indexTo + 24) - indexFrom;
		}

		sharedTVListingsApp.lhour = lhour;
		sharedTVListingsApp.shour = indexFrom;
	}
	
	[self enableButtons];
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_refleshData) userInfo:nil repeats:NO];
}


- (IBAction)moveDayOfWeek:(id)sender {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	
	UIView *blockView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[blockView setTag:999];
	[blockView setBackgroundColor:[UIColor blackColor]];
	[blockView setAlpha:0.0f];
	[[[UIApplication sharedApplication] keyWindow] addSubview:blockView];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:blockView cache:NO];
	[blockView setAlpha:0.5f];
	[UIView commitAnimations];
	
	UICCalendarPicker *calendarPicker = [[UICCalendarPicker alloc] initWithSize:UICCalendarPickerSizeExtraLarge];
	[calendarPicker setDelegate:self];
	[calendarPicker addSelectedDate:sharedTVListingsApp.baseDate];
	[calendarPicker setMinDate:[NSDate dateWithTimeIntervalSinceNow:-86400 * 7]];
	[calendarPicker setMaxDate:[NSDate dateWithTimeIntervalSinceNow:86400 * 7]];
	[calendarPicker showAtPoint:CGPointMake(320.0f / 2 - calendarPicker.frame.size.width / 2, 64.0f) inView:[[UIApplication sharedApplication] keyWindow] animated:YES];
	[calendarPicker release];
	
	[blockView release];
}

#pragma mark <UICCalendarPickerDelegate> Methods

- (void)picker:(UICCalendarPicker *)picker didSelectDate:(NSArray *)selectedDate {
	LOG_CURRENT_METHOD;
	
	if ([selectedDate count] == 0) {
		return;
	}
	
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[dateFormatter setDateFormat:@"yyyyMMdd"];
	
	NSInteger shour = sharedTVListingsApp.shour;
	if (shour >= 24) {
		shour = shour - 24;
	}
	
	sharedTVListingsApp.baseDate = [selectedDate lastObject];
	sharedTVListingsApp.sdate = [dateFormatter stringFromDate:sharedTVListingsApp.baseDate];
	sharedTVListingsApp.shour = shour;
	
	[dateFormatter setDateFormat:@"yyyy/MM/dd"];
	[self setNavigationBarTitle:[dateFormatter stringFromDate:sharedTVListingsApp.baseDate]];
	
	[NSThread detachNewThreadSelector:@selector(_refleshData) toTarget:self withObject:nil];
	
	[picker dismiss:nil animated:YES];

	UIView *blockView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:999];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:blockView cache:NO];
	[blockView setAlpha:0.0f];
	[UIView commitAnimations];
}

- (void)picker:(UICCalendarPicker *)picker pushedCloseButton:(id)sender {
	[picker dismiss:sender animated:YES];
	
	UIView *blockView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:999];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:blockView cache:NO];
	[blockView setAlpha:0.0f];
	[UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	UIView *blockView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:999];
	[blockView removeFromSuperview];
}

- (void)buildMoveTimeButtons {
	self.moveTimeControl = [[[UISegmentedControl alloc] initWithItems:
							 [NSArray arrayWithObjects:
							  [UIImage imageNamed:@"up.png"],
							  [UIImage imageNamed:@"now.png"],
							  [UIImage imageNamed:@"down.png"],
							  [UIImage imageNamed:@"crown.png"],
							  nil]] autorelease];
	[moveTimeControl addTarget:self action:@selector(moveTimeOfDay:) forControlEvents:UIControlEventValueChanged];
	CGRect frame = moveTimeControl.frame;
	moveTimeControl.frame = CGRectMake(frame.origin.x, frame.origin.y, 136.0f, 30.0f);
	moveTimeControl.segmentedControlStyle = UISegmentedControlStyleBar;
	moveTimeControl.momentary = YES;
	moveTimeControl.tintColor = [UIColor darkGrayColor];
	[moveTimeControl setEnabled:NO forSegmentAtIndex:0];
	[moveTimeControl setEnabled:NO forSegmentAtIndex:1];
	[moveTimeControl setEnabled:NO forSegmentAtIndex:2];
	[moveTimeControl setEnabled:NO forSegmentAtIndex:3];
	UIBarButtonItem *moveTimeBarItem = [[[UIBarButtonItem alloc] initWithCustomView:moveTimeControl] autorelease];
	self.navigationItem.rightBarButtonItem = moveTimeBarItem;
}

#pragma mark <UITableViewDataSource> Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger count = [[programs allKeys] count];
	if (count == 0) {
		return 1;
	}
	return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSArray *keys = [programs allKeys];
	if ([keys count] == 0) {
		return nil;
	}
	NSString *titleForHeader = [[keys sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section];
	return [[titleForHeader componentsSeparatedByString:@"|||"] objectAtIndex:2];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *keys = [programs allKeys];
	if ([keys count] == 0) {
		return 0;
	}
	return [[programs objectForKey:[[keys sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	TVProgramCell *cell = (TVProgramCell *)[tableView dequeueReusableCellWithIdentifier:@"TVProgramCell"];
    if (cell == nil) {
        cell = [[[TVProgramCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TVProgramCell"] autorelease];
    }
    
    if (settings.fontSize == SettingsFontSizeSmall) {
        cell.frame = CGRectMake(0.0f, 0.0f, 320.0f, 42.0f);
    } else if (settings.fontSize == SettingsFontSizeMedium) {
        cell.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
    } else if (settings.fontSize == SettingsFontSizeLarge) {
        cell.frame = CGRectMake(0.0f, 0.0f, 320.0f, 66.0f);
    } else {
        cell.frame = CGRectMake(0.0f, 0.0f, 320.0f, 76.0f);
    }
    
    cell.fontSize = settings.fontSize;
	
	NSArray *keys = [programs allKeys];
	TVProgram *program = [[programs objectForKey:[[keys sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	cell.title = program.title;
	cell.detail = program.details;
	cell.time = program.time;
	cell.date = program.date;
	cell.category = program.category;
    if ([program.link length] == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark <UITableViewDelegate> Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DetailsViewController *controller = [[TVListingsAppDelegate sharedTVListingsApp] sharedDetailsViewController];
	NSArray *keys = [programs allKeys];
	TVProgram *program = [[programs objectForKey:[[keys sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	if ([program.link length]) {
		controller.title = program.title;
		controller.detailPageURL = program.link;
		controller.hidesBottomBarWhenPushed = YES;
		shouldNotReflesh = YES;
		[self.navigationController pushViewController:controller animated:YES];
	} else {
		[tvListView deselectRowAtIndexPath:[tvListView indexPathForSelectedRow] animated:YES];
	}
}

#pragma mark <UIViewController> Methods

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
    self.view = contentView;
    [contentView release];
    
    tvListView  = [[UITableView alloc] initWithFrame:contentView.frame];
    tvListView.dataSource = self;
    tvListView.delegate = self;
    [contentView addSubview:tvListView];
    [tvListView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	[self setNavigationBarTitle:[formatter stringFromDate:sharedTVListingsApp.baseDate]];
	
	self.manager = [[TVManager alloc] init];
	
	[self buildMoveTimeButtons];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
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
		
	tvListView.frame = [self preferredSize];
	[tvListView deselectRowAtIndexPath:[tvListView indexPathForSelectedRow] animated:YES];
    [tvListView flashScrollIndicators];
	
	if (!shouldNotReflesh) {
		[NSThread detachNewThreadSelector:@selector(_refleshData) toTarget:self withObject:nil];
	} else {
		shouldNotReflesh = NO;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

#import "PrimeTimeSettingViewController.h"
#import "TVListingsAppDelegate.h"
#import "Debug.h"

@interface UIPickerView (Extented)

- (void)setSoundsEnabled:(BOOL)enabled;

@end

@implementation PrimeTimeSettingViewController

@synthesize primeTimePicker;

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[primeTimePicker setDelegate:nil];
	[primeTimePicker release];
    [super dealloc];
}

#pragma mark <UIPickerViewDataSource> Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return NSIntegerMax;
}

#pragma mark <UIPickerViewDelegate> Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[TVListingsAppDelegate timeList] objectAtIndex:row % 24];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	if (component == 0) {
		settings.primeTimeFrom = [[TVListingsAppDelegate timeList] objectAtIndex:row % 24];
	} else {
		settings.primeTimeTo = [[TVListingsAppDelegate timeList] objectAtIndex:row % 24];
	}
}

#pragma mark <UIViewController> Methods

- (void)viewDidLoad {
    [super viewDidLoad];
	TVListingsAppDelegate *sharedTVListingsApp = [TVListingsAppDelegate sharedTVListingsApp];
	Settings *settings = sharedTVListingsApp.settings;
	[primeTimePicker setSoundsEnabled:NO];
	NSInteger indexOfFrom = [[TVListingsAppDelegate timeList] indexOfObject:settings.primeTimeFrom];
	[primeTimePicker selectRow:24 * 100 + indexOfFrom inComponent:0 animated:NO];
	NSInteger indexOfTo = [[TVListingsAppDelegate timeList] indexOfObject:settings.primeTimeTo];
	[primeTimePicker selectRow:24 * 100 + indexOfTo inComponent:1 animated:NO];
	[primeTimePicker setSoundsEnabled:YES];
}
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

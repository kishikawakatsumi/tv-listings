#import "PrimeTimeSettingViewController.h"
#import "TVListingsAppDelegate.h"
#import "Debug.h"

@interface UIPickerView (Extented)
- (void)setSoundsEnabled:(BOOL)enabled;
@end

@implementation PrimeTimeSettingViewController

- (void)dealloc {
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

- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
    contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = contentView;
    [contentView release];
    
    primeTimePicker  = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 75.0f, 320.0f, 216.0f)];
    primeTimePicker.dataSource = self;
    primeTimePicker.delegate = self;
    primeTimePicker.showsSelectionIndicator = YES;
    [contentView addSubview:primeTimePicker];
    [primeTimePicker release];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

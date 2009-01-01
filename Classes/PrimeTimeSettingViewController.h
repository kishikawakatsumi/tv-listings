#import <UIKit/UIKit.h>

@interface PrimeTimeSettingViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UIPickerView *primeTimePicker;
}

@property (nonatomic, retain) UIPickerView *primeTimePicker;

@end

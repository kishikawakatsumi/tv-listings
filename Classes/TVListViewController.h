#import <UIKit/UIKit.h>
#import "TVManager.h"

@interface TVListViewController :
UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
	IBOutlet UITableView *tvListView;
	UISegmentedControl *moveTimeControl;
	TVManager *manager;
	NSDictionary *programs;
	NSString *area;
	NSString *category;
	NSCalendar *gregorian;
	BOOL shouldNotReflesh;
	UIButton *dateButton;
}

@property (nonatomic, retain) UITableView *tvListView;
@property (nonatomic, retain) UISegmentedControl *moveTimeControl;
@property (nonatomic, retain) TVManager *manager;
@property (nonatomic, retain) NSDictionary *programs;
@property (nonatomic, retain) NSString *area;
@property (nonatomic, retain) NSString *category;

- (IBAction)refleshData:(id)sender;
- (IBAction)moveTimeOfDay:(id)sender;

@end

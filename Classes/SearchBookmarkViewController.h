#import <UIKit/UIKit.h>
#import "TVSearchViewController.h"

@interface SearchBookmarkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *keywordHistoryView;
	TVSearchViewController *tvSearchViewController;
}

@property (nonatomic, retain) UITableView *keywordHistoryView;
@property (nonatomic, retain) TVSearchViewController *tvSearchViewController;

- (IBAction)clearButtonClicked;
- (IBAction)cancelButtonClicked;

@end

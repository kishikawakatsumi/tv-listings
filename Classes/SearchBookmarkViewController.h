#import <UIKit/UIKit.h>
#import "TVSearchViewController.h"

@interface SearchBookmarkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *keywordHistoryView;
	TVSearchViewController *tvSearchViewController;
}

@property (nonatomic, assign) TVSearchViewController *tvSearchViewController;

- (IBAction)clearButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end

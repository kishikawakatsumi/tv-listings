#import <UIKit/UIKit.h>
#import "TVListViewController.h"

@interface TVSearchViewController : TVListViewController <UISearchBarDelegate> {
	IBOutlet UISearchBar *tvSearchBar;
	NSString *keyword;
	UIView *waitingView;
}

@property (nonatomic, retain) UISearchBar *tvSearchBar;
@property (nonatomic, retain) NSString *keyword;

- (void)showWaitingView;
- (void)hideWaitingView;

@end

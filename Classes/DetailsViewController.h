#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *detailsView;
	NSString *detailPageURL;
}

@property (nonatomic, retain) NSString *detailPageURL;

@end
